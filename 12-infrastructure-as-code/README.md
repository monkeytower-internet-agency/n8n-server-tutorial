# Chapter 12: Infrastructure as Code (Ansible)

**Automate your server deployment using Ansible. This chapter transforms our manual setup into reproducible code.**

## 🎯 What You'll Learn

- **Ansible Basics:** Playbooks, Inventory, Roles.
- **Automated Deployment:** Recreating the server with one command.
- **Configuration Management:** Preventing configuration drift.

## 📋 Prerequisites

- Ansible installed on your local machine (`brew install ansible` or `pip install ansible`).
- SSH access to your server.

## 12.1 Project Structure

We have organized the configuration into **Roles**:

```
ansible/
├── inventory.ini        # Target server list
├── playbook.yml         # Master plan
└── roles/
    ├── common/          # Base packages, firewall, shell
    ├── podman/          # Container engine & user
    └── n8n/             # Quadlet service & data
```

## 12.2 Roles Explained

### 1. Common Role
- Updates system packages (`apt update`).
- Installs essential tools: `vim`, `git`, `nushell`, `starship`.
- Configures UFW firewall (SSH, HTTP/HTTPS).

### 2. Podman Role
- Installs `podman`.
- Creates the dedicated `containers` service user.
- Enables "linger" so services run at boot without login.

### 3. N8N Role
- Creates persistent data directories (`~/data/n8n`).
- Deploys the **Quadlet** file (`n8n.container`).
- Manages the systemd service.

## 12.3 Running the Playbook

**1. Update Inventory**
Edit `ansible/inventory.ini` with your server IP/Hostname:
```ini
[n8n_servers]
your.server.ip
```

**2. Run Playbook**
```bash
cd ansible
ansible-playbook playbook.yml
```

**What happens?**
Ansible connects via SSH, checks the state of every task, and only makes changes if necessary. It's **idempotent** - you can run it 10 times, and it will only apply changes once.

## 12.4 Scaling & Migration

To move to a new server (e.g., bigger VPS):
1.  Update `inventory.ini` with new IP.
2.  Run `ansible-playbook playbook.yml`.
3.  Copy your data: `scp -r old-server:/home/containers/data/n8n new-server:/home/containers/data/`.

**You're back online in minutes!**

---

## 🏁 Tutorial Complete

You have built a **Production-Grade, AI-Assisted, Automated N8N Server**.

- **Secure:** Rootless containers, dedicated users, firewall.
- **Reliable:** Automated backups, Quadlet auto-restart.
- **Smart:** AI agent for maintenance.
- **Automated:** Ansible for infrastructure management.

**Happy Automating!** 🚀
