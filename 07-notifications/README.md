# Chapter 7: Notification System

**Set up intelligent notifications for your N8N server using Google Messages. This chapter covers webhook configuration, smart alert routing, and user mention setup to keep you informed about critical system events.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have:
- Google Messages webhook integration
- Smart notification routing (normal vs critical)
- User mention configuration for urgent alerts
- Automated monitoring alerts
- Customizable notification preferences

## 📋 Prerequisites

- Google Workspace account
- Google Messages space for notifications
- N8N server running
- Basic webhook understanding
- Google Chat access

## 7.1 Google Chat Webhook Setup

### Create Google Chat Space

**Create a dedicated space:**
1. Open Google Chat
2. Click "Create a space" or "Start a chat"
3. Choose "Create a space"
4. Name: "N8N Server Monitoring"
5. Add yourself as member

### Configure Webhook

**Set up webhook integration:**
1. Click space name → "Apps & integrations"
2. Click "Manage webhooks"
3. Click "Add webhook"
4. Name: "N8N Server Alerts"
5. Avatar: Upload server icon (optional)
6. Click "Save"

**Copy webhook URL:**
- Save the generated URL securely
- Format: `https://chat.googleapis.com/v1/spaces/.../messages?key=...&token=...`

## 7.2 Webhook Configuration

### Store Webhook Securely

**Create webhook configuration:**
```bash
echo 'https://chat.googleapis.com/v1/spaces/YOUR_SPACE_ID/messages?key=YOUR_KEY&token=YOUR_TOKEN' > ~/.google_chat_webhook
chmod 600 ~/.google_chat_webhook
```

**Verify webhook:**
```bash
curl -X POST -H 'Content-Type: application/json' \
     "$(cat ~/.google_chat_webhook)" \
     -d '{"text": "Webhook test successful!"}'
```

## 7.3 Notification Script Setup

### Create Notification Function

**The notification system uses smart routing:**
- **Normal notifications:** Simple text format
- **Critical alerts:** Include user mentions for immediate attention

### Test Notifications

**Test normal notification:**
```bash
curl -X POST -H 'Content-Type: application/json' \
     "$(cat ~/.google_chat_webhook)" \
     -d '{"text": "🖥️ N8N Server: Backup completed successfully"}'
```

**Test critical alert:**
```bash
curl -X POST -H 'Content-Type: application/json' \
     "$(cat ~/.google_chat_webhook)" \
     -d '{"text": "<users/YOUR_USER_ID> 🚨 CRITICAL: Server requires immediate attention"}'
```

## 7.4 User Mention Configuration

### Find Your Google User ID

**Method 1: Google People API**
1. Visit: `https://developers.google.com/people/api/rest/v1/people/get`
2. Use resource name: `people/me`
3. Authenticate and get your user ID

**Method 2: Browser Inspection**
1. Send message in Google Chat
2. Open browser developer tools
3. Check network requests for user ID

### Configure User ID

**Once you have your User ID:**
```bash
echo 'YOUR_GOOGLE_USER_ID' > ~/.google_user_id
```

**Example:**
```bash
echo '106934917816127292879' > ~/.google_user_id
```

## 7.5 Integration with Monitoring Scripts

### Update Backup Script

**The backup script automatically sends notifications:**
- Success: Normal notification
- Failure: Critical alert with user mention

### Update System Monitoring

**System update checks send:**
- New updates available: Normal notification
- Security updates: Critical alert with mention

## 7.6 Notification Types

### Backup Notifications

**Successful backup:**
```
🖥️ N8N Server: ✅ Backup successful: n8n_backup_20241116_020000.tar.gz | Storage: 45KB | Cleaned up 0 files
```

**Failed backup:**
```
<users/YOUR_USER_ID> 🚨 CRITICAL: Backup failed: n8n_backup_20241116_020000.tar.gz. Check FTP connection and storage space.
```

### System Notifications

**Updates available:**
```
🖥️ N8N Server: 📦 5 packages available (2 security updates)
```

**Security updates:**
```
<users/YOUR_USER_ID> 🚨 CRITICAL: 📦 2 security updates available for immediate installation
```

### Storage Alerts

