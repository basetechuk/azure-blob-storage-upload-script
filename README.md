# Azure Blob Uploader Script

## Overview

The **Azure Blob Uploader** script automates the process of uploading files from a designated drop point (`/share/files`) to Azure Blob Storage. This solution enhances file transfer efficiency and security compared to traditional methods like SFTP.

### Key Features

- **Automated Uploads**: Eliminates manual effort and reduces human error by automating file uploads.
- **Comprehensive Logging**: All actions are logged with timestamps and detailed messages, allowing for easy monitoring and troubleshooting.
- **Dynamic Container Management**: The script checks for the existence of the specified Azure Blob Storage container and creates it if necessary, ensuring organized file storage.
- **Seamless Azure Integration**: Utilizes Azure's secure and scalable storage solutions, providing superior performance and reliability over conventional file transfer methods.
- **Avoid Duplication**: Prevents duplicate uploads by checking the existence of files in the Azure Blob Storage container before uploading.

## Advantages Over SFTP and Traditional Methods

1. **Scalability**: Azure Blob Storage can accommodate vast amounts of data, allowing for dynamic scaling based on storage needs, unlike traditional servers that may require hardware upgrades.
2. **Security**: Azure provides advanced security measures, including encryption at rest and in transit, which often surpass standard SFTP configurations.
3. **Cost-Effectiveness**: Azure Blob Storage operates on a pay-as-you-go model, ensuring you only pay for what you use, making it economical for variable storage needs.
4. **Accessibility**: Files in Azure Blob Storage can be accessed from anywhere, enhancing collaboration efficiency compared to local SFTP servers.


## Running the Script 

1. Start the Docker containers from the root directory:
   ```bash
   docker-compose up -d
   ```
2. Access the `dev_os` container:
   ```bash
    docker exec -it dev_os bash
    ```
3. If you have not installed az, see the prerequisites section below.

4. Drop the files you want to upload into the `/share/files` directory outside the container.

5. Run the script:
   ```bash
   bash /share/automation/azure_blob_uploader.sh
   ```


## Cron Job Setup

### Purpose
The Azure Blob Uploader can be scheduled as a cron job to ensure consistent file uploads at specified intervals without manual intervention.

### Setting Up the Cron Job (Ofelia)

Follow these steps to configure the Azure Blob Uploader as a cron job:

1. **Edit the Ofelia Configuration File**: Access the configuration file for editing:
   ```bash
   cd /ofelia/config
   nano config.ini
   ```

2. **Add the Cron Job**: Insert the following line into the configuration file to schedule the Azure Blob Uploader script to run every hour:
   ```ini
   [job-exec "azure-uploader"]
   schedule = "@every 1h"
   container = "dev_os"
   command = "/bin/bash /share/automation/azure_blob_uploader.sh"
   no-overlap = true
   ```

3. **Save and Exit**: Save your changes and exit the editor. The cron job is now configured to run the Azure Blob Uploader script automatically.

4. **Restart Ofelia**: Restart the Ofelia service to apply the changes:
   ```bash
   docker restart <ofelia_container_id or ofelia_container_name>
   ```

## Prerequisites (Linux)

- **Docker Installed**: Ensure Docker is installed and configured.
- **Environment Variables**: Create a `.env` file with the following variables:
  - `AZURE_STORAGE_ACCOUNT`
  - `AZURE_STORAGE_KEY`
  - `CLIENT`
- **Azure CLI**: Install and configure the Azure CLI with appropriate permissions to access your Azure Blob Storage account. To install the Azure CLI in the `dev_os` container, run the following commands:
   ```bash
   # Update package list and install required packages
   apt-get update && apt-get install -y \
       curl \
       apt-transport-https \
       lsb-release \
       gnupg2

   # Install the Microsoft signing key
   curl -sL https://packages.microsoft.com/keys/microsoft.asc | apt-key add -

   # Add the Azure CLI software repository
   echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list

   # Update package list and install Azure CLI
   apt-get update && apt-get install -y azure-cli

   # Clean up
   apt-get clean && rm -rf /var/lib/apt/lists/*
   ```

- **Environment Variables Mapping**: Ensure that environment variables are set outside the container, as they will be mapped to the container.

### Log File

All log entries are written to `/share/log/azure_blob_uploader.log`, providing a complete history of upload operations. Check this file for success messages and any errors encountered during the process.

## Conclusion

The Azure Blob Uploader script streamlines file uploads to Azure Blob Storage, offering a secure, scalable, and efficient alternative to traditional methods. With its logging and dynamic container management features, it ensures that your data transfer needs are met seamlessly.

For further assistance or customization options, please contact the development team.