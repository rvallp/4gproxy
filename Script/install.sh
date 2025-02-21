#!/bin/bash

# Set default values
DEFAULT_USERNAME="admin"
DEFAULT_PWD="admin"
DEFAULT_DIR="/root/allproxyS"

SPDIR="/etc/"
SPCONFDIR="/etc/supervisor.d/"

# Prompt for directory and username/password with defaults
read -p "Enter allproxy directory [default is $DEFAULT_DIR]: " ALLPDIR
ALLPDIR=${ALLPDIR:-$DEFAULT_DIR}

read -p "Enter username [default is $DEFAULT_USERNAME]: " USERNAME
USERNAME=${USERNAME:-$DEFAULT_USERNAME}

read -p "Enter password [default is $DEFAULT_PWD]: " USERPWD
USERPWD=${USERPWD:-$DEFAULT_PWD}

# Detect OS
if [ -f /etc/lsb-release ] || [ -f /etc/debian_version ]; then
    if [ -f /etc/lsb-release ]; then
        OS="Ubuntu"
        SPDIR="/etc/supervisor/"
        SPCONFDIR="/etc/supervisor/conf.d/"
        CON_NAME="allproxyS.conf"
    else
        OS="Debian"
        SPDIR="/etc/supervisor/"
        SPCONFDIR="/etc/supervisor/conf.d/"
        CON_NAME="allproxyS.conf"
    fi
elif [ -f /etc/redhat-release ]; then
    OS="CentOS"
    CON_NAME="allproxyS.ini"
    sudo yum install -y epel-release
else
    echo "This script is only compatible with Ubuntu, Debian, and CentOS systems."
    exit 1
fi

# Update package list and upgrade
case "$OS" in
    "Ubuntu"|"Debian")
        sudo apt-get update
        sudo apt-get upgrade -y
        sudo apt-get install -y gnupg
        ;;
    "CentOS")
        sudo yum update -y
        ;;
esac

# Install MongoDB
case "$OS" in
    "Ubuntu")
        wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
        echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
        ;;
    "Debian")
        wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
        echo "deb http://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/5.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
        ;;
    "CentOS")
        sudo rpm --import https://www.mongodb.org/static/pgp/server-5.0.asc
        echo -e "[mongodb-org-5.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/5.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo
        ;;
esac

# Install MongoDB package
case "$OS" in
    "Ubuntu"|"Debian")
        sudo apt-get update
        sudo apt-get install -y mongodb-org
        ;;
    "CentOS")
        sudo yum install -y mongodb-org
        ;;
esac

# Start MongoDB service
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Supervisor
case "$OS" in
    "Ubuntu"|"Debian")
        sudo apt-get install -y supervisor
        ;;
    "CentOS")
        sudo yum install -y supervisor
        ;;
esac

# Create Supervisor configuration
sudo mkdir -p "$SPCONFDIR"  # Ensure directory exists
cat << EOF | sudo tee "$SPCONFDIR/$CON_NAME"
[program:allproxyS]
directory=$ALLPDIR
command=$ALLPDIR/allproxyS_x
user=root
stopsignal=INT
autostart=true
autorestart=true
startretries=3
stderr_logfile=/var/log/allproxys.err.log
stdout_logfile=/var/log/allproxys.out.log
EOF

# Configure supervisor minfds
if ! grep -q "minfds=200000" /etc/supervisor/supervisord.conf 2>/dev/null; then
    sudo cp /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.bak 2>/dev/null || true
    echo "[supervisord]" | sudo tee /etc/supervisor/supervisord.conf >/dev/null
    echo "minfds=200000" | sudo tee -a /etc/supervisor/supervisord.conf >/dev/null
    echo "minfds=200000 added to supervisord.conf"
else
    echo "minfds=200000 already exists in supervisord.conf"
fi

# Configure system limits
if ! grep -q "* soft nofile 200000" /etc/security/limits.conf; then
    echo "* soft nofile 200000" | sudo tee -a /etc/security/limits.conf
    echo "* hard nofile 200000" | sudo tee -a /etc/security/limits.conf
    echo "Limits added to limits.conf"
else
    echo "File descriptor limits already configured"
fi

# Restart supervisor
sudo systemctl restart supervisor

echo "Installation complete!"