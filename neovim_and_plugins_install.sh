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
    PROFILE_FILE=~/.zprofile
elif [ -n "$BASH_VERSION" ]; then
    PROFILE_FILE=~/.bash_profile
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
        nodejs npm bash-language-server cpanminus
    )
    
    sudo apt-get install -y "${packages[@]}"
    success "System dependencies installed."
}

install_fonts() {
    info "Installing Nerd Font..."
    local font_dir="/usr/local/share/fonts"
    if [[ ! -f "$SCRIPT_DIR/$FONT_NAME" ]]; then
        warn "Font file '$FONT_NAME' not found in script directory. Skipping."
        return
    fi
    
    sudo mkdir -p "$font_dir"
    sudo cp "$SCRIPT_DIR/$FONT_NAME" "$font_dir/"
    
    info "Updating font cache..."
    sudo fc-cache -f -v
    success "Nerd Font installed."
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

install_neovim_from_source() {
    if command_exists nvim; then
        info "Neovim is already installed. Skipping build from source."
        return
    fi
    
    info "Cloning and building Neovim from source (stable branch)..."
    local neovim_src_dir="$HOME/neovim"
    git clone https://github.com/neovim/neovim "$neovim_src_dir"
    (
        cd "$neovim_src_dir"
        git checkout stable
        make CMAKE_BUILD_TYPE=Release
        sudo make install
    )
    rm -rf "$neovim_src_dir" # Clean up source directory
    success "Neovim installed successfully."
}

setup_neovim_config() {
    info "Linking Neovim configuration files..."
    mkdir -p "$NVIM_CONFIG_DIR"
    # Use -sf to force link creation, useful for re-running the script
    ln -sf "$SCRIPT_DIR/init.lua" "$NVIM_CONFIG_DIR/init.lua"
    ln -sf "$SCRIPT_DIR/lsp" "$NVIM_CONFIG_DIR/lsp"
    success "Configuration files linked."
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
    info "3. Once plugins are installed, run the following commands inside Neovim:"
    printf "   - ${C_GREEN}:MasonInstallAll${C_RESET} (to install all configured LSPs, formatters, etc.)\n"
    printf "   - ${C_GREEN}:TSInstallSync${C_RESET} (to install all configured Tree-sitter parsers)\n"
    info "4. Change your terminal's font to 'RobotoMono Nerd Font' to see icons correctly."
    info "5. For a full health check, run ${C_GREEN}:checkhealth${C_RESET} inside Neovim."
    printf "\n"
}

# --- Main Execution ---
main() {
    install_system_dependencies
    install_fonts
    setup_toolchains
    install_neovim_from_source
    setup_neovim_config
    install_lazy_nvim
    print_final_instructions
}

main
