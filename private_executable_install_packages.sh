#!/usr/bin/env bash
#
# Set up most of the packages and plugins
set -euo pipefail

command_exists() {
    # Can give multiple commands, will fail if any command is not found
    local cmd
    for cmd in "$@"; do
        command -v "$cmd" >/dev/null 2>&1 || return 1
    done
    return 0
}

detect_environment() {
    DETECT_KIND="unknown"
    DETECT_DISTRO="unknown"
    DETECT_FAMILY="unknown"
    DETECT_VERSION="unknown"
    DETECT_HOST="unknown"

    if [[ "${PREFIX:-}" == "/data/data/com.termux/files/usr" ]] || [[ -n "${TERMUX_VERSION:-}" ]]; then
        DETECT_KIND="android"
        DETECT_DISTRO="termux"
        DETECT_FAMILY="android"
        DETECT_VERSION="${TERMUX_VERSION:-unknown}"
        DETECT_HOST="android"

        echo "This is Android!"
        return 0
    fi

    local os_release

    if [[ -r /etc/os-release ]]; then
        os_release="/etc/os-release"
    elif [[ -r /usr/lib/os-release ]]; then
        os_release="/usr/lib/os-release"
    else
        return 1
    fi

    source "$os_release"

    DETECT_KIND="linux"
    DETECT_DISTRO="${ID:-unknown}"
    DETECT_VERSION="${VERSION_ID:-unknown}"
    DETECT_FAMILY="${ID_LIKE:-${ID:-unknown}}"

    # Check if it is a WSL distro
    if grep -qiE '(microsoft|wsl)' /proc/version; then
        DETECT_HOST="wsl"
    else
        DETECT_HOST="linux"
    fi
}

check_bash_version() {
    # Check bash version, should >=4.2, otherwise abort
    # This does not work on Android Termux. Therefore, skip for Android
    if [ "$DETECT_HOST" != "android" ]; then
        if (( BASH_VERSINFO[0] < 4 )); then
            echo "Bash version too low! Must be at least 4.2!"
            exit 1
        fi
        if (( BASH_VERSINFO[0] == 4 )) && (( BASH_VERSINFO[1] < 2 )); then
            echo "Bash version too low! Must be at least 4.2!"
            exit 1
        fi
    fi
}

install_package_ubuntu() {
    local package=$1
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        echo "Installing $package..."
        sudo apt install -y "$package" || { echo "Failed to install $package"; exit 1; }
    fi
}

install_package_fedora() {
    local package=$1
    if ! rpm -q "$package" >/dev/null 2>&1; then
        if ! dnf list --installed "$package" >/dev/null 2>&1; then
            echo "Installing $package..."
            sudo dnf install -y "$package" || { echo "Failed to install $package"; exit 1; }
        fi
    fi
}

install_package_android() {
    local package=$1
    if ! dpkg -s "$package" >/dev/null 2>&1; then
        echo "Installing $package..."
        apt install -y "$package" || { echo "Failed to install $package"; exit 1; }
    fi
}


detect_environment || {
    echo "Could not detect environment"
    exit 1
}

# Reject execution if run as root
if [ "$(id -u)" -eq 0 ]; then
    echo "This script cannot be run as root! Abort."
    exit 1
fi

echo "Environment information:"
echo "kind=$DETECT_KIND distro=$DETECT_DISTRO family=$DETECT_FAMILY version=$DETECT_VERSION host=$DETECT_HOST"

check_bash_version


UBUNTU_PACKAGES=(
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
    neovim
    ninja-build
    nodejs
    npm
    python3
    python3-pip
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
    clang
    clang-tools-extra
    cmake
    cppcheck
    curl
    dash
    diffutils
    findutils
    gh
    git
    git-delta
    grep
    gzip
    hostname
    neovim
    ninja-build
    nodejs
    python3
    python3-pip
    python-unversioned-command
    python3-matplotlib
    python3-notebook
    python3-numpy
    python3-pandas
    python3-pytest
    shellcheck
    tldr
    unzip
    valgrind
    vim-enhanced
    zip
    zsh
    # build tools
    gcc
    gcc-c++
    gdb
    make
)

ANDROID_PACKAGES=(
    bat
    build-essential
    clang
    # clangd # no clangd
    # clang-tidy # no clang-tidy
    cmake
    cppcheck
    curl
    dash
    diffutils
    findutils
    gdb
    gh
    git
    git-delta # originally ubuntu_2404 only
    grep
    gzip
    # hostname # no hostname
    # init
    neovim
    ninja # ninja-build is not the right name
    nodejs
    # npm # included in "nodejs"
    python
    # python-is-python # no need, "python" command already works
    # Python packages: need to install through pip
    # python3-matplotlib
    # python3-notebook
    # python3-numpy
    # python3-pandas
    # python3-pytest

    # shellcheck # no shellcheck
    # snapd
    # tldr
    unzip
    # valgrind # unavailable in Andriod
    vim # regular version of vim is fine for now
    zip
    zsh
)

