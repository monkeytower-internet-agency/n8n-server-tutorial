# Chapter 10: Maintenance & Updates

**Keep your N8N server secure and performant with regular maintenance. This chapter covers system updates, container upgrades, and routine cleanup tasks.**

## 🎯 What You'll Learn

By the end of this chapter, you'll know how to:
- Update the host operating system securely
- Update N8N to the latest version
- Clean up unused Docker/Podman resources
- Manage system logs and disk space

## 📋 Prerequisites

- SSH access to your server
- Sudo privileges
- Current backup of your data (see Chapter 7)

---

## 10.1 Host System Updates

Regular system updates are critical for security.

### Check for Updates
```bash
sudo apt update
```

### Install Updates
```bash
sudo apt upgrade -y
```

### Reboot if Required
If the kernel was updated, you'll see a "System restart required" message.
```bash
# Check if reboot is needed
if [ -f /var/run/reboot-required ]; then echo 'Reboot required'; fi

# Reboot the server
sudo reboot
```

---

## 10.2 Updating N8N

We use **Quadlet** (Systemd + Podman) to manage N8N, which makes updates robust and simple.

### Step 1: Pull Latest Image
Download the newest version of N8N.
```bash
podman pull docker.io/n8nio/n8n
```

### Step 2: Restart Service
Restarting the systemd service triggers Podman to recreate the container with the new image.
```bash
sudo systemctl restart n8n.service
```

### Step 3: Verify Update
Check the status and logs to ensure successful startup.
```bash
sudo systemctl status n8n.service
sudo journalctl -u n8n.service -n 50
```

---

## 10.3 Cleanup & Optimization

### Prune Unused Resources
Over time, old images and stopped containers consume disk space.
```bash
# Remove unused images, containers, and networks
podman system prune -a
```
*Note: This will ask for confirmation. Press 'y' to proceed.*

### Check Disk Usage
Monitor your server's storage to prevent issues.
```bash
df -h
```
Ensure `/` (root) and `/home` have sufficient free space (aim for >20% free).

---

## 10.4 Troubleshooting Updates

**Service won't start after update:**
1. Check logs: `sudo journalctl -u n8n.service -n 100`
2. Verify permissions: `ls -la ~/.n8n-data`
3. Rollback:
   - Edit `/etc/containers/systemd/n8n.container`
   - Change `Image=docker.io/n8nio/n8n` to `Image=docker.io/n8nio/n8n:previous-version`
   - `sudo systemctl daemon-reload`
   - `sudo systemctl restart n8n.service`

---

## 🏁 Chapter Summary

You now have a maintenance routine!
- **Weekly:** Run `apt update && apt upgrade`
- **Monthly:** Check for N8N version updates
- **Quarterly:** Run `podman system prune` to reclaim space

**Next:** [Chapter 11: Advanced Configuration →](./../11-advanced/README.md)
