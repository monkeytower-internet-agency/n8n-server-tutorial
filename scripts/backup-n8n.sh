#!/bin/bash
# Enhanced n8n backup script with smart notifications

# Configuration
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="n8n_backup_$TIMESTAMP.tar.gz"
FTP_HOST="your-ftp-server"
FTP_USER="your-username"
FTP_PASS_FILE="$HOME/.ftp_pass"
REMOTE_DIR="/n8n-backup"
WEBHOOK_URL_FILE="$HOME/.google_chat_webhook"

# Function to send smart notifications
send_notification() {
    local message="$1"
    local is_critical="${2:-false}"
    
    if [ -f "$WEBHOOK_URL_FILE" ]; then
        WEBHOOK_URL=$(cat "$WEBHOOK_URL_FILE")
        
        if [ "$is_critical" = "true" ]; then
            # Critical alerts: Simple text with user mention
            curl -X POST -H 'Content-Type: application/json' \
                 "$WEBHOOK_URL" \
                 -d "{\"text\": \"@Olaf Klein 🚨 CRITICAL: $message\"}" \
                 2>/dev/null || echo "Notification failed"
        else
            # Normal notifications: Simple text with emoji
            curl -X POST -H 'Content-Type: application/json' \
                 "$WEBHOOK_URL" \
                 -d "{\"text\": \"🖥️ minin8n Server: $message\"}" \
                 2>/dev/null || echo "Notification failed"
        fi
    else
        echo "Google Chat webhook not configured"
    fi
}

# Function to check FTP storage usage and alert if running low
check_storage_usage() {
    local usage
    usage=$(lftp -c "
        set ftp:ssl-allow true
        set ftp:ssl-force true
        set ftp:ssl-protect-data true
        open ftp://$FTP_HOST
        login $FTP_USER $(cat "$FTP_PASS_FILE")
        du -sh $REMOTE_DIR
        bye
    " 2>/dev/null | grep -o '[0-9]*\.[0-9]*[KMG]' | head -1)
    
    # Check if storage is getting low (>80% of 2GB = 1.6GB)
    if [[ $usage =~ ([0-9.]+)([KMG]) ]]; then
        local size=${BASH_REMATCH[1]}
        local unit=${BASH_REMATCH[2]}
        
        # Convert to MB for comparison
        local size_mb
        case $unit in
            K) size_mb=$(echo "scale=2; $size / 1024" | bc) ;;
            M) size_mb=$size ;;
            G) size_mb=$(echo "scale=2; $size * 1024" | bc) ;;
        esac
        
        if (( $(echo "$size_mb > 1600" | bc -l) )); then
            send_notification "FTP storage running low: ${usage}MB used (2GB limit). Please review backup retention policy." "true"
        fi
    fi
    
    echo "$usage"
}

# Function to rotate backups
rotate_backups() {
    local current_date=$(date +%s)
    local deleted_count=0
    
    lftp -c "
        set ftp:ssl-allow true
        set ftp:ssl-force true
        set ftp:ssl-protect-data true
        open ftp://$FTP_HOST
        login $FTP_USER $(cat "$FTP_PASS_FILE")
        cd $REMOTE_DIR
        cls -1
    " 2>/dev/null | while read -r filename; do
        if [[ $filename =~ n8n_backup_([0-9]{8})_([0-9]{6})\.tar\.gz ]]; then
            backup_date="${BASH_REMATCH[1]}"
            backup_time="${BASH_REMATCH[2]}"
            backup_timestamp=$(date -d "${backup_date:0:4}-${backup_date:4:2}-${backup_date:6:2} ${backup_time:0:2}:${backup_time:2:2}:${backup_time:4:2}" +%s 2>/dev/null)
            
            if [ $? -eq 0 ]; then
                age_days=$(( (current_date - backup_timestamp) / 86400 ))
                
                # Keep daily backups for 7 days
                if [ $age_days -gt 7 ]; then
                    day_of_week=$(date -d "@$backup_timestamp" +%w)
                    if [ "$day_of_week" != "0" ]; then
                        lftp -c "
                            set ftp:ssl-allow true
                            set ftp:ssl-force true
                            set ftp:ssl-protect-data true
                            open ftp://$FTP_HOST
                            login $FTP_USER $(cat "$FTP_PASS_FILE")
                            cd $REMOTE_DIR
                            rm $filename
                            bye
                        " 2>/dev/null
                        deleted_count=$((deleted_count + 1))
                    fi
                fi
                
                # After 30 days, keep only 1st of month backups
                if [ $age_days -gt 30 ]; then
                    day_of_month=$(date -d "@$backup_timestamp" +%d)
                    if [ "$day_of_month" != "01" ]; then
                        lftp -c "
                            set ftp:ssl-allow true
                            set ftp:ssl-force true
                            set ftp:ssl-protect-data true
                            open ftp://$FTP_HOST
                            login $FTP_USER $(cat "$FTP_PASS_FILE")
                            cd $REMOTE_DIR
                            rm $filename
                            bye
                        " 2>/dev/null
                        deleted_count=$((deleted_count + 1))
                    fi
                fi
            fi
        fi
    done
    
    echo "Cleaned up $deleted_count old backup files"
}

# Main backup process
echo "Starting n8n backup..."

# Check storage usage
STORAGE_USAGE=$(check_storage_usage)
echo "Current FTP storage usage: $STORAGE_USAGE"

# Rotate old backups
echo "Rotating old backups..."
CLEANUP_MSG=$(rotate_backups)
echo "$CLEANUP_MSG"

# Create new backup
echo "Creating n8n backup..."
tar -czf "/tmp/$BACKUP_NAME" -C /home/ok .n8n-data

# Upload via FTPS
echo "Uploading to secure FTP..."
FTP_PASS=$(cat "$FTP_PASS_FILE")
if lftp -c "
    set ftp:ssl-allow true
    set ftp:ssl-force true
    set ftp:ssl-protect-data true
    open ftp://$FTP_HOST
    login $FTP_USER $FTP_PASS
    mkdir -p $REMOTE_DIR
    cd $REMOTE_DIR
    put /tmp/$BACKUP_NAME
    ls -la $BACKUP_NAME
    bye
" 2>/dev/null; then
    send_notification "✅ Backup successful: $BACKUP_NAME | Storage: $STORAGE_USAGE | $CLEANUP_MSG"
    echo "Backup completed successfully: $BACKUP_NAME"
else
    send_notification "Backup failed: $BACKUP_NAME. Check FTP connection and storage space." "true"
    echo "Backup failed!"
    exit 1
fi

# Cleanup local temp file
rm "/tmp/$BACKUP_NAME"
