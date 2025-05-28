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
appimage_path=$(prompt_user "Enter the path to the AppImage file")

# Prompt user for installation directory
install_dir=$(prompt_user "Enter the installation directory" "$HOME/Applications")

# Prompt user for the name of the program
program_name=$(prompt_user "Enter the name of the program" "$(basename "$appimage_path" | cut -d. -f1)")

# Set the installation path
full_path="$install_dir/$program_name"

# Ensure the installation directory exists
mkdir -p "$install_dir"

# Copy AppImage to installation directory
cp "$appimage_path" "$full_path"

# Set execute permissions
chmod +x "$full_path"

# Create a symbolic link in /usr/local/bin
sudo ln -s "$full_path" "/usr/local/bin/$program_name"

# Create a desktop entry file
desktop_entry="[Desktop Entry]
Name=$program_name
Exec=$program_name
Type=Application
Categories=Utility;
"

desktop_entry_path="$HOME/.local/share/applications/$program_name.desktop"
echo "$desktop_entry" > "$desktop_entry_path"

# Display success messages
print_success "AppImage installed successfully!"
print_success "Symbolic link created in /usr/local/bin."
print_success "Program added to the start menu."

# Provide information to the user
echo -e "\nYou can run the program using the terminal command: \e[1m$program_name\e[0m"
echo -e "You can also find it in the start menu or by searching for \e[1m$program_name\e[0m."