#!/bin/bash

# Check if running as root
if [[ $(id -u) -eq 0 ]]; then
    echo "Please run this script as a regular user, not as root."
    exit 1
fi

# Define dotfiles repository URL
DOTFILES_REPO="https://github.com/ProMaster-4/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Install dependencies
echo "Installing dependencies..."
sudo pacman -S --noconfirm feh git kitty picom pipewire

# Install Starship prompt via Rust
echo "Installing Starship prompt..."
curl -fsSL https://starship.rs/install.sh | bash

# Clone dotfiles repository
echo "Cloning dotfiles repository..."
git clone $DOTFILES_REPO $DOTFILES_DIR || { echo "Failed to clone dotfiles repository. Exiting..."; exit 1; }

# Replace the hardcoded home directory in the config files
echo "Replacing home directory in configuration files..."
sed -i "s|/home/pro|$HOME|g" $DOTFILES_DIR/dotfiles/.config/nitrogen/bg-saved.cfg
sed -i "s|/home/pro|$HOME|g" $DOTFILES_DIR/dotfiles/.config/nitrogen/nitrogen.cfg

# Install dotfiles
echo "Installing dotfiles..."
cd $DOTFILES_DIR/dotfiles
./install.sh || { echo "Failed to install dotfiles. Exiting..."; exit 1; }

echo "Dotfiles installed successfully!"
