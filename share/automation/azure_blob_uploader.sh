#!/bin/bash

# Purpose : Upload files to Azure Blob Storage from the drop point /share/files

# Usage : ./azure_blob_uploader.sh or bash azure_blob_uploader.sh


HOME=/share/
LOG=/share/log/azure_blob_uploader.log
FILES=/share/files
ENV=../.env

# Check if the log file exists
if [ ! -f $LOG ]; then
    touch $LOG
fi

# Function to write to log
write_to_log() {
    echo "$(date) : $1" >> $LOG
}



write_to_log "Starting the Azure Blob Uploader"

# Count the no of files in the directory
count=$(ls -1 $FILES | wc -l)

write_to_log "No of files to upload : $count"

# Get the azure credentials from the .env file




