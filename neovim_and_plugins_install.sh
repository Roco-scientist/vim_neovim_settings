#!/bin/zsh

# A future-proofed script to set up a Neovim development environment on Ubuntu.
#
# This script is idempotent and uses modern best practices, including:
#   - lazy.nvim for plugin management (the current standard).
#   - Relies on mason.nvim (configured in your init.lua) for managing LSPs,
#     removing the need for manual installation of language servers.
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
# Color codes for output messages
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

info() { printf "${C_BLUE}[INFO]${C_RESET} %s\n" "$1"; }
success() { printf "${C_GREEN}[SUCCESS]${C_RESET} %s\n" "$1"; }
warn() { printf "${C_YELLOW}[WARNING]${C_RESET} %s\n" "$1"; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Determine the correct profile file
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

# --- Main Functions ---

install_system_dependencies() {
    info "Updating package lists and installing system dependencies..."
    sudo apt-get update
    
    local packages=(
        ninja-build make cmake gettext curl git xclip ruby-dev
        build-essential libssl-dev libtool-bin
        ripgrep fd-find clang-format clangd
        nodejs npm cpanminus
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
    
    # Create the user's local font directory if it doesn't exist
    mkdir -p "$font_dir"
    
    # Copy the font if it's not already there
    if [ ! -f "$font_dir/$FONT_NAME" ]; then
        cp "$SCRIPT_DIR/$FONT_NAME" "$font_dir/"
        info "Font copied to $font_dir."
        # Update the font cache for the user
        info "Updating user font cache..."
        fc-cache -f -v
    else
        info "Font is already installed in user's local directory. Skipping."
    fi
    success "Nerd Font is ready to be used."
}

setup_toolchains() {
    info "Setting up language toolchains and providers..."

    # --- Node.js ---
    info "Updating Node.js to the latest stable version using 'n'..."
    sudo npm cache clean -f
    sudo npm install -g n
    sudo n stable
    info "Installing global npm packages for Neovim provider..."
    sudo npm install -g neovim

    # --- Python ---
    info "Installing Python packages with pip..."
    pip3 install --user --upgrade pynvim black

    # --- Rust ---
    if ! command_exists rustup; then
        info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env" # Source for the current session
    fi
    info "Updating Rust and adding components..."
    rustup update
    rustup component add rustfmt clippy
    cargo install tree-sitter-cli

    # --- Neovim Providers (Ruby, Perl) ---
    info "Installing Ruby and Perl providers..."
    sudo gem install neovim
    sudo cpanm -n Neovim::Ext
    
    success "Toolchains and providers are set up."
}

remove_apt_neovim() {
    info "Checking for Neovim installation via apt..."
    # dpkg-query returns a non-zero exit code if the package is not found
    if dpkg-query -W -f='${Status}' neovim 2>/dev/null | grep -q "install ok installed"; then
        warn "Found an existing version of Neovim installed via apt. Removing it to avoid conflicts..."
        sudo apt-get remove --purge -y neovim
        success "Removed apt version of Neovim."
    else
        info "No apt version of Neovim found. Proceeding."
    fi
}

install_neovim_from_source() {
    info "Cloning and building the latest stable Neovim from source..."
    local neovim_src_dir="$HOME/neovim"
    # Clean up any old source directory to ensure a fresh clone
    if [ -d "$neovim_src_dir" ]; then
        rm -rf "$neovim_src_dir"
    fi
    
    git clone https://github.com/neovim/neovim "$neovim_src_dir"
    (
        cd "$neovim_src_dir"
        git checkout stable
        make CMAKE_BUILD_TYPE=Release
        sudo make install
    )
    rm -rf "$neovim_src_dir"
    success "Latest stable Neovim has been built and installed to /usr/local/bin/nvim."
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
        info "lazy.nvim is already installed. Skipping."
        return
    fi
    info "Installing lazy.nvim plugin manager..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$lazy_dir"
    success "lazy.nvim installed."
}

print_final_instructions() {
    printf "\n"
    success "Setup script finished!"
    printf "\n"
    info "--- ACTION REQUIRED ---"
    printf "${C_YELLOW}1. Restart your terminal or run 'source %s' to apply changes.${C_RESET}\n" "$PROFILE_FILE"
    info "2. Launch Neovim ('nvim'). lazy.nvim will automatically install your plugins on the first run."
    info "3. Change your terminal's font to 'RobotoMono Nerd Font' to see icons correctly."
    info "4. For a full health check, run :checkhealth inside Neovim."
    printf "\n"
}

# --- Main Execution ---
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
