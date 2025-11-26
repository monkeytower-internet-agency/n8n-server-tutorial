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

## 5.3 N8N Container Setup

### Service User Setup (Security Best Practice)

Instead of running containers as your admin user, we'll create a dedicated system user `containers`. This isolates the service and improves security.

**Create the user:**
```bash
sudo useradd -m -s /bin/bash containers
sudo loginctl enable-linger containers
```

**Create data directory:**
```bash
sudo mkdir -p /home/containers/data/n8n
sudo chown -R containers:containers /home/containers/data
```

### Create Quadlet Service

**Create User Quadlet directory:**
```bash
sudo -u containers mkdir -p /home/containers/.config/containers/systemd
```

**Create N8N Quadlet file:**
```bash
sudo -u containers nano /home/containers/.config/containers/systemd/n8n.container
```

**Add this content:**
```ini
[Unit]
Description=N8N automation server

[Container]
Image=docker.io/n8nio/n8n
PublishPort=5678:5678
Volume=%h/data/n8n:/home/node/.n8n:Z

[Service]
Restart=always
TimeoutStartSec=900

[Install]
WantedBy=default.target
```

**Save and exit** (Ctrl+X, Y, Enter)

### Enable and Start Service

**Fix Permissions:**
To ensure the container (UID 1000) can write to the volume, we fix ownership from the container's perspective:
```bash
sudo -u containers bash -c "cd ~ && podman unshare chown -R 1000:1000 /home/containers/data/n8n"
```

**Start the Service:**
```bash
sudo -u containers bash -c 'export XDG_RUNTIME_DIR=/run/user/$(id -u containers) && systemctl --user daemon-reload && systemctl --user enable --now n8n.service'
```

**Check Status:**
```bash
sudo -u containers bash -c 'export XDG_RUNTIME_DIR=/run/user/$(id -u containers) && systemctl --user status n8n.service'
```

### Verify Deployment

**Check Podman container status:**
```bash
sudo -u containers bash -c 'export XDG_RUNTIME_DIR=/run/user/$(id -u containers) && podman ps'
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

## 5.5 Service Management

Since we're running as a user service, all commands must be run as the `containers` user.

**Helper Function:**
Add this alias to your `~/.bashrc` to make management easier:
```bash
alias n8nctl="sudo -u containers bash -c 'export XDG_RUNTIME_DIR=/run/user/\$(id -u containers) && systemctl --user'"
```
Reload bash: `source ~/.bashrc`

### Management Commands

**Stop N8N:**
```bash
n8nctl stop n8n.service
```

**Start N8N:**
```bash
n8nctl start n8n.service
```

**Restart N8N:**
```bash
n8nctl restart n8n.service
```

**Check Status:**
```bash
n8nctl status n8n.service
```

**View Logs:**
```bash
sudo journalctl --user-unit n8n.service -u containers -f
```

**Did I lose my data?**
Because we map a **persistent volume** (`/home/containers/data/n8n`), your data is safe even when the container is recreated or updated.

### Update N8N

**Pull latest image:**
```bash
sudo -u containers bash -c 'podman pull docker.io/n8nio/n8n'
```

**Restart service:**
```bash
n8nctl restart n8n.service
```

## 5.6 Persistent Data Management

### Data Location

**All N8N data is stored centrally:**
- **Path:** `/home/containers/data/n8n`
- **Database:** `database.sqlite`
- **Config:** `.n8n/config`
- **Encryption Key:** `.n8n/encryption.key`

### Backup Strategy

**Manual backup:**
```bash
sudo tar -czf n8n-backup-$(date +%Y%m%d).tar.gz /home/containers/data/n8n
```

**Automated backup covered in later chapters**

### Data Migration

**Move to new server:**
```bash
# On old server
sudo tar -czf n8n-data.tar.gz /home/containers/data/n8n

# Transfer to new server
scp n8n-data.tar.gz new-server:~

# On new server (after creating containers user)
sudo mkdir -p /home/containers/data
sudo tar -xzf n8n-data.tar.gz -C /home/containers/data
sudo chown -R containers:containers /home/containers/data
```

## 5.7 Troubleshooting

### Common Issues

**Port already in use:**
```bash
# Check what's using port 5678
sudo netstat -tulpn | grep 5678

# Change port in Quadlet file and restart
sudo -u containers nano /home/containers/.config/containers/systemd/n8n.container
# Change PublishPort=5678:5678 to PublishPort=5679:5678
n8nctl restart n8n.service
```

**Permission errors:**
```bash
# Fix data directory permissions
sudo chown -R containers:containers /home/containers/data

# Fix volume permissions (container perspective)
sudo -u containers bash -c "cd ~ && podman unshare chown -R 1000:1000 /home/containers/data/n8n"

# Restart service
n8nctl restart n8n.service
```

**Service won't start:**
```bash
# Check systemd service logs for errors
sudo journalctl --user-unit n8n.service -u containers -n 50

# Check for crash loops due to permissions
# Error: SQLITE_READONLY
# Fix: Run the permission fixes above

# Check Podman container status
sudo -u containers bash -c 'export XDG_RUNTIME_DIR=/run/user/$(id -u containers) && podman ps -a'

# Restart service
n8nctl restart n8n.service

# If issues persist, recreate Quadlet
n8nctl stop n8n.service
sudo -u containers systemctl --user disable n8n.service
n8nctl daemon-reload
n8nctl enable --now n8n.service
```

### Performance Monitoring

**Monitor service status:**
```bash
n8nctl status n8n.service
```

**Monitor container resource usage:**
```bash
sudo -u containers bash -c 'podman stats'
```

**View real-time logs:**
```bash
sudo journalctl --user-unit n8n.service -u containers -f
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

## 5.9 Deployment Checklist

### Service User Setup
- [ ] Dedicated `containers` user created
- [ ] Linger enabled for user
- [ ] Data directory created and owned by user
- [ ] Rootless volume permissions fixed (podman unshare)

### Quadlet Service Setup
- [ ] User Quadlet directory created
- [ ] N8N Quadlet file created (n8n.container)
- [ ] User systemd service enabled and running
- [ ] Port 5678 accessible

### Access & Security
- [ ] Web interface accessible
- [ ] Admin account created
- [ ] Basic authentication configured
- [ ] Container running as non-root user (rootless)

### Service Management
- [ ] `n8nctl` alias configured
- [ ] Start/stop/restart commands tested
- [ ] Service logs accessible
- [ ] Backup strategy updated for new path

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
