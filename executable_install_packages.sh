#!/usr/bin/env bash
#
# Set up most of the packages and plugins

# Reject execution if run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script cannot be run as root! Abort."
    exit 1
fi

PACKAGES=(
    build-essential
    curl
    dash
    diffutils
    findutils
    gdb
    gh
    git
    grep
    gzip
    hostname
    init
    python-is-python3
    python3-matplotlib
    python3-notebook
    python3-numpy
    python3-pandas
    python3-pytest
    snapd
    tldr
    unzip
    vim
    zip
    zsh
)

UBUNTU_ONLY_PACKAGES=(
    tlp
)

# Installation command
sudo apt update && sudo apt upgrade || { echo "Failed to update package lists!"; exit 1; }
# First check if this is a WSL installation
# Only install specific packages on full Ubuntu distribution
echo "------------------------------------"
if [ -n "$WSL_DISTRO_NAME" ]; then
    echo "This is a WSL installation. Skipping some packages."
else
    echo "This is a full installation. Install specific packages."
    sudo apt install "${UBUNTU_ONLY_PACKAGES[@]}"
fi
echo "------------------------------------"
# Then install general packages
echo "Installing general packages..."
sudo apt install "${PACKAGES[@]}"
# Change default shell to zsh
if command -v chsh >/dev/null 2>&1; then
    chsh -s $(which zsh) || { echo "Failed to change the default shell to zsh."; exit 1; } # it looks like setting default shell might not always succeed
else
    echo "chsh command not found, cannot change default shell to zsh!"
fi
echo "Package installation complete!"

# Install Oh my Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "------------------------------------------------"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    echo "------------------------------------------------"
fi

# Install zsh-syntax-highlighting
ZSH_HIGHLIGHT_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$ZSH_HIGHLIGHT_DIR" ]; then
    echo "Installing zsh syntax highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_HIGHLIGHT_DIR"
    echo "zsh syntax highlighting installed!"
fi

# Install vim-plug
vim_plug_dir="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$vim_plug_dir" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$vim_plug_dir" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installation finished!"
    vim -c "PlugInstall" -c "qa" # execute 'PlugInstall' in Vim
fi