**Storage warning:**
```
<users/YOUR_USER_ID> 🚨 CRITICAL: FTP storage running low: 1.8GB used (2GB limit). Please review backup retention policy.
```

## 7.7 Advanced Configuration

### Custom Notification Rules

**Modify notification thresholds:**
```bash
# In backup script
STORAGE_THRESHOLD=80  # Alert at 80% capacity
```

**Add custom alerts:**
```bash
# Example: Disk space monitoring
DISK_USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt 90 ]; then
    send_notification "Disk usage critical: ${DISK_USAGE}%" "true"
fi
```

### Notification Scheduling

**Current schedule:**
- Backups: Daily at 2 AM
- Updates: Daily at 6 AM
- Storage: Real-time monitoring

**Customize timing:**
```bash
# Edit crontab
crontab -e

# Change times as needed
# 0 2 * * * /home/user/backup-n8n.sh  # 2 AM daily
# 0 6 * * * /home/user/update-checker.sh  # 6 AM daily
```

## 7.8 Troubleshooting Notifications

### Webhook Issues

**Test webhook directly:**
```bash
curl -X POST -H 'Content-Type: application/json' \
     "$(cat ~/.google_chat_webhook)" \
     -d '{"text": "Test message"}'
```

**Check webhook URL format:**
```bash
cat ~/.google_chat_webhook
# Should start with: https://chat.googleapis.com/v1/spaces/
```

### User Mention Issues

**Verify user ID:**
```bash
cat ~/.google_user_id
```

**Test mention format:**
```bash
USER_ID=$(cat ~/.google_user_id)
curl -X POST -H 'Content-Type: application/json' \
     "$(cat ~/.google_chat_webhook)" \
     -d "{\"text\": \"<users/$USER_ID> Test mention\"}"
```

### Permission Issues

**Google Chat permissions:**
- Webhook must be created by space member
- Space must allow webhooks
- User must be space member for mentions

## 7.9 Notification System Checklist

### Google Chat Setup
- [ ] Google Chat space created
- [ ] Webhook configured and tested
- [ ] Webhook URL stored securely
- [ ] Avatar configured (optional)

### User Configuration
- [ ] Google User ID obtained
- [ ] User ID stored securely
- [ ] Mention format tested
- [ ] Mention permissions verified

### Script Integration
- [ ] Backup script sends notifications
- [ ] Update checker sends notifications
- [ ] Storage monitoring active
- [ ] Cron jobs configured

### Testing
- [ ] Normal notifications working
- [ ] Critical alerts with mentions working
- [ ] Webhook error handling tested
- [ ] Notification timing verified

### Monitoring
- [ ] Alert history tracked
- [ ] Notification delivery confirmed
- [ ] False positive rate monitored
- [ ] Alert thresholds optimized

## 🏁 Chapter Summary

Your N8N server now has intelligent notifications! You've implemented:
- Google Chat webhook integration
- Smart alert routing (normal vs critical)
- User mentions for urgent issues
- Automated monitoring notifications
- Customizable alert thresholds

**Your notification system:**
- Sends normal updates without disturbing you
- @mentions you for critical issues requiring attention
- Provides detailed context for troubleshooting
- Works 24/7 with automated monitoring

**Test your notifications:**
```bash
# Test normal notification
curl -X POST -H 'Content-Type: application/json' "$(cat ~/.google_chat_webhook)" -d '{"text": "🖥️ N8N Server: Test notification"}'

# Test critical alert
USER_ID=$(cat ~/.google_user_id)
curl -X POST -H 'Content-Type: application/json' "$(cat ~/.google_chat_webhook)" -d "{\"text\": \"<users/$USER_ID> 🚨 CRITICAL: Test alert\"}"
```

## 📚 Additional Resources

- [Google Chat Webhooks](https://developers.google.com/chat/how-tos/webhooks)
- [Google People API](https://developers.google.com/people/api/rest/v1/people/get)
- [Cron Job Monitoring](https://crontab.guru/)
- [Webhook Security Best Practices](https://developers.google.com/chat/security)

---

**Next:** [Chapter 8: Git Repository Setup →](./../08-git-setup/README.md)