# Upgrade packages
case "$DETECT_DISTRO" in
    ubuntu)
        sudo apt update -y || { echo "Failed to update package lists!"; exit 1; }
        sudo apt upgrade -y || { echo "Failed to upgrade packages!"; exit 1; } ;;
    fedora)
        sudo dnf upgrade -y || { echo "Failed to upgrade packages!"; exit 1; } ;;
    termux)
        apt update -y || { echo "Failed to update package lists!"; exit 1; }
        apt upgrade -y || { echo "Failed to upgrade packages!"; exit 1; } ;;
    *)
        echo "Unsupported Linux distribution!"
        exit 1 ;;
esac

# Check if this is a WSL installation
# Only install specific packages on full Ubuntu distribution
echo "------------------------------------"
if [[ "$DETECT_HOST" == "wsl" ]]; then
    echo "This is a WSL installation. Skipping some packages."
else
    echo "This is a full installation. Install specific packages."
    for package in "${fulldistro_only_packages[@]}"; do
        case "$DETECT_DISTRO" in
            ubuntu)
                install_package_ubuntu "$package" ;;
            fedora)
                install_package_fedora "$package" ;;
        esac
    done
fi
echo "------------------------------------"

# Then install general packages
echo "Installing general packages for ${DETECT_DISTRO}..."
case "$DETECT_DISTRO" in
    ubuntu)
        for package in "${UBUNTU_PACKAGES[@]}"; do
            install_package_ubuntu "$package"
        done
        echo "------------------------------------"
        # Then install Ubuntu 24.04 specific packages
        if [ "$DETECT_VERSION" == "24.04" ]; then
            echo "Install Ubuntu 24.04 specific packages..."
            for package in "${ubuntu_2404_packages[@]}"; do
                install_package_ubuntu "$package"
            done
        else
            echo "This is an older Ubuntu version: ${DETECT_VERSION}. Skip installing version specific packages."
            fi ;;
    fedora)
        for package in "${FEDORA_PACKAGES[@]}"; do # for fedora distributions
            install_package_fedora "$package"
        done ;;
    termux)
        for package in "${ANDROID_PACKAGES[@]}"; do
            install_package_android "$package"
        done ;;
    *)
        echo "Unsupported Linux distribution!"
        exit 1 ;;
esac
echo "Package installation complete!"
echo "------------------------------------"

# Install Oh my Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    export RUNZSH=no # prevent running zsh after installation
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --keep-zshrc
    # Change default shell to zsh
    if command_exists chsh; then
        chsh -s "$(command -v zsh)" || { echo "Failed to change the default shell to zsh."; exit 1; } # it looks like setting default shell might not always succeed
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
# Not needed for Android Termux
if [ "$DETECT_DISTRO" != "termux" ]; then
    if [ -f "/usr/bin/batcat" ] && [ ! -f "$HOME/.local/bin/bat" ]; then
        mkdir -p "$HOME/.local/bin"
        ln -s /usr/bin/batcat "$HOME/.local/bin/bat"
    fi
fi

# NeoVim setup (with NvChad)
echo "NeoVim: Install Lazy packages and Mason language servers..."
if ! lazy_output=$(nvim --headless +'lua require("lazy").sync({ show = false, wait = true })' +qa 2>&1); then
    echo "NeoVim Lazy update failed; see output:"
    echo "$lazy_output"
    exit 1
else
    echo "NeoVim Lazy update finished without problems!"
fi
# Install language servers with Mason if not installed
nvim --headless +'lua
local ok_lazy, lazy = pcall(require, "lazy")
assert(ok_lazy, "lazy.nvim is not available")
lazy.load({ plugins = { "mason.nvim" }})
local registry = require("mason-registry")

registry.refresh()

local wanted = {
"clangd",
"cmake-language-server",
"pyright",
"json-lsp",
"bash-language-server",
"shellcheck",
}

local pending = 0
local failed = false

local function maybe_exit()
    if pending == 0 then
        vim.schedule(function()
            if failed then
                vim.cmd("cquit 1")
            else
                vim.cmd("qa")
            end
        end)
    end
end

local function log(msg)
    io.stdout:write(msg .. "\n")
    io.stdout:flush()
end

for _, name in ipairs(wanted) do
    if not registry.has_package(name) then
        log("Unknown Mason package: " .. name)
        failed = true
    elseif registry.is_installed(name) then
        log("Already installed: " .. name)
    else
        local pkg = registry.get_package(name)
        log("Installing " .. name)
        pending = pending + 1

        pkg:install({}, vim.schedule_wrap(function(success, result)
            if success then
                log("Installed " .. name)
            else
                failed = true
                log("Failed to install " .. name .. ": " .. tostring(result))
            end
            pending = pending - 1
            maybe_exit()
        end))
    end
end

maybe_exit()
'
# Fix cmake-language-server bug (expects pygls < 2.0.0)
CMAKE_LSP_VENV="$HOME/.local/share/nvim/mason/packages/cmake-language-server/venv"
CMAKE_LSP_PY="$CMAKE_LSP_VENV/bin/python"
if "$CMAKE_LSP_PY" -c 'from importlib.metadata import version; import sys; sys.exit(0 if int(version("pygls").split(".",1)[0]) >= 2 else 1)'; then
    "$CMAKE_LSP_PY" -m pip install --upgrade --force-reinstall "pygls<2"
    echo "To fix cmake lsp in NeoVim, downgraded pygls to 1.x"
fi
# Install cmake linting
python -m pip install --user cmakelint
echo "Done"
