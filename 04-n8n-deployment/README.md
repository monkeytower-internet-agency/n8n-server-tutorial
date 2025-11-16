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
- **Rootless by default:** Better security
- **Daemonless:** No background service required
- **Docker compatibility:** Same commands and images
- **Systemd integration:** Better for servers

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

### Create Data Directory

**Create persistent storage:**
```bash
mkdir -p ~/.n8n-data
```

**Set proper permissions:**
```bash
chmod 755 ~/.n8n-data
```

### Run N8N Container

**Basic N8N deployment:**
```bash
podman run -d \
  --name n8n \
  -p 5678:5678 \
  -v ~/.n8n-data:/home/node/.n8n \
  --user 1000:1000 \
  docker.io/n8nio/n8n
```

**Command explanation:**
- `-d` - Run in background (detached)
- `--name n8n` - Container name for management
- `-p 5678:5678` - Map port 5678 on host to container
- `-v ~/.n8n-data:/home/node/.n8n` - Mount persistent data
- `--user 1000:1000` - Run as regular user for security
- `docker.io/n8nio/n8n` - Official N8N image

### Verify Deployment

**Check if container is running:**
```bash
podman ps
```

**View container logs:**
```bash
podman logs n8n
```

**Check container resource usage:**
```bash
podman stats n8n
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

## 4.5 Container Management

### Basic Commands

**Stop N8N:**
```bash
podman stop n8n
```

**Start N8N:**
```bash
podman start n8n
```

**Restart N8N:**
```bash
podman restart n8n
```

**Remove container:**
```bash
podman rm n8n
```

### Update N8N

**Pull latest image:**
```bash
podman pull docker.io/n8nio/n8n
```

**Update running container:**
```bash
podman stop n8n
podman rm n8n
# Re-run the deployment command above
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

# Kill process or change port
podman run -d --name n8n -p 5679:5678 docker.io/n8nio/n8n
```

**Permission errors:**
```bash
# Fix data directory permissions
chmod 755 ~/.n8n-data
podman run -d --name n8n -p 5678:5678 -v ~/.n8n-data:/home/node/.n8n --user $(id -u):$(id -g) docker.io/n8nio/n8n
```

**Container won't start:**
```bash
# Check logs for errors
podman logs n8n

# Remove and redeploy
podman rm n8n
# Re-run deployment command
```

### Performance Monitoring

**Monitor resource usage:**
```bash
podman stats n8n
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

### Container Setup
- [ ] Podman installed and working
- [ ] N8N container running
- [ ] Port 5678 accessible
- [ ] Data persistence configured

### Access & Security
- [ ] Web interface accessible
- [ ] Admin account created
- [ ] Basic authentication configured
- [ ] Container running as non-root user

### Management
- [ ] Container start/stop commands tested
- [ ] Logs accessible
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

- [N8N Docker Installation](https://docs.n8n.io/hosting/installation/docker/)
- [Podman Getting Started](https://podman.io/getting-started/)
- [N8N Configuration](https://docs.n8n.io/hosting/configuration/)
- [Container Security Best Practices](https://snyk.io/learn/container-security/)

---

**Next:** [Chapter 5: Domain & HTTPS →](./../05-domain-https/README.md)
