#!/bin/bash
# System update checker with smart notifications

WEBHOOK_URL_FILE="$HOME/.google_chat_webhook"
LAST_CHECK_FILE="$HOME/.last_update_check"
UPDATE_LOG="$HOME/update_check.log"

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

# Check if we should run (only once per day)
if [ -f "$LAST_CHECK_FILE" ]; then
    LAST_CHECK=$(cat "$LAST_CHECK_FILE")
    CURRENT_TIME=$(date +%s)
    TIME_DIFF=$((CURRENT_TIME - LAST_CHECK))
    
    # Only check once per day (86400 seconds)
    if [ $TIME_DIFF -lt 86400 ]; then
        echo "Update check already performed today"
        exit 0
    fi
fi

echo "$(date): Starting update check" >> "$UPDATE_LOG"

# Update package lists
sudo apt update >> "$UPDATE_LOG" 2>&1

# Check for available updates
UPDATES=$(apt list --upgradable 2>/dev/null | grep -v "Listing..." | wc -l)
SECURITY_UPDATES=$(apt list --upgradable 2>/dev/null | grep -i security | wc -l)

if [ "$UPDATES" -gt 0 ]; then
    MESSAGE="📦 $UPDATES packages available"
    if [ "$SECURITY_UPDATES" -gt 0 ]; then
        MESSAGE="$MESSAGE ($SECURITY_UPDATES security updates)"
        IS_CRITICAL="true"
    fi
    
    send_notification "$MESSAGE" "$IS_CRITICAL"
    echo "$(date): Found $UPDATES updates, notification sent" >> "$UPDATE_LOG"
else
    echo "$(date): No updates available" >> "$UPDATE_LOG"
fi

# Update last check timestamp
date +%s > "$LAST_CHECK_FILE"
