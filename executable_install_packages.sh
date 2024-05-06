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
    unzip
    vim
    zip
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
echo "Package installation complete!"
