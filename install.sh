#!/bin/bash

# Variables
MOUNT_POINT="/Volumes/Tech"  # Update the desired mount point

# Check if DOMAIN_USER and DOMAIN_PASS are set
if [ -z "$DOMAIN_USER" ] || [ -z "$DOMAIN_PASS" ]; then
  echo "DOMAIN_USER and DOMAIN_PASS must be set."
  exit 1
fi

TARGET_DIR="/Volumes/Tech/Mac/SystemReports"

# Mount the SMB share
sudo mkdir -p "$MOUNT_POINT"
sudo mount -t smbfs "//$DOMAIN_USER:$DOMAIN_PASS@134.139.94.35/Tech" "$MOUNT_POINT"

# Generate system report
REPORT_FILE="/tmp/system_report.txt"
system_profiler > $REPORT_FILE

# Copy the report to the SMB share
sudo cp $REPORT_FILE "$TARGET_DIR"

# Clean up the local report
rm $REPORT_FILE

# Define the directory where the package resides
PACKAGE_NAME=$"/Mac/Adobe/Installers/Creative Cloud for M1/CLA - Mac M1 CC_Install.pkg"

# Check if the package exists
if [ -z "$PACKAGE_NAME" ]; then
  echo "No .pkg file found in the given directory."
  exit 1
fi

# Install the package
sudo installer -pkg $PACKAGE_NAME -target /

# Exit status
if [ $? -eq 0 ]; then
  echo "Package installed successfully."


else
  echo "Package installation failed."
  exit 1
fi

# Unmount the SMB share
sudo umount "$MOUNT_POINT"
