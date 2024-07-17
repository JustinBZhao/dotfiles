#!/usr/bin/env bash
#
# Set up most of the packages and plugins
set -euo pipefail

command_exists() {
    # Can give multiple commands, will fail if any command is not found
    command -v "$@" >/dev/null 2>&1
}

# OS must be Ubuntu
os_name=$(grep "^NAME=" /etc/os-release | cut -d '=' -f2 | tr -d '"' | cut -d ' ' -f1)
case "$os_name" in
    Ubuntu)
        echo "This is Ubuntu!"
        package_manager_cmd="sudo apt install -y" ;;
    Fedora)
        echo "This is Fedora!"
        echo "Limited support for now!"
        package_manager_cmd="sudo dnf install -y" ;;
    *)
        echo "Unsupported Linux distribution!"
        exit 1 ;;
esac
# Check bash version, should >=4.2, otherwise abort
if (( BASH_VERSINFO[0] < 4 )); then
    echo "Bash version too low! Must be at least 4.2!"
    exit 1
fi
if (( BASH_VERSINFO[0] == 4 )) && (( BASH_VERSINFO[1] < 2 )); then
    echo "Bash version too low! Must be at least 4.2!"
    exit 1
fi
# Reject execution if run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script cannot be run as root! Abort."
    exit 1
fi

install_package() {
    package=$1
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        echo "Installing $package..."
        "${package_manager_cmd} ${package}" || { echo "Failed to install $package"; exit 1; }
    fi
}

PACKAGES=(
    bat
    build-essential
    clang
    clangd
    clang-tidy
    cmake
    cppcheck
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
    ninja-build
    nodejs
    npm
    python-is-python3
    python3-matplotlib
    python3-notebook
    python3-numpy
    python3-pandas
    python3-pytest
    shellcheck
    snapd
    tldr
    unzip
    valgrind
    vim-gtk3
    zip
    zsh
)

ubuntu_2404_packages=(
    git-delta
)

fulldistro_only_packages=(
    tlp
)

FEDORA_PACKAGES=(
    bat

    gcc
    gcc-c++
    gdb
    make
)

# Installation command
sudo apt update || { echo "Failed to update package lists!"; exit 1; }
sudo apt upgrade || { echo "Failed to upgrade packages!"; exit 1; }
# First check if this is a WSL installation
# Only install specific packages on full Ubuntu distribution
echo "------------------------------------"
if [ -v WSL_DISTRO_NAME ]; then
    echo "This is a WSL installation. Skipping some packages."
else
    echo "This is a full installation. Install specific packages."
    for package in "${fulldistro_only_packages[@]}"; do
        install_package "$package"
    done
fi
echo "------------------------------------"
# Then install general packages
echo "Installing general packages..."
# for package in "${PACKAGES[@]}"; do
#     install_package "$package"
# done
for package in "${FEDORA_PACKAGES[@]}"; do # for fedora distributions
    install_package "$package"
done
echo "Package installation complete!"
echo "------------------------------------"
# Then install Ubuntu 24.04 specific packages
os_version=$(grep "^VERSION_ID=" /etc/os-release | cut -d '=' -f2 | tr -d '"')
if [ "$os_version" == "24.04" ]; then
    echo "Install Ubuntu 24.04 specific packages..."
    for package in "${ubuntu_2404_packages[@]}"; do
        install_package "$package"
    done
else
    echo "This is an older Ubuntu version: ${os_version}. Skip installing version specific packages."
fi
echo "------------------------------------"

# Install Oh my Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export RUNZSH=no # prevent running zsh after installation
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    # Change default shell to zsh
    if command_exists chsh; then
        chsh -s "$(which zsh)" || { echo "Failed to change the default shell to zsh."; exit 1; } # it looks like setting default shell might not always succeed
    else
        echo "chsh command not found, cannot change default shell to zsh!"
    fi
    echo "------------------------------------"
fi

# Install zsh-syntax-highlighting
zsh_highlight_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ ! -d "$zsh_highlight_dir" ]; then
    echo "Installing zsh syntax highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$zsh_highlight_dir"
    echo "zsh syntax highlighting installed!"
    echo "------------------------------------"
fi

# Install vim-plug
vim_plug_dir="$HOME/.vim/autoload/plug.vim"
if [ ! -f "$vim_plug_dir" ]; then
    echo "Installing vim-plug..."
    curl -fLo "$vim_plug_dir" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "vim-plug installation finished!"
    vim -c "PlugInstall" -c "qa" # execute 'PlugInstall' in Vim
else
    vim -c "PlugInstall" -c "qa" # install plugins
    echo "Plugins updated successfully!"
fi
echo "------------------------------------"

# Create symlink for "bat"
if [ -f "/usr/bin/batcat" ] && [ ! -f "$HOME/.local/bin/bat" ]; then
    mkdir -p "$HOME/.local/bin"
    ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
fi
