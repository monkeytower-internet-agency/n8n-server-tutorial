# Chapter 4: N8N Deployment

**Deploy N8N as a containerized application using Podman. This chapter covers container setup, persistent data configuration, and service management to ensure your automation workflows are reliable and scalable.**

## 🎯 What You'll Learn

By the end of this chapter, you'll understand:
- Containerization concepts and benefits
- Podman vs Docker comparison
- N8N deployment in containers
- Persistent data management
- Service monitoring and management

## 📋 Prerequisites

- VPS with internet access
- Sudo privileges for software installation
- Basic container knowledge (optional)

## 4.1 Containerization Overview

### Why Use Containers?

**Benefits for N8N:**
- **Isolation:** N8N runs separately from system
- **Consistency:** Same environment everywhere
- **Scalability:** Easy to update and backup
- **Security:** Limited system access
- **Portability:** Move between servers easily

### Podman vs Docker

**Why Podman for this tutorial:**

Many tutorials and guides use Docker for containerization, but this tutorial specifically uses **Podman** for several important reasons (detailed in the video link below). While you might be familiar with Docker from other projects, Podman offers significant advantages for server deployments:

- **Rootless by default:** Enhanced security without requiring root privileges
- **Daemonless architecture:** No background service that could be a security risk or point of failure
- **Docker compatibility:** Same commands and images work seamlessly
- **Better systemd integration:** More suitable for long-running server services

**Note:** If you're more comfortable with Docker, you can adapt these commands, but we recommend Podman for the security and stability benefits outlined in the comparison video.

## 4.2 Install Podman

### Add Podman Repository

```bash
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:projectatomic/ppa
sudo apt update
```

### Install Podman

```bash
sudo apt install -y podman
```

### Verify Installation

```bash
podman --version
podman info
```

## 4.3 N8N Container Setup

### Create Quadlet Service

**Modern Podman integration uses Quadlet files instead of manual systemd services.** Quadlet automatically generates proper systemd units with correct dependencies.

**Create Quadlet directory:**
```bash
sudo mkdir -p /etc/containers/systemd
```

**Create N8N Quadlet file:**
```bash
sudo nano /etc/containers/systemd/n8n.container
```

**Add this content:**
```ini
[Unit]
Description=N8N automation server

[Container]
Image=docker.io/n8nio/n8n
PublishPort=5678:5678
Volume=%h/.n8n-data:/home/node/.n8n
User=%U

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=default.target
```

**Save and exit** (Ctrl+X, Y, Enter)

### Enable and Start Service

**Reload systemd to recognize the new Quadlet:**
```bash
sudo systemctl daemon-reload
```

**Enable auto-start on boot and start immediately:**
```bash
sudo systemctl enable --now n8n.service
```

**Check service status:**
```bash
sudo systemctl status n8n.service
```

### Verify Deployment

**Check if Quadlet service is running:**
```bash
sudo systemctl status n8n.service
```

**View generated systemd logs:**
```bash
sudo journalctl -u n8n.service -f
```

**Check Podman container status:**
```bash
podman ps
```

## 4.4 Access N8N

### Web Interface

**Access your N8N instance:**
```
http://your-server-ip:5678
```

**Initial setup:**
1. Create admin account
2. Set up password
3. Configure basic settings

### Default Credentials

**First login:**
- **Username:** (create during setup)
- **Password:** (set during setup)
- **URL:** `http://your-server-ip:5678`

## 4.5 Service Management

### Systemd Commands

**Stop N8N service:**
```bash
sudo systemctl stop n8n.service
```

**Start N8N service:**
```bash
sudo systemctl start n8n.service
```

**Restart N8N service:**
```bash
sudo systemctl restart n8n.service
```

**Check service status:**
```bash
sudo systemctl status n8n.service
```

**View service logs:**
```bash
sudo journalctl -u n8n.service -f
```

### Update N8N

**Pull latest image:**
```bash
podman pull docker.io/n8nio/n8n
```

**Restart service (Quadlet handles container recreation):**
```bash
sudo systemctl restart n8n.service
```

**Verify update:**
```bash
sudo journalctl -u n8n.service -n 20
```

## 4.6 Persistent Data Management

### Data Location

**N8N stores data in:**
- `~/.n8n-data/database.sqlite` - Workflow database
- `~/.n8n-data/.n8n/config` - Configuration files
- `~/.n8n-data/.n8n/encryption.key` - Encryption keys

