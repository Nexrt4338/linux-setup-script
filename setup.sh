#!/bin/bash

# Automated Linux Setup & Security Hardening Script
# Author: Your Name
# GitHub: Your GitHub Link

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root!" 
   exit 1
fi

echo "Updating system packages..."
apt update && apt upgrade -y

echo "Creating a new user..."
read -p "Enter new username: " username
adduser $username
usermod -aG sudo $username
echo "User $username added to sudo group."

echo "Setting up SSH Key Authentication..."
mkdir -p /home/$username/.ssh
chown -R $username:$username /home/$username/.ssh
chmod 700 /home/$username/.ssh
echo "SSH key authentication directory created."

echo "Configuring Firewall..."
ufw allow OpenSSH
ufw --force enable
echo "Firewall enabled with SSH access."

echo "Securing SSH..."
sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
systemctl restart sshd
echo "SSH security settings applied. Default port changed to 2222."

echo "Installing Fail2Ban..."
apt install fail2ban -y
systemctl enable fail2ban
systemctl start fail2ban
echo "Fail2Ban installed and running."

echo "Hardening complete! Please reboot the system."
