# Chapter 2: Security Setup

**Master the fundamentals of server security by configuring SSH key authentication, creating secure user accounts, and implementing basic security hardening. This chapter ensures your N8N server is protected against unauthorized access.**

## 🎯 What You'll Learn

By the end of this chapter, you'll be able to:
- Generate and manage SSH keys for secure access
- Create non-root user accounts with proper permissions
- Configure SSH daemon for enhanced security
- Understand basic server hardening principles

## 📋 Prerequisites

- A VPS server with root access
- Basic command line knowledge
- SSH client on your local computer

## 2.1 Initial Server Access

### Connecting as Root

After your VPS provider creates your server, you'll receive:
- Server IP address (e.g., `192.168.1.100`)
- Root password (temporary)

**Connect to your server:**
```bash
ssh root@your-server-ip
```

**Change the root password immediately:**
```bash
passwd
```

### Update System Packages

```bash
apt update && apt upgrade -y
```

## 2.2 SSH Key Authentication

### Why SSH Keys?

**Benefits over passwords:**
- Much more secure than passwords
- No brute-force attacks possible
- Convenient passwordless login
- Can be easily revoked if compromised

### Generate SSH Keys on Your Local Computer

**Check for existing keys:**
```bash
ls -la ~/.ssh/
```

**Generate new Ed25519 keys (recommended):**
```bash
ssh-keygen -t ed25519 -C "your-email@example.com"
```

**Press Enter** for all prompts to use default settings.

### Copy Public Key to Server

**Display your public key:**
```bash
cat ~/.ssh/id_ed25519.pub
```

**Copy the entire output** (starts with `ssh-ed25519`).

**On your server, create the SSH directory:**
```bash
mkdir -p ~/.ssh
chmod 700 ~/.ssh
```

**Create authorized_keys file:**
```bash
nano ~/.ssh/authorized_keys
```

**Paste your public key** and save (Ctrl+X, Y, Enter).

**Set proper permissions:**
```bash
chmod 600 ~/.ssh/authorized_keys
```

### Test Key-Based Login

**From a new terminal on your local computer:**
```bash
ssh root@your-server-ip
```

You should connect without entering a password!

## 2.3 User Account Management

### Why Not Use Root?

**Security risks of root access:**
- Unlimited system access
- Accidental system damage
- Audit trail issues
- Compliance requirements

### Create a Regular User Account

```bash
adduser your-username
```

**Follow the prompts:**
- Enter a strong password
- Fill in user information (or press Enter to skip)
- Confirm the information is correct

### Grant Sudo Privileges

```bash
usermod -aG sudo your-username
```

**Test sudo access:**
```bash
su - your-username
sudo whoami
```

You should see "root" as output.

## 2.4 SSH Security Hardening

### Configure SSH Daemon

**Edit SSH configuration:**
```bash
sudo nano /etc/ssh/sshd_config
```

**Make these security changes:**

```bash
# Disable root login
PermitRootLogin no

# Disable password authentication
PasswordAuthentication no

# Optional: Change default SSH port (choose a number between 1024-65535)
# Port 2222
```

**Save and exit** (Ctrl+X, Y, Enter).

### Restart SSH Service

```bash
sudo systemctl restart ssh
```

### Test New Configuration

**Keep your current SSH session open!**

**Open a new terminal and test:**
```bash
ssh your-username@your-server-ip
```

**Verify root login is blocked:**
```bash
ssh root@your-server-ip
```
Should show "Permission denied (publickey)"

## 2.5 Additional Security Measures

### Configure Firewall (UFW)

**Install and enable UFW:**
```bash
sudo apt install ufw -y
sudo ufw allow ssh
sudo ufw --force enable
```

**Allow N8N port (we'll configure this later):**
```bash
sudo ufw allow 5678
sudo ufw reload
```

### Automatic Security Updates

**Install unattended-upgrades:**
```bash
sudo apt install unattended-upgrades -y
sudo dpkg-reconfigure unattended-upgrades
```

**Follow the prompts** to enable automatic security updates.

## 2.6 Security Checklist

### SSH Configuration
- [ ] SSH keys generated and configured
- [ ] Root login disabled
- [ ] Password authentication disabled
- [ ] SSH service restarted successfully

### User Management
- [ ] Regular user account created
- [ ] Sudo privileges granted
- [ ] Root password changed
- [ ] User account tested

### System Security
- [ ] Firewall configured and enabled
- [ ] Automatic updates enabled
- [ ] System packages updated

### Access Verification
- [ ] SSH key login works
- [ ] Root login blocked
- [ ] Password login blocked
- [ ] Sudo commands work

## 🏁 Chapter Summary

Your server now has enterprise-grade security! You've implemented:
- SSH key authentication for secure access
- Non-root user accounts with proper permissions
- SSH daemon hardening
- Basic firewall protection
- Automatic security updates

**Never share your private SSH keys or root passwords!**

## 📚 Additional Resources

- [SSH Key Generation Guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- [Ubuntu Server Security](https://ubuntu.com/server/docs/security)
- [OpenSSH Server Configuration](https://man.openbsd.org/sshd_config)
- [UFW Firewall Guide](https://ubuntu.com/server/docs/security-firewall)

---

**Next:** [Chapter 4: Software Installation →](./../04-software/README.md)
