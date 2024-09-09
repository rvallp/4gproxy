#!/bin/bash

# Prompt the user to enter the name of the database to restore
read -p "Enter the name of the database to restore: " database_name

# Prompt the user to enter the name of the backup file to restore from
read -p "Enter the name of the backup file to restore from (including the .gz extension): " backup_file

# Restore the database using mongorestore
mongorestore --gzip --archive="$backup_file" --db="$database_name"

# Print a message indicating that the restore was successful
echo "Restore of $database_name from $backup_file completed successfully!"
