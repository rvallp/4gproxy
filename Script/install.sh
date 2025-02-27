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
        # Get Ubuntu version
        source /etc/lsb-release
        UBUNTU_VERSION=$DISTRIB_CODENAME
    else
        OS="Debian"
        SPDIR="/etc/supervisor/"
        SPCONFDIR="/etc/supervisor/conf.d/"
        CON_NAME="allproxyS.conf"
        # Get Debian version
        DEBIAN_VERSION=$(cat /etc/debian_version | cut -d. -f1)
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
        sudo apt-get install -y gnupg curl
        ;;
    "CentOS")
        sudo yum update -y
        ;;
esac

# Install MongoDB
case "$OS" in
    "Ubuntu")
        # For Ubuntu, use MongoDB 7.0 for newer versions, 6.0 for older versions
        if [[ "$UBUNTU_VERSION" == "jammy" || "$UBUNTU_VERSION" == "noble" ]]; then
            # Ubuntu 22.04 (Jammy) or 24.04 (Noble) - use MongoDB 7.0
            curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
            MONGODB_VERSION="7.0"
        else
            # Older Ubuntu versions - use MongoDB 6.0
            curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
            MONGODB_VERSION="6.0"
        fi
        ;;
    "Debian")
        # For Debian, use MongoDB 6.0 for Bullseye (11) and older, 7.0 for Bookworm (12) and newer
        if [[ "$DEBIAN_VERSION" -ge 12 ]]; then
            # Debian 12 (Bookworm) or newer - use MongoDB 7.0
            curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
            MONGODB_VERSION="7.0"
        else
            # Debian 11 (Bullseye) or older - use MongoDB 6.0
            curl -fsSL https://www.mongodb.org/static/pgp/server-6.0.asc | sudo gpg --dearmor -o /usr/share/keyrings/mongodb-server-6.0.gpg
            echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/debian $(lsb_release -cs)/mongodb-org/6.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
            MONGODB_VERSION="6.0"
        fi
        ;;
    "CentOS")
        # For CentOS, check version
        CENTOS_VERSION=$(rpm -q --queryformat '%{VERSION}' centos-release)
        if [[ "$CENTOS_VERSION" -ge 8 ]]; then
            # CentOS 8 or newer - use MongoDB 7.0
            sudo rpm --import https://www.mongodb.org/static/pgp/server-7.0.asc
            echo -e "[mongodb-org-7.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/$CENTOS_VERSION/mongodb-org/7.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-7.0.repo
            MONGODB_VERSION="7.0"
        else
            # CentOS 7 - use MongoDB 6.0
            sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
            echo -e "[mongodb-org-6.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/$CENTOS_VERSION/mongodb-org/6.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-6.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-6.0.repo
            MONGODB_VERSION="6.0"
        fi
        ;;
esac

echo "Installing MongoDB $MONGODB_VERSION..."

# Install MongoDB package
case "$OS" in
    "Ubuntu"|"Debian")
        sudo apt-get update
        sudo apt-get install -y mongodb-org
        # Check for correct service name
        if systemctl list-units --full -all | grep -q "mongod.service"; then
            SERVICE_NAME="mongod"
        elif systemctl list-units --full -all | grep -q "mongodb.service"; then
            SERVICE_NAME="mongodb"
        else
            echo "Warning: No MongoDB service found. Attempting to use 'mongod'"
            SERVICE_NAME="mongod"
        fi
        ;;
    "CentOS")
        sudo yum install -y mongodb-org
        SERVICE_NAME="mongod"
        ;;
esac

# Start and enable MongoDB service
if systemctl list-units --full -all | grep -q "$SERVICE_NAME.service"; then
    sudo systemctl start "$SERVICE_NAME"
    sudo systemctl enable "$SERVICE_NAME"
    if systemctl is-active "$SERVICE_NAME" >/dev/null; then
        echo "MongoDB service ($SERVICE_NAME) started successfully"
    else
        echo "Error: Failed to start MongoDB service ($SERVICE_NAME)"
        exit 1
    fi
else
    echo "Error: MongoDB service unit ($SERVICE_NAME) not found"
    echo "Please check MongoDB installation and service status manually"
    exit 1
fi

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
sudo mkdir -p "$SPCONFDIR"
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

# Configure supervisor minfds without overwriting existing content
SUPERVISOR_CONF="/etc/supervisor/supervisord.conf"
if [ -f "$SUPERVISOR_CONF" ]; then
    if ! grep -q "minfds=200000" "$SUPERVISOR_CONF" 2>/dev/null; then
        sudo cp "$SUPERVISOR_CONF" "$SUPERVISOR_CONF.bak" 2>/dev/null || true
        # If [supervisord] section exists, append minfds after it
        if grep -q "\[supervisord\]" "$SUPERVISOR_CONF"; then
            sudo sed -i "/\[supervisord\]/a minfds=200000" "$SUPERVISOR_CONF"
        else
            # If no [supervisord] section, append it with minfds
            echo -e "\n[supervisord]\nminfds=200000" | sudo tee -a "$SUPERVISOR_CONF" >/dev/null
        fi
        echo "minfds=200000 added to supervisord.conf"
    else
        echo "minfds=200000 already exists in supervisord.conf"
    fi
else
    # If file doesn't exist, create it with basic content
    echo "[supervisord]" | sudo tee "$SUPERVISOR_CONF" >/dev/null
    echo "minfds=200000" | sudo tee -a "$SUPERVISOR_CONF" >/dev/null
    echo "Created supervisord.conf with minfds=200000"
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