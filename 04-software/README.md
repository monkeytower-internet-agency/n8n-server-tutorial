# Chapter 4: Software Installation

**Install essential development tools and productivity software on your VPS. This chapter covers package management, development tools, and version control setup to create a powerful server environment.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have installed:
- Essential system utilities
- Development tools (editors, compilers)
- Version control systems
- Productivity enhancements (Nushell, Starship)
- Package management best practices

## 📋 Prerequisites

- Secure SSH access to your VPS
- Sudo privileges for software installation
- Internet connection for package downloads

## 4.1 System Update and Essentials

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

## 4.2 Development Tools

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

### Starship (Cross-Shell Prompt)

**Install Starship:**
```bash
curl -sS https://starship.rs/install.sh | sudo sh -s -- -y
```

**Configure Starship (Production Theme):**
Create `~/.config/starship.toml` with a red hostname to warn you are on production:

```toml
add_newline = false
format = """$hostname$directory$character"""

[hostname]
ssh_only = false
format = "[$hostname]($style) "
style = "bold red"
disabled = false

[directory]
style = "blue"

[character]
success_symbol = "[➜](bold green)"
error_symbol = "[➜](bold red)"
```

**Enable Starship in Nushell:**
Create or edit `~/.config/nushell/env.nu`:

```nushell
$env.STARSHIP_SHELL = "nu"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

$env.PROMPT_COMMAND = { || create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = { || "" }

$env.PATH = ($env.PATH | split row (char esep) | prepend '/usr/local/bin' | prepend '/home/ok/.cargo/bin' | uniq)
$env.EDITOR = "nvim"
```

**Set Nushell as default shell:**
```bash
# Add nushell to /etc/shells if missing
grep $(which nu) /etc/shells || echo "$HOME/.cargo/bin/nu" | sudo tee -a /etc/shells

# Change default shell
chsh -s $(which nu)
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

## 4.3 Git Configuration

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

## 4.4 Development Environment Setup

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

### Install Neovim

```bash
sudo apt install -y neovim
```

**Minimal Config (`~/.config/nvim/init.vim`):**
```vim
syntax on
set number
set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set smartindent
set ignorecase
set smartcase
set termguicolors
colorscheme default
```

## 4.5 Software Installation Checklist

### Core System Tools
- [ ] Essential utilities installed
- [ ] System updated
- [ ] Build tools available

### Shell Environment
- [ ] Nushell installed
- [ ] Starship installed and configured
- [ ] Default shell changed to Nushell
- [ ] Prompt shows red hostname (Production warning)

### Development Environment
- [ ] Neovim installed and configured
- [ ] GitHub CLI installed
- [ ] Git configured with user information
- [ ] Python/Node.js installed

## 🏁 Chapter Summary

Your server now has a complete development environment! You've installed:
- Essential system utilities and build tools
- Modern shell (Nushell) with custom prompt (Starship)
- Version control and GitHub integration
- Programming languages and package managers

**Test your setup:**
1.  Log out and log back in.
2.  Verify your prompt shows the red hostname.
3.  Try running `nu` commands like `ls | sort-by size`.

## 📚 Additional Resources

- [Nushell Book](https://www.nushell.sh/book/)
- [Starship Documentation](https://starship.rs/guide/)
- [GitHub CLI Manual](https://cli.github.com/manual/)

---

**Next:** [Chapter 5: N8N Deployment →](./../05-n8n-deployment/README.md)
