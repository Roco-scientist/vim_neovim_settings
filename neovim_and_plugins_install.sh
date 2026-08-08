#!/bin/zsh

# A future-proofed script to set up a Neovim development environment on Ubuntu.
#
# This script is idempotent and uses modern best practices, including:
#   - lazy.nvim for plugin management (the current standard).
#   - Relies on mason.nvim (configured in your init.lua) for managing LSPs.
#   - Creates an isolated 'uv' venv for the Neovim Python provider.
#
# USAGE:
#   1. Place this script in the same directory as your 'init.lua' and font file.
#   2. Make it executable: chmod +x neovim_and_plugins_install.sh
#   3. Run it: ./neovim_and_plugins_install.sh

# --- Script Configuration ---
set -e # Exit immediately if a command exits with a non-zero status.
set -u # Treat unset variables as an error.
set -o pipefail # The return value of a pipeline is the status of the last command to exit.

# --- Variables and Environment Setup ---
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

info() { printf "${C_BLUE}[INFO]${C_RESET} %s\n" "$1"; }
success() { printf "${C_GREEN}[SUCCESS]${C_RESET} %s\n" "$1"; }
warn() { printf "${C_YELLOW}[WARNING]${C_RESET} %s\n" "$1"; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

if [ -n "$ZSH_VERSION" ]; then
    PROFILE_FILE=~/.zshrc
elif [ -n "$BASH_VERSION" ]; then
    PROFILE_FILE=~/.bashrc
else
    PROFILE_FILE=~/.profile
fi

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NVIM_CONFIG_DIR=~/.config/nvim
FONT_NAME="Roboto Mono Nerd Font Complete.ttf"
NVIM_VENV_DIR="$HOME/.local/share/nvim/venv"

# --- Main Functions ---

install_system_dependencies() {
    info "Updating package lists and installing system dependencies..."
    sudo apt-get update

    local packages=(
        ninja-build make cmake gettext curl git xclip ruby-dev
        build-essential libssl-dev libtool-bin
        ripgrep fd-find clang-format clangd
        nodejs npm cpanminus python3-pip
    )

    sudo apt-get install -y "${packages[@]}"
    success "System dependencies installed."
}

install_fonts() {
    info "Installing Nerd Font for the current user..."
    local font_dir="$HOME/.local/share/fonts"

    if [[ ! -f "$SCRIPT_DIR/$FONT_NAME" ]]; then
        warn "Font file '$FONT_NAME' not found in script directory. Skipping."
        return
    fi

    mkdir -p "$font_dir"

    if [ ! -f "$font_dir/$FONT_NAME" ]; then
        cp "$SCRIPT_DIR/$FONT_NAME" "$font_dir/"
        info "Font copied to $font_dir."
        fc-cache -f -v
    else
        info "Font is already installed. Skipping."
    fi
    success "Nerd Font is ready."
}

setup_toolchains() {
    info "Setting up language toolchains and providers..."

    # --- Node.js ---
    info "Updating Node.js and installing provider..."
    sudo npm install -g n
    sudo n stable
    sudo npm install -g neovim

    # --- Python (Isolated via uv) ---
    if ! command_exists uv; then
        info "uv not found. Installing uv..."
        curl -LsSf https://astral.sh/uv/install.sh | sh
        export PATH="$HOME/.cargo/bin:$PATH"
    fi

    info "Creating isolated Python venv for Neovim using uv..."
    # Ensure the parent directory exists
    mkdir -p "$(dirname "$NVIM_VENV_DIR")"
    
    # If the venv already exists, uv will just report it's ready
    uv venv "$NVIM_VENV_DIR"
    
    # CORRECTED: Use uv to install INTO the venv. 
    # We point uv to the venv directory using the --python flag.
    info "Installing pynvim and black into the isolated venv..."
    uv pip install --python "$NVIM_VENV_DIR" pynvim black
    
    # --- Rust ---
    if ! command_exists rustup; then
        info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    rustup update
    rustup component add rustfmt clippy
    cargo install tree-sitter-cli

    # --- Neovim Providers (Ruby, Perl) ---
    info "Installing Ruby and Perl providers..."
    sudo gem install neovim
    sudo cpanm -n Neovim::Ext

    success "Toolchains and providers (including isolated Python) are set up."
}

remove_apt_neovim() {
    info "Checking for Neovim installation via apt..."
    if dpkg-query -W -f='${Status}' neovim 2>/dev/null | grep -q "install ok installed"; then
        warn "Removing apt version of Neovim to avoid conflicts..."
        sudo apt-get remove --purge -y neovim
    fi
}

install_neovim_from_source() {
    info "Building the latest stable Neovim from source..."
    local neovim_src_dir="$HOME/neovim_src"
    if [ -d "$neovim_src_dir" ]; then rm -rf "$neovim_src_dir"; fi

    git clone https://github.com/neovim/neovim "$neovim_src_dir"
    (
        cd "$neovim_src_dir"
        git checkout stable
        make CMAKE_BUILD_TYPE=Release
        sudo make install
    )
    rm -rf "$neovim_src_dir"
    success "Neovim installed to /usr/local/bin/nvim."
}

setup_neovim_config() {
    info "Linking Neovim configuration files..."
    mkdir -p "$NVIM_CONFIG_DIR"
    ln -sf "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG_DIR/init.lua"
    success "Linked 'init.lua'."
}

install_lazy_nvim() {
    local lazy_dir="$HOME/.local/share/nvim/lazy/lazy.nvim"
    if [ -d "$lazy_dir" ]; then
        info "lazy.nvim already installed."
        return
    fi
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazy_dir"
}

print_final_instructions() {
    printf "\n"
    success "Setup script finished!"
    printf "\n"
    info "--- ACTION REQUIRED ---"
    info "1. Add the following line to your init.lua to use the new isolated Python venv:"
    printf "${C_GREEN}   vim.g.python3_host_prog = vim.fn.expand(\"~/.local/share/nvim/venv/bin/python3\")${C_RESET}\n"
    printf "\n"
    printf "${C_YELLOW}2. Restart your terminal or run 'source %s'.${C_RESET}\n" "$PROFILE_FILE"
    info "3. Launch Neovim ('nvim') and allow lazy.nvim to install plugins."
    info "4. Change terminal font to 'RobotoMono Nerd Font'."
    printf "\n"
}

main() {
    install_system_dependencies
    install_fonts
    setup_toolchains
    remove_apt_neovim
    install_neovim_from_source
    setup_neovim_config
    install_lazy_nvim
    print_final_instructions
}

main
