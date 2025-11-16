# Chapter 1: Ubuntu Server Installation

**Set up a clean Ubuntu Server LTS installation from scratch. This chapter covers the complete server setup process, from ISO download to basic network configuration, ensuring you have a solid foundation for your N8N automation server.**

## 🎯 What You'll Learn

By the end of this chapter, you'll understand:
- Ubuntu Server LTS selection and download
- Basic installation process and key decisions
- Drive partitioning strategies for servers
- Network configuration and remote access setup
- Post-installation system updates and preparation

## 📋 Prerequisites

- VPS or dedicated server with at least 2GB RAM, 20GB storage
- Access to server console (direct or via provider interface)
- Basic understanding of Linux concepts

## ⚠️ Important Notes

**This guide covers a clean Ubuntu Server installation, not pre-configured instances.** Many providers offer "one-click" Ubuntu installs, but this tutorial assumes you're starting from a bare server to ensure complete control over your setup.

**Provider-specific steps** (like virtual DVD mounting) are not covered here - consult your provider's documentation for those details.

---

## 1.1 Download Ubuntu Server LTS

### Why Ubuntu Server LTS?

- **Long Term Support:** 5 years of security updates and patches
- **Stability:** Proven reliability for server environments
- **Community:** Largest Linux community and documentation
- **Package ecosystem:** Extensive software repositories

### Download Options

Visit [ubuntu.com/download/server](https://ubuntu.com/download/server) and download:
- **Ubuntu Server 24.04 LTS** (latest LTS at time of writing)
- **64-bit architecture** (AMD64)
- **ISO image** for installation

**File:** `ubuntu-24.04-live-server-amd64.iso`

---

## 1.2 Installation Preparation

### Server Requirements

**Minimum for N8N:**
- **RAM:** 2GB (4GB recommended)
- **Storage:** 20GB (50GB+ recommended for data)
- **CPU:** 1 vCPU (2+ recommended)
- **Network:** Public IP address

### Boot from Installation Media

1. **Access your server console** through your provider's interface
2. **Mount the Ubuntu ISO** (follow provider-specific instructions)
3. **Reboot the server** to boot from the installation media
4. **Select "Install Ubuntu Server"** from the boot menu

---

## 1.3 Language and Keyboard Setup

### Installation Steps

1. **Language Selection:**
   - Choose your preferred language
   - This affects system language and keyboard layout

2. **Keyboard Configuration:**
   - Select your keyboard layout
   - Test special characters if needed

3. **Network Connections:**
   - The installer will attempt DHCP configuration
   - Note your IP address for later reference

---

## 1.4 Storage Configuration

### Understanding Partitioning

**Key Questions During Installation:**

- **How much space do you need?** Consider current needs + future growth
- **Separate system from data?** Recommended for easier backups
- **Swap space requirements?** General rule: equal to RAM or 2GB minimum

### Recommended Partition Scheme

```
/boot (EFI) - 512MB
/ (root)     - 15-20GB (system files)
/home        - Remaining space (user data, N8N files)
swap         - 2-4GB (or equal to RAM)
```

### Installation Options

**Choose "Custom storage layout" and configure:**

1. **Boot partition:** 512MB, FAT32 (EFI)
2. **Root partition:** 15-20GB, ext4, mount point `/`
3. **Home partition:** Remaining space, ext4, mount point `/home`
4. **Swap:** 2GB minimum, swap

**Pro tip:** Leave space unallocated for future expansion or additional partitions.

---

## 1.5 System Setup

### Profile Setup

1. **Your name:** Your full name
2. **Server name:** Choose a descriptive hostname (e.g., `n8n-server-01`)
3. **Username:** Create a non-root user account
4. **Password:** Strong password for the user account

### SSH Setup

**Important:** Enable OpenSSH server during installation for remote access.

- ✅ **Install OpenSSH server** (check this option)
- This allows secure remote management via SSH

### Featured Server Snaps

**Optional:** You can skip these during installation:
- Uncheck all featured snaps
- We'll install what we need manually for better control

---

## 1.6 Network Configuration

### DHCP vs Static IP

**During installation:**
- **DHCP** is usually fine for initial setup
- Note the assigned IP address
- You can configure static IP later if needed

### Remote Access Setup

**For headless servers, you'll need remote access. Here are your options:**

#### Option 1: SSH (Recommended)

Already enabled during installation. After reboot:
```bash
ssh your-username@server-ip
```

#### Option 2: VNC Server (Alternative)

If you need graphical access during setup:

**Install VNC server:**
```bash
sudo apt update
sudo apt install -y tightvncserver
```

**Configure VNC:**
```bash
vncserver
# Follow prompts to set password
```

**Access via VNC client:**
- Use server IP + display number (e.g., `192.168.1.100:1`)
- Connect with any VNC client (Remmina, RealVNC, etc.)

---

## 1.7 Post-Installation Setup

### First Boot

1. **Login** with your created username and password
2. **Update the system:**
   ```bash
   sudo apt update
   sudo apt upgrade -y
   ```

3. **Install essential tools:**
   ```bash
   sudo apt install -y curl wget htop
   ```

### Network Verification

**Check your network configuration:**
```bash
ip addr show
# or
hostname -I
```

**Test internet connectivity:**
```bash
ping -c 4 8.8.8.8
ping -c 4 google.com
```

### Security Basics

**Set up basic firewall:**
```bash
sudo apt install -y ufw
sudo ufw allow ssh
sudo ufw --force enable
```

---

## 1.8 Troubleshooting Common Issues

### Network Problems
- **No IP address:** Check DHCP settings with your provider
- **Can't reach server:** Verify firewall settings and port forwarding

### Installation Hangs
- **Slow download:** Check internet connection speed
- **Package errors:** Try different Ubuntu mirrors

### Boot Issues
- **No boot device:** Verify ISO is properly mounted
- **EFI errors:** Ensure server supports UEFI boot

---

## 📚 Additional Resources

- [Ubuntu Server Documentation](https://ubuntu.com/server/docs)
- [Ubuntu Installation Guide](https://ubuntu.com/server/docs/installation)
- [Network Configuration Guide](https://ubuntu.com/server/docs/networking)
- [SSH Setup Guide](https://ubuntu.com/server/docs/service-openssh)

---

**Next:** [Chapter 2: Planning Your N8N Server →](./../02-planning/README.md)