### Backup Strategy

**Manual backup:**
```bash
tar -czf n8n-backup-$(date +%Y%m%d).tar.gz ~/.n8n-data
```

**Automated backup covered in later chapters**

### Data Migration

**Move to new server:**
```bash
# On old server
tar -czf n8n-data.tar.gz ~/.n8n-data

# Transfer to new server
scp n8n-data.tar.gz new-server:~

# On new server
tar -xzf n8n-data.tar.gz
# Deploy N8N with existing data
```

## 4.7 Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using port 5678
sudo netstat -tulpn | grep 5678

# Change port in Quadlet file and restart
sudo nano /etc/containers/systemd/n8n.container
# Change PublishPort=5678:5678 to PublishPort=5679:5678
sudo systemctl daemon-reload
sudo systemctl restart n8n.service
```

**Permission errors:**
```bash
# Fix data directory permissions
chmod 755 ~/.n8n-data

# Check systemd service logs for permission issues
sudo journalctl -u n8n.service -n 50

# Restart service after fixing permissions
sudo systemctl restart n8n.service
```

**Service won't start:**
```bash
# Check systemd service logs for errors
sudo journalctl -u n8n.service -n 50

# Check Podman container status
podman ps -a

# Restart service
sudo systemctl restart n8n.service

# If issues persist, recreate Quadlet
sudo systemctl stop n8n.service
sudo systemctl disable n8n.service
sudo systemctl daemon-reload
sudo systemctl enable --now n8n.service
```

### Performance Monitoring

**Monitor service status:**
```bash
sudo systemctl status n8n.service
```

**Monitor container resource usage:**
```bash
podman stats
```

**View real-time logs:**
```bash
sudo journalctl -u n8n.service -f
```

**Check system resources:**
```bash
htop
df -h
free -h
```

## 4.8 N8N Configuration

### Environment Variables

**Customize N8N behavior:**
```bash
podman run -d \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n-data:/home/node/.n8n \
  -e N8N_BASIC_AUTH_ACTIVE=true \
  -e N8N_BASIC_AUTH_USER=admin \
  -e N8N_BASIC_AUTH_PASSWORD=your-secure-password \
  --user 1000:1000 \
  docker.io/n8nio/n8n
```

### Security Considerations

**For production:**
- Use environment variables for sensitive data
- Enable HTTPS (covered in next chapter)
- Configure proper user authentication
- Regular security updates

## 4.9 Deployment Checklist

### Quadlet Service Setup
- [ ] Podman installed and working
- [ ] Quadlet directory created (/etc/containers/systemd)
- [ ] N8N Quadlet file created (n8n.container)
- [ ] Systemd service enabled and running
- [ ] Port 5678 accessible
- [ ] Data persistence configured

### Access & Security
- [ ] Web interface accessible
- [ ] Admin account created
- [ ] Basic authentication configured
- [ ] Container running as non-root user (%U in Quadlet)

### Service Management
- [ ] Systemd start/stop/restart commands tested
- [ ] Service logs accessible (journalctl)
- [ ] Resource monitoring working
- [ ] Backup strategy planned

### Troubleshooting
- [ ] Common issues identified
- [ ] Recovery procedures documented
- [ ] Performance monitoring set up

## 🏁 Chapter Summary

Your N8N automation server is now running! You've successfully:
- Installed and configured Podman
- Deployed N8N in a container
- Set up persistent data storage
- Learned container management basics
- Configured basic security measures

**Test your N8N instance:**
1. Visit `http://your-server-ip:5678`
2. Create your first workflow
3. Test basic automation

**Next chapter covers domain setup and SSL certificates!**

## 📚 Additional Resources

- [Podman Getting Started](https://podman.io/get-started/)
- [Podman vs Docker: Why Choose Podman?](https://youtu.be/Z5uBcczJxUY?si=d9-fZvz7opnyRuYs) - Learn about Podman's advantages: daemonless architecture, rootless containers by default, enhanced security, and Docker compatibility
- [N8N Configuration](https://docs.n8n.io/hosting/configuration/)
- [Container Security Best Practices](https://snyk.io/learn/container-security/)

---

**Next:** [Chapter 6: Domain & HTTPS →](./../06-domain-https/README.md)
