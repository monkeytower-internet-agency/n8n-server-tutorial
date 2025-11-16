# Chapter 5: Domain & HTTPS

**Configure a custom domain name and secure SSL certificate for your N8N server. This chapter transforms your IP-based access into a professional domain with automatic HTTPS encryption.**

## 🎯 What You'll Learn

By the end of this chapter, you'll have:
- A custom domain pointing to your server
- Automatic SSL certificate from Let's Encrypt
- HTTPS encryption for secure access
- Professional URL structure

## 📋 Prerequisites

- Registered domain name
- DNS control (access to domain settings)
- N8N running on port 5678
- Basic DNS knowledge

## 5.1 Domain Name Registration

### Getting a Domain Name

If you don't have a domain yet, you'll need to register one. Popular registrars include:
- Namecheap
- Cloudflare
- Porkbun
- Google Domains

**Need help with domain registration?** Olaf Klein from monkeytower internet agency can assist with domain setup and DNS configuration. Visit [www.monkeytower.net](https://www.monkeytower.net) for professional domain services.

## 5.2 Domain Name Setup

### DNS Configuration

**Access your domain registrar's DNS settings:**
1. Log into your domain provider
2. Find DNS management section
3. Add an A record

**DNS Record Configuration:**
```
Type: A
Name/Host: n8n (or your preferred subdomain)
Value/Target: your-server-ip
TTL: 3600 (1 hour)
```

**Example:**
```
Type: A
Name: n8n
Value: 192.168.1.100
TTL: 3600
```

### DNS Propagation

**Wait for DNS changes:**
- DNS changes take 5-60 minutes to propagate
- Use online tools to check propagation
- Test with: `nslookup yourdomain.com`

**Verify DNS:**
```bash
nslookup n8n.yourdomain.com
```

## 5.2 Install Caddy Web Server

### Why Caddy?

**Benefits:**
- **Automatic HTTPS:** Free SSL certificates
- **Simple configuration:** Easy to set up
- **Modern security:** HTTP/2, TLS 1.3
- **Reverse proxy:** Routes traffic to N8N

### Install Caddy

```bash
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update
sudo apt install -y caddy
```

### Verify Installation

```bash
caddy version
sudo systemctl status caddy
```

## 5.3 Configure Caddy

### Basic Configuration

**Edit Caddyfile:**
```bash
sudo nano /etc/caddy/Caddyfile
```

**Replace contents with:**
```
n8n.yourdomain.com {
    reverse_proxy localhost:5678
}
```

**Replace `n8n.yourdomain.com` with your actual domain**

### Restart Caddy

```bash
sudo systemctl restart caddy
sudo systemctl enable caddy
```

### Verify Configuration

**Check Caddy status:**
```bash
sudo systemctl status caddy
```

**Check Caddy logs:**
```bash
sudo journalctl -u caddy -f
```

## 5.4 SSL Certificate

### Automatic HTTPS

**Caddy automatically:**
- Obtains SSL certificate from Let's Encrypt
- Renews certificates automatically
- Configures HTTP to HTTPS redirects
- Enables modern TLS settings

### First Visit

**Access your domain:**
```
https://n8n.yourdomain.com
```

**What happens:**
1. Caddy detects HTTPS request
2. Automatically gets SSL certificate
3. Redirects to secure connection
4. Proxies to N8N on port 5678

### Certificate Management

**Caddy handles everything automatically:**
- Certificate renewal (30 days before expiry)
- OCSP stapling for performance
- Perfect forward secrecy
- Modern cipher suites

## 5.5 Firewall Configuration

### Allow HTTPS Traffic

```bash
sudo ufw allow 80
sudo ufw allow 443
sudo ufw delete allow 5678  # Remove direct N8N access
sudo ufw reload
```

### Verify Firewall

```bash
sudo ufw status
```

## 5.6 Testing

### Access Tests

**Test HTTPS access:**
```bash
curl -I https://n8n.yourdomain.com
```

**Expected response:**
```
HTTP/2 200
content-type: text/html
...
```

### SSL Certificate Test

**Check certificate:**
```bash
openssl s_client -connect n8n.yourdomain.com:443 -servername n8n.yourdomain.com < /dev/null 2>/dev/null | openssl x509 -noout -dates -issuer -subject
```

**Online SSL checkers:**
- SSL Labs: `ssllabs.com/ssltest/`
- DigiCert: `digicert.com/help/`

## 5.7 Troubleshooting

### DNS Issues

**DNS not resolving:**
```bash
# Check DNS
nslookup n8n.yourdomain.com

# Check local DNS
cat /etc/resolv.conf
```

### Certificate Issues

**Certificate not issued:**
```bash
# Check Caddy logs
sudo journalctl -u caddy -n 50

# Test domain reachability
curl -I http://n8n.yourdomain.com
```

### Connection Issues

**Port 80/443 blocked:**
```bash
# Check firewall
sudo ufw status

# Test ports
telnet n8n.yourdomain.com 80
telnet n8n.yourdomain.com 443
```

### N8N Not Accessible

**Check N8N status:**
```bash
podman ps
podman logs n8n
```

**Test local access:**
```bash
curl http://localhost:5678
```

## 5.8 Advanced Configuration

### Custom SSL Settings

**Edit Caddyfile for advanced options:**
```bash
n8n.yourdomain.com {
    reverse_proxy localhost:5678
    
    # Custom TLS settings
    tls {
        protocols tls1.2 tls1.3
        ciphers TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384 TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256
    }
    
    # Security headers
    header {
        Strict-Transport-Security "max-age=31536000;"
        X-Frame-Options "DENY"
        X-Content-Type-Options "nosniff"
    }
}
```

### Multiple Domains

**Host multiple services:**
```bash
n8n.yourdomain.com {
    reverse_proxy localhost:5678
}

api.yourdomain.com {
    reverse_proxy localhost:3000
}
```

## 5.9 Domain & HTTPS Checklist

### DNS Configuration
- [ ] Domain registrar DNS settings accessed
- [ ] A record created for subdomain
- [ ] DNS propagation verified
- [ ] Domain resolves to server IP

### Caddy Setup
- [ ] Caddy installed and running
- [ ] Caddyfile configured with domain
- [ ] Service restarted successfully
- [ ] Logs show no errors

### SSL Certificate
- [ ] HTTPS access working
- [ ] Certificate automatically obtained
- [ ] No SSL warnings in browser
- [ ] Certificate details verified

### Security
- [ ] Firewall configured for 80/443
- [ ] Direct N8N port (5678) blocked
- [ ] HTTPS redirect working
- [ ] Security headers applied

### Testing
- [ ] Domain accessible via HTTPS
- [ ] N8N loads without warnings
- [ ] SSL certificate valid
- [ ] Performance acceptable

## 🏁 Chapter Summary

Your N8N server now has a professional domain and SSL security! You've accomplished:
- Custom domain configuration
- DNS record setup and propagation
- Caddy web server installation and configuration
- Automatic SSL certificate from Let's Encrypt
- HTTPS encryption and security headers
- Firewall optimization for web traffic

**Your N8N instance is now accessible at:**
`https://n8n.yourdomain.com`

**Test your secure setup:**
1. Visit `https://n8n.yourdomain.com`
2. Check for SSL certificate (lock icon)
3. Verify no security warnings

## 📚 Additional Resources

- [Caddy Documentation](https://caddyserver.com/docs/)
- [Let's Encrypt](https://letsencrypt.org/)
- [DNS Propagation Checker](https://dnschecker.org/)
- [SSL Certificate Checker](https://ssllabs.com/ssltest/)

---

**Next:** [Chapter 6: Backup System →](./../06-backup-system/README.md)
