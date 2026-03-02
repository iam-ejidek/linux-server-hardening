# Linux Server Hardening

A collection of shell scripts that automate the security configuration and ongoing maintenance of a fresh Linux server. Built as a hands-on exercise in Infrastructure as Code (IaC) and Operational Security.

---

## Project Structure

```
linux-server-hardening/
 ├── scripts/
 │   ├── hardening-setup.sh      
 │   └── security-updates.sh     
 ├── hardening-checklist.md      
 └── README.md                   
```

---

## Scripts Overview

### 1. `hardening-setup.sh` — Run Once (Day 1)

This script automates the initial hardening of a fresh server. It is designed to be **idempotent** — safe to inspect, but intended as a one-shot setup.

**What it does:**
- Creates a `deployer` sudo user
- Configures UFW firewall (deny all inbound, allow SSH on port 22)
- Installs and enables **Fail2ban** to block brute-force attempts
- Hardens `/etc/ssh/sshd_config`:
  - Disables root login (`PermitRootLogin no`)
  - Disables password authentication (`PasswordAuthentication no`)
  - Enforces key-based auth only (`PubkeyAuthentication yes`)
- Restarts the SSH daemon to apply changes

**How to run:**
```bash
chmod +x scripts/hardening-setup.sh
sudo ./scripts/hardening-setup.sh
```

> ⚠️ **Warning:** Ensure your SSH public key is already on the server **before** running this script. Once password auth is disabled, keys are your only way in.

---

### 2. `security-updates.sh` — Runs Every Sunday at 3 AM (Ongoing)

This script handles routine system maintenance and security patching. It is designed to run on a **cron schedule** with no human interaction.

**What it does:**
- Updates the package list (`apt update`)
- Installs available security patches (`apt upgrade`)
- Removes unused packages (`apt autoremove`)
- Logs all output with timestamps to `/var/log/update_script.log`

**How to schedule it (cron):**
```bash
# Open crontab editor
crontab -e

# Add this line to run every Sunday at 3:00 AM
0 3 * * 0 /path/to/scripts/security-updates.sh
```

**How to check the logs:**
```bash
cat /var/log/update_script.log
# or tail live output:
tail -f /var/log/update_script.log
```

---

## Manual Setup Steps (Before Running Scripts)

These steps must be done **manually** before the scripts can take over:

1. **Generate SSH key pair** (on your local machine, not the server):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Copy your public key to the server:**
   ```bash
   ssh-copy-id deployer@your-server-ip
   ```

3. **Verify key-based login works** before closing your root session:
   ```bash
   ssh deployer@your-server-ip
   ```

---

## Security Layers Implemented

| Layer | Tool | Purpose |
|---|---|---|
| User Management | `adduser` / `usermod` | Eliminate root login exposure |
| SSH Hardening | `sshd_config` | Keys-only, no password brute-force |
| Firewall | UFW | Deny all inbound except SSH |
| Intrusion Prevention | Fail2ban | Auto-ban repeated failed logins |
| Patch Management | `apt` + cron | Close known vulnerabilities automatically |

---

## Why Two Scripts?

Most tutorials give you one big script. That's not how production works.

- **`hardening-setup.sh`** is Infrastructure as Code — it proves you can automate a repeatable, documented setup process.
- **`security-updates.sh`** is Operational Security — it proves you understand that a server secured on Day 1 can still be compromised on Day 90 if patches aren't applied.

These have **different lifecycles** and should never be merged into one file.

---

## Environment

- Tested on: Ubuntu 22.04 LTS
- Required: Root or sudo access on initial run
- Dependencies: `ufw`, `fail2ban`, `apt` (all standard on Ubuntu)
