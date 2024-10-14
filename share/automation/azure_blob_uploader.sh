#!/bin/bash

# Purpose : Upload files to Azure Blob Storage from the drop point /share/files

# Usage : ./azure_blob_uploader.sh or bash azure_blob_uploader.sh

HOME=/share/
LOG=/share/log/azure_blob_uploader.log
FILES=/share/files

# Check if the log file exists
if [ ! -f $LOG ]; then
    touch $LOG
fi

# Function to write to log
write_to_log() {
    echo "$(date) : $1" >> $LOG
}

write_to_log "Starting the Azure Blob Uploader"

# Count the number of files in the directory
count=$(find "$FILES" -type f | wc -l)
write_to_log "Number of files to upload : $count"

# Get the Azure Blob Storage connection string
AZURE_BLOB_CONNECTION=''

# Extract account name and key from connection string
AccountName=$(echo $AZURE_BLOB_CONNECTION | sed -n 's/.*AccountName=\([^;]*\).*/\1/p')
AccountKey=$(echo $AZURE_BLOB_CONNECTION | sed -n 's/.*AccountKey=\([^;]*\).*/\1/p')

# Set the container name (you may want to define this variable)
CONTAINER="$CLIENT"

write_to_log "Targeted Container : $CONTAINER"

# Check if the CLIENT variable is set
if [ -z "$CONTAINER" ]; then
    write_to_log "Error: CLIENT variable not set. Exiting."
    exit 1
fi

# Check if the container exists
if ! az storage container exists --name "$CONTAINER" --account-name "$AccountName" --account-key "$AccountKey" | grep -q '"exists": true'; then
    write_to_log "Container $CONTAINER does not exist. Creating it..."
    create_output=$(az storage container create --name "$CONTAINER" --account-name "$AccountName" --account-key "$AccountKey")
    if echo "$create_output" | grep -q '"created": true'; then
        write_to_log "Container $CONTAINER created successfully."
        sleep 5  # Wait for 5 seconds to ensure the container creation is processed
    else
        write_to_log "Error: Failed to create container $CONTAINER. Exiting."
        exit 1
    fi
else
    write_to_log "Container $CONTAINER already exists."
fi

# Upload files to the Azure Blob Storage using find
find "$FILES" -type f | while IFS= read -r file; do
    if az storage blob upload --container-name "$CONTAINER" --file "$file" --name "$(basename "$file")" --account-name "$AccountName" --account-key "$AccountKey"; then
        write_to_log "Uploaded file: $(basename "$file")"
    else
        write_to_log "Error uploading file: $(basename "$file")"
    fi
done


write_to_log "Upload process completed."
