#!/bin/bash

# Get the directory where the script is located
script_dir=$(dirname "$(readlink -f "$0")")

# Set the backup directory to the same directory as the script
backup_dir="$script_dir/backups"

# Prompt the user to enter the name of the database to backup
read -p "Enter the name of the database to backup: " database_name

# Set the name of the backup file
backup_file="$database_name_$(date +%Y-%m-%d-%H-%M-%S).gz"

# Create the backup directory if it doesn't exist
if [ ! -d "$backup_dir" ]; then
    mkdir -p "$backup_dir"
fi

# Backup the database using mongodump and compress the output using gzip
mongodump --db "$database_name" --archive | gzip > "$backup_dir/$backup_file"

# Print a message indicating that the backup was successful
echo "Backup of $database_name completed successfully! The backup file is located at $backup_dir/$backup_file."
