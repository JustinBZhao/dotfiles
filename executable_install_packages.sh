#!/bin/bash
#
# List of manually installed packages to be synchronized

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
sudo apt update
# First check if this is a WSL installation
# Only install specific packages on full Ubuntu distribution
echo "------------------------------------"
if [ -n "$WSL_DISTRO_NAME" ]; then
    echo "This is a WSL installation. Skipping some packages."
else
    echo "This is a full installation. Install specific packages."
    sudo apt install ${UBUNTU_ONLY_PACKAGES[@]}
fi
echo "------------------------------------"
# Then install general packages
echo "Installing general packages..."
sudo apt install ${PACKAGES[@]}
chsh -s $(which zsh) # it looks like setting default shell might not always succeed
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
if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
    echo "Installing vim-plug..."
    curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installation finished!"
    vim -c "PlugInstall" -c "qa" # execute 'PlugInstall' in Vim
fi
