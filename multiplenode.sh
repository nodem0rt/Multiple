#!/bin/bash

# Auto-Install Script for Multiple for Linux
# Tested for Ubuntu

# Variables
URL="https://cdn.app.multiple.cc/client/linux/x64/multipleforlinux.tar"
DESTINATION="/tmp/multipleforlinux.tar"
INSTALL_DIR="/opt/multipleforlinux"
DESKTOP_SHORTCUT="$HOME/.local/share/applications/multiple.desktop"

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use sudo to run it."
    exit 1
fi

# Step 1: Download the tar file
echo "Downloading Multiple for Linux..."
curl -L "$URL" -o "$DESTINATION"
if [ $? -ne 0 ]; then
    echo "Error: Failed to download the file. Please check the URL."
    exit 1
fi
echo "Download complete."

# Step 2: Extract the tar file
echo "Extracting the tar file..."
mkdir -p "$INSTALL_DIR"
tar -xf "$DESTINATION" -C "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo "Error: Failed to extract the tar file."
    exit 1
fi
echo "Extraction complete."

# Step 3: Add to PATH (Optional)
if ! grep -q "$INSTALL_DIR" <<< "$PATH"; then
    echo "Adding $INSTALL_DIR to PATH..."
    echo "export PATH=\$PATH:$INSTALL_DIR" >> /etc/profile
    source /etc/profile
    echo "PATH updated."
fi

# Step 4: Create a desktop shortcut (Optional)
echo "Creating a desktop shortcut..."
mkdir -p "$(dirname "$DESKTOP_SHORTCUT")"
cat <<EOF > "$DESKTOP_SHORTCUT"
[Desktop Entry]
Name=Multiple for Linux
Exec=$INSTALL_DIR/multiple
Type=Application
Terminal=false
Icon=$INSTALL_DIR/icon.png
EOF
chmod +x "$DESKTOP_SHORTCUT"
echo "Desktop shortcut created."

# Step 5: Clean up
echo "Cleaning up temporary files..."
rm "$DESTINATION"
echo "Temporary files removed."

# Final message
echo "Installation complete! You can run the application from $INSTALL_DIR or via the desktop shortcut."
