#!/bin/bash

# Set default username
DEFAULT_USERNAME="admin"
DEFAULT_PWD="admin"
DEFAULT_DIR="/root/allproxyS"

SPDIR="/etc/"
SPCONFDIR="/etc/supervisor.d/"

# Prompt for username
read -p "Enter allproxy directory [default is $DEFAULT_DIR]: " ALLPDIR
ALLPDIR=${ALLPDIR:-$DEFAULT_DIR}

# Prompt for username
read -p "Enter username [default is $DEFAULT_USERNAME]: " USERNAME

# Use default username if input is empty
USERNAME=${USERNAME:-$DEFAULT_USERNAME}

read -p "Enter username [default is $DEFAULT_PWD]: " USERPWD
USERPWD=${USERPWD:-$DEFAULT_PWD}

# Check if the system is Ubuntu or CentOS
if [ -f /etc/lsb-release ]; then
  OS="Ubuntu"
  SPDIR="/etc/supervisor/"
  SPCONFDIR="/etc/supervisor/conf.d/"
  CON_NAME="allproxyS.conf"
elif [ -f /etc/redhat-release ]; then
  sudo yum install -y epel-release
  OS="CentOS"
  CON_NAME="allproxyS.ini"
else
  echo "This script is only compatible with Ubuntu and CentOS systems."
  exit 1
fi

# Update the package list and upgrade existing packages
if [ "$OS" == "Ubuntu" ]; then
  sudo apt-get update
  sudo apt-get upgrade -y
  sudo apt-get install -y gnupg
elif [ "$OS" == "CentOS" ]; then
  sudo yum update -y
fi

# Import the MongoDB public key
if [ "$OS" == "Ubuntu" ]; then
  wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
elif [ "$OS" == "CentOS" ]; then
  sudo rpm --import https://www.mongodb.org/static/pgp/server-5.0.asc
fi

# Create a list file for MongoDB
if [ "$OS" == "Ubuntu" ]; then
  echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu $(lsb_release -cs)/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
  sudo apt-get update
  sudo apt-get install -y mongodb-org
elif [ "$OS" == "CentOS" ]; then
  echo -e "[mongodb-org-5.0]\nname=MongoDB Repository\nbaseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/5.0/x86_64/\ngpgcheck=1\nenabled=1\ngpgkey=https://www.mongodb.org/static/pgp/server-5.0.asc" | sudo tee /etc/yum.repos.d/mongodb-org-5.0.repo
  sudo yum install -y mongodb-org
fi

# Start the MongoDB service and enable it to start on boot
sudo systemctl start mongod
sudo systemctl enable mongod

# Install Supervisor
if [ "$OS" == "Ubuntu" ]; then
  sudo apt-get install -y supervisor
elif [ "$OS" == "CentOS" ]; then
  sudo yum install -y supervisor
fi



# Create the default application configuration file for Supervisor
sudo echo -e "[program:allproxyS]\ndirectory=/root/allproxyS\ncommand=/root/allproxyS/allproxyS_x\nuser=root\nstopsignal=INT\nautostart=true\nautorestart=true\nstartretries=3\nstderr_logfile=/var/log/allproxys.err.log\nstdout_logfile=/var/log/allproxys.out.log" > $SPCONFDIR/$CON_NAME

#change minfds
#!/bin/bash

# Check if "minfds=200000" already exists in "supervisord.conf"
if grep -q "minfds=200000" /etc/supervisor/supervisord.conf; then
    echo "minfds=200000 already exists in supervisord.conf"
else
    # Backup original supervisor.conf file
    sudo cp /etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf.bak
    
    # Add "minfds=200000" to "[supervisord]" section in supervisor.conf
    sudo sed -i '/\[supervisord\]/a minfds=200000' /etc/supervisor/supervisord.conf

    # Restart Supervisor
    sudo systemctl restart supervisor

    echo "minfds=200000 added to supervisord.conf successfully!"
fi

# Check if "* soft nofile 200000" already exists in "limits.conf"
if grep -q "* soft nofile 200000" /etc/security/limits.conf; then
    echo "* soft nofile 200000 already exists in limits.conf"
else
    # Add "* soft nofile 200000" to "/etc/security/limits.conf"
    echo "* soft nofile 200000" | sudo tee -a /etc/security/limits.conf

    # Add "* hard nofile 200000" to "/etc/security/limits.conf"
    echo "* hard nofile 200000" | sudo tee -a /etc/security/limits.conf

    echo "Limits added to limits.conf successfully!"
fi


sudo systemctl restart supervisor

echo "Installation complete!"

