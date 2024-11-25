#!/bin/bash

# Auto-Install Script for Multiple for Linux
# Tested for Ubuntu

# Variables
URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo to run it."
    exit 1
fi

# Step 1: Update & Download the tar file
sudo apt update && sudo apt upgrade -y
echo "Downloading Multiple for Linux..."
curl -L "$URL" -o multipleforlinux.tar
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the file. Please check the URL."
    exit 1
fi
echo "Download complete."

# Step 2: Extract the tar file
echo "Extracting files..."
tar -xvf multipleforlinux.tar

cd multipleforlinux

echo "Granting permissions..."
chmod +x ./multiple-cli
chmod +x ./multiple-node

# Step 3: Add to PATH (Optional)
echo "Adding directory to system PATH..."
echo "PATH=\$PATH:$(pwd)" >> ~/.bash_profile
source ~/.bash_profile

echo "Setting permissions..."
chmod -R 777 $(pwd)

echo "Launching multiple-node..."
nohup ./multiple-node > output.log 2>&1 &

echo "Please enter your Identification Code and Create New PIN to bind your account:"
read -p "Identification Code: " IDENTIFICATION CODE
read -p "Set your PIN: " PIN

echo "Binding account with ID: $IDENTIFICATIONCODE and PIN: $PIN..."
multiple-cli bind --bandwidth-download 100 --identifier $IDENTIFICATIONCODE --pin $PIN --storage 200 --bandwidth-upload 100

# Final message
echo "Installation complete! You can run the application - Subscribe: https://t.me/CryptoNodeID."
