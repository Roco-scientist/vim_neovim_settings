#!/bin/zsh

# A future-proofed script to set up a Neovim development environment on macOS.
#
# This script is idempotent and uses modern best practices, including:
#   - lazy.nvim for plugin management (the current standard).
#   - Relies on mason.nvim (configured in your init.lua) for managing LSPs,
#     removing the need for manual installation of language servers.

# --- Script Configuration ---
set -e; set -u; set -o pipefail

# --- Variables and Environment Setup ---
C_RESET='\033[0m'; C_GREEN='\033[0;32m'; C_YELLOW='\033[0;33m'; C_BLUE='\033[0;34m'

info() { printf "${C_BLUE}[INFO]${C_RESET} %s\n" "$1"; }
success() { printf "${C_GREEN}[SUCCESS]${C_RESET} %s\n" "$1"; }
warn() { printf "${C_YELLOW}[WARNING]${C_RESET} %s\n" "$1"; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

append_to_shell_config() {
    local line="$1"; local config_file="$2"
    if ! grep -qF -- "$line" "$config_file"; then
        info "Adding to '$config_file': $line"
        echo "$line" >> "$config_file"
    else
        info "Already in '$config_file': $line"
    fi
}

PROFILE_FILE=~/.zprofile
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
NVIM_CONFIG_DIR=~/.config/nvim
FONT_NAME="Roboto Mono Nerd Font Complete.ttf"

# --- Main Functions ---

install_homebrew() {
    if command_exists brew; then
        info "Homebrew is installed. Updating..."
        brew update
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [[ "$(uname -m)" == "arm64" ]]; then eval "$(/opt/homebrew/bin/brew shellenv)"; else eval "$(/usr/local/bin/brew shellenv)"; fi
    fi
}

install_homebrew_packages() {
    info "Installing essential packages with Homebrew..."
    local packages=(neovim git ripgrep fd node llvm clang-format cpanminus)
    
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! brew list "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        info "Installing: ${to_install[*]}"
        brew install "${to_install[@]}"
    else
        info "All essential Homebrew packages are already installed."
    fi
    success "Homebrew packages are up to date."
}

install_fonts() {
    info "Installing Nerd Font..."
    local font_path="$HOME/Library/Fonts/$FONT_NAME"
    if [[ ! -f "$SCRIPT_DIR/$FONT_NAME" ]]; then
        warn "Font file '$FONT_NAME' not found in script directory. Skipping."
        return
    fi
    if [[ -f "$font_path" ]]; then
        info "Font '$FONT_NAME' is already installed. Skipping."
    else
        cp "$SCRIPT_DIR/$FONT_NAME" "$HOME/Library/Fonts/"
        success "Nerd Font copied to ~/Library/Fonts."
    fi
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

setup_toolchains() {
    info "Setting up language toolchains and providers..."

    # --- Python ---
    info "Installing Python packages..."
    pip3 install --user --upgrade pynvim black

    # --- C++ (LLVM) ---
    info "Configuring environment for LLVM..."
    append_to_shell_config "export PATH=\"$(brew --prefix)/opt/llvm/bin:\$PATH\"" "$PROFILE_FILE"

    # --- Rust ---
    if ! command_exists rustup; then
        info "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi
    info "Updating Rust and adding components..."
    rustup update
    rustup component add rustfmt clippy
    cargo install tree-sitter-cli

    # --- Neovim Providers (Node, Ruby, Perl) ---
    info "Installing Neovim providers..."
    npm install -g neovim
    sudo gem install neovim
    sudo cpanm -n Neovim::Ext
    
    success "Toolchains and providers are set up."
}

print_final_instructions() {
    printf "\n"
    success "Setup script finished!"
    printf "\n"
    info "--- ACTION REQUIRED ---"
    printf "${C_YELLOW}1. Restart your terminal or run 'source %s' to apply changes.${C_RESET}\n" "$PROFILE_FILE"
    info "2. Launch Neovim ('nvim'). lazy.nvim will automatically install your plugins."
    info "3. Once plugins are installed, run the following commands inside Neovim:"
    printf "   - ${C_GREEN}:MasonInstallAll${C_RESET} (to install all configured LSPs, formatters, etc. prettier, sqlfluff, jsonlint, sql-formatter)\n"
    printf "   - ${C_GREEN}:TSInstallSync${C_RESET} (to install all configured Tree-sitter parsers)\n"
    info "4. Open your terminal preferences and set the font to 'RobotoMono Nerd Font'."
    info "5. For a full health check, run :checkhealth inside Neovim."
    printf "\n"
}

# --- Main Execution ---
main() {
    install_homebrew
    install_homebrew_packages
    install_fonts
    setup_neovim_config
    install_lazy_nvim
    setup_toolchains
    print_final_instructions
}

main
