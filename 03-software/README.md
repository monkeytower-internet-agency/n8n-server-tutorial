# Chapter 3: Software Installation

**Install essential development tools and productivity software on your VPS. This chapter covers package management, development tools, and version control setup to create a powerful server environment.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have installed:
- Essential system utilities
- Development tools (editors, compilers)
- Version control systems
- Productivity enhancements
- Package management best practices

## 📋 Prerequisites

- Secure SSH access to your VPS
- Sudo privileges for software installation
- Internet connection for package downloads

## 3.1 System Update and Essentials

### Update Package Lists

```bash
sudo apt update
```

### Install Essential Tools

```bash
sudo apt install -y \
  curl \
  wget \
  htop \
  tree \
  git \
  build-essential \
  software-properties-common \
  nano \
  vim
```

**What each tool does:**
- `curl` - Transfer data from servers
- `wget` - Download files from the web
- `htop` - Interactive process viewer
- `tree` - Display directory tree structure
- `git` - Version control system
- `build-essential` - Compilation tools for software
- `software-properties-common` - Manage software repositories
- `nano` - Simple, user-friendly text editor
- `vim` - Powerful text editor with advanced features

## 3.2 Development Tools

### Nushell (Modern Shell)

**Install Rust (required for Nushell):**
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source "$HOME/.cargo/env"
```

**Install Nushell:**
```bash
cargo install nu
```

**Set Nushell as default shell:**
```bash
echo "$HOME/.cargo/bin/nu" >> ~/.bashrc
```

### GitHub CLI (gh)

**Add GitHub CLI repository:**
```bash
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
```

**Install GitHub CLI:**
```bash
sudo apt update
sudo apt install -y gh
```

## 3.3 Git Configuration

### Configure Git User Information

```bash
git config --global user.name "Your Name"
git config --global user.email "your-email@example.com"
git config --global init.defaultBranch main
```

### Generate SSH Key for GitHub (Optional)

If you want to connect to GitHub repositories:

```bash
ssh-keygen -t ed25519 -C "your-email@example.com" -f ~/.ssh/github_key
```

**Add to SSH config:**
```bash
cat >> ~/.ssh/config << 'EOF'
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/github_key
EOF
```

**Display public key for GitHub:**
```bash
cat ~/.ssh/github_key.pub
```

Add this key to your GitHub account under Settings → SSH and GPG keys.

## 3.4 Development Environment Setup

### Install Additional Development Tools

```bash
sudo apt install -y \
  python3 \
  python3-pip \
  nodejs \
  npm \
  jq \
  unzip \
  zip
```

### Configure Python

```bash
python3 --version
pip3 --version
```

### Configure Node.js

```bash
node --version
npm --version
```

## 3.5 Productivity Enhancements

### Install Useful Utilities

```bash
sudo apt install -y \
  tmux \
  screen \
  ncdu \
  duf \
  bat \
  exa
```

**Tool descriptions:**
- `tmux` - Terminal multiplexer for session management
- `screen` - Alternative terminal multiplexer
- `ncdu` - Disk usage analyzer
- `duf` - Modern disk usage utility
- `bat` - Enhanced cat command with syntax highlighting
- `exa` - Modern ls replacement

### Configure Aliases

```bash
cat >> ~/.bashrc << 'EOF'
# Useful aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Enhanced commands
if command -v bat &> /dev/null; then
    alias cat='bat'
fi

if command -v exa &> /dev/null; then
    alias ls='exa'
    alias ll='exa -al'
    alias la='exa -a'
    alias tree='exa --tree'
fi
EOF
```

## 3.6 Software Installation Checklist

### Core System Tools
- [ ] Essential utilities installed
- [ ] System updated
- [ ] Build tools available

### Development Environment
- [ ] Neovim installed and configured
- [ ] Nushell installed and configured
- [ ] GitHub CLI installed
- [ ] Git configured with user information

### Programming Languages
- [ ] Python 3 installed
- [ ] Node.js installed
- [ ] Package managers working

### Productivity Tools
- [ ] Terminal multiplexers installed
- [ ] Enhanced file utilities installed
- [ ] Useful aliases configured

### Version Control
- [ ] Git user configured
- [ ] SSH keys generated (optional)
- [ ] GitHub CLI authenticated (optional)

## 🏁 Chapter Summary

Your server now has a complete development environment! You've installed:
- Essential system utilities and build tools
- Modern development editors and shells
- Version control and GitHub integration
- Programming languages and package managers
- Productivity enhancements and aliases

**Test your setup:**
```bash
# Test Nushell
nu --version

# Test GitHub CLI
gh --version

# Test enhanced commands
ll
bat --version
```

## 📚 Additional Resources

- [Nushell Book](https://www.nushell.sh/book/)
- [GitHub CLI Manual](https://cli.github.com/manual/)
- [Tmux Cheat Sheet](https://tmuxcheatsheet.com/)

---

**Next:** [Chapter 4: N8N Deployment →](./../04-n8n-deployment/README.md)
