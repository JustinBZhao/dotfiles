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

# Installation command
echo "Installing packages..."
sudo apt update
sudo apt install ${PACKAGES[@]}
echo "Package installation complete!"
