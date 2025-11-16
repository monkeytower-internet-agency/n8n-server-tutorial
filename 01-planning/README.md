# Chapter 1: Planning Your N8N Server

**Learn how to choose the right VPS provider and plan your N8N automation server setup. This chapter helps you make informed decisions about hosting costs, server specifications, and operating system selection.**

## 🎯 What You'll Learn

By the end of this chapter, you'll understand:
- How to evaluate VPS providers
- What server specifications you need for N8N
- Operating system choices and their implications
- Cost considerations and budget planning

## 📋 Prerequisites

- Basic understanding of web hosting concepts
- A credit card for VPS signup
- Knowledge of your automation needs

## 1.1 Choosing a VPS Provider

### Finding a VPS Provider

Research VPS providers that offer:
- Ubuntu 24.04 LTS support
- Good performance for your budget
- Reliable uptime and support
- Easy-to-use control panel

**Need help choosing a provider?** Olaf Klein from MonkeyTower Internet Agency can provide personalized recommendations based on your specific needs. Visit [monkeytower.net](https://monkeytower.net) for VPS setup assistance.

### Key Factors to Consider

**Performance:**
- At least 1GB RAM for basic N8N workflows
- 2GB+ RAM recommended for complex automations
- 1-2 vCPUs sufficient for most use cases
- SSD storage for better performance

**Location:**
- Choose a data center close to your users
- Consider GDPR compliance for European users
- Check network latency to your location

**Support & Documentation:**
- 24/7 customer support availability
- Comprehensive knowledge base
- Active community forums
- Easy-to-follow tutorials

## 1.2 Server Specifications

### Minimum Requirements

**For Basic N8N Usage:**
- **RAM:** 1GB
- **CPU:** 1 vCPU
- **Storage:** 20GB SSD
- **Bandwidth:** 1TB/month
- **Cost:** $5-10/month

**For Production Use:**
- **RAM:** 2-4GB
- **CPU:** 2 vCPUs
- **Storage:** 40-80GB SSD
- **Bandwidth:** 2-5TB/month
- **Cost:** $10-25/month

### Storage Planning

**System Requirements:**
- Ubuntu Server: ~5GB
- N8N and dependencies: ~2GB
- Docker/Podman images: ~5GB
- Log files and temporary data: ~2GB

**Workflow Data:**
- Plan for your automation storage needs
- Database files, uploaded content, cache
- Backup storage (3x your data size recommended)

## 1.3 Operating System Selection

### Recommended: Ubuntu Server 24.04 LTS

**Why Ubuntu?**
- Most popular VPS operating system
- Excellent community support
- Regular security updates
- Vast software repository
- Long-term support (LTS) versions

**Installation Options:**
- **Ubuntu Server Minimal** - Recommended for automation servers
- **Ubuntu Server Standard** - Includes more default packages
- **Ubuntu Desktop** - Not recommended for servers

### Alternative Options

**If you prefer other distributions:**
- **Debian** - Stable and similar to Ubuntu
- **CentOS/RHEL** - Enterprise-focused
- **Fedora** - Cutting-edge packages

**Avoid:**
- Desktop versions of any OS
- Unmaintained distributions
- Beta or development releases

## 1.4 Cost Planning

### Monthly Costs Breakdown

**VPS Server:** $5-25/month
**Domain Name:** $10-20/year (optional)
**SSL Certificate:** Free (Let's Encrypt)
**Backup Storage:** $0-10/month (depending on needs)

**Total Estimated Cost:** $15-35/month for a production setup

### Free Tier Options

**For Testing:**
- Many providers offer free credits
- AWS Lightsail free tier
- Google Cloud free tier
- Oracle Cloud free tier

**Limitations:**
- Time-limited trials
- Resource restrictions
- May not be suitable for production

## 1.5 Domain Name Considerations

### Do You Need a Domain?

**Benefits of Custom Domain:**
- Professional appearance (`n8n.yourdomain.com`)
- SSL certificate included
- Better for sharing with team/clients
- Easier to remember than IP addresses

**Using IP Address:**
- Perfectly functional for personal use
- No additional cost
- Access via `http://your-server-ip:5678`

### Domain Registration

**Recommended Registrars:**
- **Namecheap** - Affordable with good support
- **Cloudflare** - Includes DNS and security features
- **Porkbun** - Privacy-focused
- **Google Domains** - Simple interface

**Cost:** $10-20/year for .com domains

## 1.6 Planning Checklist

### Before You Start

- [ ] Research and choose VPS provider
- [ ] Calculate required server specifications
- [ ] Register domain name (optional)
- [ ] Set up billing/payment method
- [ ] Review provider's terms of service
- [ ] Check data center locations

### Account Setup

- [ ] Create VPS provider account
- [ ] Configure billing and payment
- [ ] Set up account security (2FA recommended)
- [ ] Review available server locations

### Pre-Installation Planning

- [ ] Choose operating system (Ubuntu 24.04 LTS)
- [ ] Plan server hostname and domain
- [ ] Prepare SSH keys for secure access
- [ ] Plan backup and monitoring strategy

## 🏁 Chapter Summary

You've now planned your N8N server setup! You should have:
- Selected a VPS provider and server specifications
- Understood operating system requirements
- Planned your budget and domain needs
- Completed the pre-installation checklist

**Ready for the next chapter?** In [Chapter 2](./../02-security/README.md), we'll set up secure access to your server using SSH keys and proper user management.

## 📚 Additional Resources

- [DigitalOcean VPS Documentation](https://docs.digitalocean.com/products/droplets/)
- [Linode Getting Started Guide](https://www.linode.com/docs/guides/getting-started/)
- [Ubuntu Server Installation Guide](https://ubuntu.com/server/docs/installation)
- [N8N System Requirements](https://docs.n8n.io/hosting/installation/server-requirements/)

---

**Next:** [Chapter 2: Security Setup →](./../02-security/README.md)
