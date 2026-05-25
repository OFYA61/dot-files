#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status
set -e

# Define directories to symlink via Stow
# Note: Excluding 'ollama', 'scripts', and 'setup_scripts' as requested
CONFIG_PACKAGES=(
    "alacritty"
    "nvim"
    "opencode"
    "tmux"
    "waybar"
    "zsh"
)

# Target directory (usually your home folder)
TARGET_DIR="$HOME"

# Get the directory where this script is living
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=========================================="
echo "Starting dotfiles symlinking with GNU Stow"
echo "Dotfiles Directory: $DOTFILES_DIR"
echo "Target Directory:   $TARGET_DIR"
echo "=========================================="

# Ensure we are running from the dotfiles directory
cd "$DOTFILES_DIR"

# Verify stow is installed
if ! command -v stow &> /dev/null; then
    echo "Error: GNU Stow is not installed."
    echo "Install it via your package manager (e.g., 'sudo apt install stow' or 'pacman -S stow')."
    exit 1
fi

# Loop through each package and stow it
for pkg in "${CONFIG_PACKAGES[@]}"; do
    if [ -d "$pkg" ]; then
        echo "Stowing package: $pkg..."
        # -R : Restow (removes old links first, great for updates)
        # -t : Target directory
        stow -R -t "$TARGET_DIR" "$pkg"
    else
        echo "Warning: Package directory '$pkg' not found, skipping."
    fi
done

echo "=========================================="
echo "Success! All configurations have been stowed."
echo "=========================================="