#!/bin/bash

# Function to display messages in green color
print_success() {
  echo -e "\e[32m$1\e[0m"
}

# Function to display messages in red color
print_error() {
  echo -e "\e[31m$1\e[0m"
}

# Function to prompt user for input with a default value
prompt_user() {
  read -p "$1 [$2]: " input
  echo "${input:-$2}"
}

# Welcome message
echo "Welcome to the AppImage installer wizard!"

# Prompt user for AppImage file path
APPIMAGE_PATH=$(prompt_user "Enter the path to the AppImage file")

# Prompt user for installation directory
INSTALL_DIR=$(prompt_user "Enter the installation directory" "$HOME/Applications")

# Prompt user for the name of the program
PROGRAM_NAME=$(prompt_user "Enter the name of the program" "$(basename "$APPIMAGE_PATH" | cut -d. -f1)")

# Set the installation path
FULL_PATH="$INSTALL_DIR/$PROGRAM_NAME"

# Ensure the installation directory exists
mkdir -p "$INSTALL_DIR"

# Copy AppImage to installation directory
cp "$APPIMAGE_PATH" "$FULL_PATH"

# Set execute permissions
chmod +x "$FULL_PATH"

# Create a symbolic link in /usr/local/bin
sudo ln -s "$FULL_PATH" "/usr/local/bin/$PROGRAM_NAME"

# Create a desktop entry file
DESKTOP_ENTRY="[Desktop Entry]
Name=$PROGRAM_NAME
Exec=$PROGRAM_NAME
Type=Application
Categories=Utility;
"

DESKTOP_ENTRY_PATH="$HOME/.local/share/applications/$PROGRAM_NAME.desktop"
echo "$DESKTOP_ENTRY" > "$DESKTOP_ENTRY_PATH"

# Display success messages
print_success "AppImage installed successfully!"
print_success "Symbolic link created in /usr/local/bin."
print_success "Program added to the start menu."

# Provide information to the user
echo -e "\nYou can run the program using the terminal command: \e[1m$PROGRAM_NAME\e[0m"
echo -e "You can also find it in the start menu or by searching for \e[1m$PROGRAM_NAME\e[0m."