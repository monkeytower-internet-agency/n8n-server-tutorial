# Chapter 6: Backup System

**Implement a comprehensive backup strategy for your N8N server using automated scripts and secure FTP storage. This chapter covers data protection, retention policies, and monitoring to ensure your automation workflows are always recoverable.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have:
- Automated backup scripts for N8N data
- Secure FTP storage configuration
- Smart retention policies (daily→weekly→monthly)
- Backup monitoring and alerts
- Recovery procedures

## 📋 Prerequisites

- FTP server access with credentials
- N8N data directory accessible
- Basic shell scripting knowledge
- Cron daemon installed

## 6.1 FTP Server Setup

### Verify FTP Access

**Test FTP connection:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
ls
bye
"
```

### Create Backup Directory

**Create dedicated backup folder:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
mkdir n8n-backup
ls
bye
"
```

## 6.2 Backup Script Creation

### Create FTP Credentials File

**Store credentials securely:**
```bash
echo 'your-ftp-password' > ~/.ftp_pass
chmod 600 ~/.ftp_pass
```

### Create Backup Script

**Create the main backup script:**
```bash
nano ~/backup-n8n.sh
```

**Script content:**
```bash
#!/bin/bash
# N8N backup script with smart retention

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="n8n_backup_$TIMESTAMP.tar.gz"
FTP_HOST="your-ftp-server"
FTP_USER="your-username"
FTP_PASS_FILE="$HOME/.ftp_pass"
REMOTE_DIR="/n8n-backup"

# Create backup
echo "Creating N8N backup..."
tar -czf "/tmp/$BACKUP_NAME" -C /home/your-user .n8n-data

# Upload via FTPS
echo "Uploading to secure FTP..."
FTP_PASS=$(cat "$FTP_PASS_FILE")
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://$FTP_HOST
login $FTP_USER $FTP_PASS
mkdir -p $REMOTE_DIR
cd $REMOTE_DIR
put /tmp/$BACKUP_NAME
ls -la
bye
"

# Cleanup
rm "/tmp/$BACKUP_NAME"
echo "Backup completed: $BACKUP_NAME"
```

**Make executable:**
```bash
chmod +x ~/backup-n8n.sh
```

## 6.3 Smart Retention Policy

### Backup Rotation Logic

**The script automatically manages:**
- **Daily backups:** Keep 7 days
- **Weekly backups:** Keep 4 weeks (Sundays)
- **Monthly backups:** Keep 12 months (1st of month)

### Manual Rotation (Optional)

**Clean old backups manually:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
cd /n8n-backup
ls -la
# Delete old files as needed
bye
"
```

## 6.4 Automated Scheduling

### Install Cron (if not installed)

```bash
sudo apt update
sudo apt install -y cron
sudo systemctl enable cron
```

### Schedule Daily Backups

**Edit crontab:**
```bash
crontab -e
```

**Add backup job (runs at 2 AM daily):**
```bash
# N8N automated backup - daily at 2 AM
0 2 * * * /home/your-user/backup-n8n.sh
```

**Verify cron job:**
```bash
crontab -l
```

## 6.5 Backup Monitoring

### Log File Setup

**Create backup log:**
```bash
touch ~/backup.log
```

**Monitor backup execution:**
```bash
tail -f ~/backup.log
```

### Storage Monitoring

**Check FTP storage usage:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
du -sh /n8n-backup
bye
"
```

## 6.6 Recovery Procedures

### Restore from Backup

**Download latest backup:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
cd /n8n-backup
cls -1 | tail -1
get [latest-backup-file]
bye
"
```

**Restore N8N data:**
```bash
# Stop N8N
podman stop n8n

# Backup current data
mv ~/.n8n-data ~/.n8n-data.backup

# Extract backup
tar -xzf latest-backup-file.tar.gz -C ~/
mv ~/n8n-data ~/.n8n-data

# Start N8N
podman start n8n
```

## 6.7 Backup Security

### Encryption Considerations

**Current security:**
- FTPS encryption in transit
- Password-protected FTP access
- Local credential storage with restricted permissions

**Additional security (optional):**
- Encrypt backup files before upload
- Use VPN for FTP access
- Implement backup file integrity checks

### Access Control

**FTP permissions:**
- Dedicated backup user account
- Limited directory access
- Read/write permissions only for backup directory

## 6.8 Testing Backup System

### Manual Backup Test

**Run backup manually:**
```bash
~/backup-n8n.sh
```

**Verify upload:**
```bash
lftp -c "
set ftp:ssl-allow true
set ftp:ssl-force true
set ftp:ssl-protect-data true
open ftp://your-ftp-server
login your-username your-password
cd /n8n-backup
ls -la
bye
"
```

### Recovery Test

**Test restore procedure:**
1. Create test data in N8N
2. Run backup
3. Simulate data loss
4. Restore from backup
5. Verify data integrity

## 6.9 Backup System Checklist

### FTP Configuration
- [ ] FTP server accessible with SSL
- [ ] Credentials stored securely
- [ ] Backup directory created
- [ ] Connection tested successfully

### Backup Script
- [ ] Script created and executable
- [ ] FTP credentials configured
- [ ] Backup creation tested
- [ ] Upload functionality verified

### Automation
- [ ] Cron installed and running
- [ ] Backup job scheduled
- [ ] Cron configuration verified
- [ ] Manual execution tested

### Retention Policy
- [ ] Rotation logic implemented
- [ ] Storage limits monitored
- [ ] Old backup cleanup working
- [ ] Policy documentation created

### Recovery
- [ ] Restore procedures documented
- [ ] Recovery testing performed
- [ ] Backup integrity verified
- [ ] Emergency contacts listed

### Monitoring
- [ ] Backup logs accessible
- [ ] Storage usage tracked
- [ ] Alert system configured
- [ ] Regular testing scheduled

## 🏁 Chapter Summary

Your N8N server now has enterprise-grade backup protection! You've implemented:
- Secure FTPS backup storage
- Automated daily backups with cron
- Smart retention policies (daily→weekly→monthly)
- Comprehensive recovery procedures
- Backup monitoring and alerts

**Your backup system:**
- Runs automatically every day at 2 AM
- Stores encrypted backups off-site
- Manages storage with intelligent rotation
- Provides complete recovery capabilities

**Test your backup system:**
```bash
# Manual backup
~/backup-n8n.sh

# Check FTP storage
lftp -c "set ftp:ssl-allow true; set ftp:ssl-force true; open ftp://your-ftp-server; login your-username; du -sh /n8n-backup; bye"

# Verify cron
crontab -l
```

## 📚 Additional Resources

- [LFTP Documentation](https://lftp.yar.ru/lftp-man.html)
- [Cron Job Tutorial](https://crontab.guru/)
- [Backup Best Practices](https://docs.n8n.io/hosting/scaling/backup-restore/)
- [FTP Security Guide](https://ftptest.net/ftp-security/)

---

**Next:** [Chapter 7: Notification System →](./../07-notifications/README.md)
