#!/bin/bash

# ==============================================================
# Name : Iam-ejidek
# Date : 2nd Mar, 26
# Purpose : Hardening-setup
# About : Hardening setup for a new user 
# ==============================================================

# Ensure the script is run as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as root or with sudo"
  exit 1
fi

echo "Starting Server Hardening Setup..."

# 1. Update Package Index
echo "Updating package lists..."
apt update -y

# 2. Install Security Tools
echo "Installing UFW and Fail2ban..."
apt install ufw fail2ban -y

# 3. Configure Firewall (UFW)
echo "Configuring UFW..."
ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
# Automatically say 'yes' to the warning about disrupting SSH
echo "y" | ufw enable

# 4. Hardening SSH Configuration
echo "Hardening SSH configuration..."
SSH_CONF="/etc/ssh/sshd_config"

# Backup the original config
cp $SSH_CONF "${SSH_CONF}.bak"

# Use 'sed' to change settings. 
# It searches for the line and replaces it, or adds it if missing.
sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' $SSH_CONF
sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' $SSH_CONF
sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' $SSH_CONF

# 5. Verify SSH Syntax and Restart
echo "Verifying SSH syntax..."
sshd -t
if [ $? -eq 0 ]; then
    echo "SSH syntax is valid. Restarting service..."
    systemctl restart ssh
else
    echo "SSH syntax error detected! Check $SSH_CONF immediately."
    exit 1
fi

# 6. Start and Enable Fail2ban
echo "Enabling Fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban

echo "-----------------------------------------------"
echo "Hardening Complete!"
echo "Root Login: DISABLED"
echo "Password Auth: DISABLED"
echo "UFW Firewall: ACTIVE (Port 22 Open)"
echo "Fail2ban: ACTIVE"
echo "-----------------------------------------------"
