# Chapter 11: AI-Assisted Maintenance

**Transform your server into an intelligent, self-managing system. This chapter covers installing Opencode, configuring Gemini AI, and setting up automated slash commands for complex maintenance tasks.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have:
- Installed the Opencode CLI agent on your server
- Configured Google Gemini 2.5 Pro (Free Tier)
- Set up custom "SysAdmin" agents
- Automated complex tasks with slash commands

## 📋 Prerequisites

- Node.js installed on server (Chapter 4)
- Google Account (for API key)
- Basic familiarity with AI prompts

---

## 11.1 Get Your Gemini API Key

We use **Google Gemini** because it offers a generous free tier suitable for server maintenance tasks.

1.  **Visit Google AI Studio:** [aistudio.google.com](https://aistudio.google.com/)
2.  **Sign in** with your Google account.
3.  **Create API Key:** Click "Get API key" -> "Create API key in new project".
4.  **Copy the key:** It starts with `AIza...`.

**Security Note:** Treat this key like a password. Never commit it to Git!

---

## 11.2 Install Opencode Agent

We use `opencode-ai`, a powerful CLI agent that can execute system commands safely.

### Install via NPM
```bash
sudo npm install -g opencode-ai
```

### Verify Installation
```bash
opencode --version
```

---

## 11.3 Configure the Agent

We need to define the "persona" for our server agent so it knows how to handle system tasks safely.

### Create Agent Configuration
Create a file named `~/AGENTS.md`:

```bash
nano ~/AGENTS.md
```

**Paste this configuration:**

```markdown
# Opencode Agents: System Administration Guidelines

## 🎭 Primary Agent: SysAdmin

**Role:** Expert Linux System Administrator & DevOps Engineer
**Context:** Production Ubuntu 24.04 Server running N8N (Quadlet/Podman)
**Model:** google/gemini-2.5-pro

## 🛡️ Core Mandates

1.  **Safety First:** Always backup configuration/data before modification.
2.  **Verification:** Never assume a command worked. Verify with `systemctl status`, `curl`, or logs.
3.  **Persistence:** Use absolute paths (e.g., `/home/ok/.n8n-data`) not relatives.
4.  **Security:** Respect file permissions. Use `sudo` responsibly.

## 🤖 Slash Commands

- **/update-n8n:** Trigger the safe update workflow (Backup -> Pull -> Restart -> Verify).
- **/health:** Perform a full system health check.
- **/logs:** Fetch recent logs for N8N and Caddy.
- **/backup:** Trigger an immediate manual backup.
```

---

## 11.4 Setup API Key

For security, we store the API key in an environment variable or configuration file.

**Option A: Interactive Auth (Recommended)**
Run `opencode auth` and follow the prompts to paste your key.

**Option B: Environment Variable**
Add this to your `~/.bashrc`:
```bash
export GEMINI_API_KEY="your-key-starting-with-AIza"
```
Then reload: `source ~/.bashrc`

---

## 11.5 Using Your AI SysAdmin

Now you can perform complex tasks with natural language!

**Example 1: Interactive Update**
```bash
opencode run "Please update N8N safely using the defined workflow."
```

**Example 2: Troubleshooting**
```bash
opencode run "N8N isn't starting. Check the logs and suggest a fix."
```

**The AI will:**
1.  Read your `AGENTS.md` to understand the rules.
2.  Execute commands (checking logs, checking status).
3.  Analyze the output.
4.  Propose fixes or run them if authorized.

---

## 🏁 Chapter Summary

You now have an AI partner on your server!
- **Engine:** Google Gemini 2.5 Pro
- **Interface:** Opencode CLI
- **Role:** 24/7 System Administrator

**Next:** [Chapter 12: Infrastructure as Code (Ansible) →](./../12-infrastructure-as-code/README.md)
