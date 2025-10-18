#!/bin/zsh

# A script to install a modern version of Python in the user's home directory
# on macOS without interfering with the system Python, using 'pyenv'.

# --- Script Configuration ---
set -e # Exit immediately if a command fails.
set -u # Treat unset variables as an error.

# --- Variables and Environment ---
# Color codes for output messages
C_RESET='\033[0m'
C_GREEN='\033[0;32m'
C_YELLOW='\033[0;33m'
C_BLUE='\033[0;34m'

info() { printf "${C_BLUE}[INFO]${C_RESET} %s\n" "$1"; }
success() { printf "${C_GREEN}[SUCCESS]${C_RESET} %s\n" "$1"; }
warn() { printf "${C_YELLOW}[WARNING]${C_RESET} %s\n" "$1"; }
command_exists() { command -v "$1" >/dev/null 2>&1; }

# Specify the Python version you want to install
PYTHON_VERSION="3.13"

# Zsh is the default on modern macOS
PROFILE_FILE=~/.zprofile

# --- Main Functions ---

check_xcode_tools() {
    info "Checking for Xcode Command Line Tools..."
    if ! xcode-select -p >/dev/null 2>&1; then
        warn "Xcode Command Line Tools not found. They are required to build Python."
        printf "${C_YELLOW}Please run the following command in your terminal and then re-run this script:${C_RESET}\n"
        echo "xcode-select --install"
        exit 1
    else
        success "Xcode Command Line Tools are installed."
    fi
}

install_homebrew() {
    if command_exists brew; then
        info "Homebrew is already installed. Updating..."
        brew update
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        # Add Homebrew to PATH for the current script session
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    fi
}

install_pyenv_and_deps() {
    info "Installing pyenv and its build dependencies via Homebrew..."
    local packages=(pyenv openssl readline sqlite3 xz zlib)
    local to_install=()
    for pkg in "${packages[@]}"; do
        if ! brew list "$pkg" >/dev/null 2>&1; then
            to_install+=("$pkg")
        fi
    done

    if [ ${#to_install[@]} -gt 0 ]; then
        brew install "${to_install[@]}"
    else
        info "pyenv and dependencies are already installed."
    fi
}

configure_shell() {
    info "Configuring shell to load pyenv on login..."
    # This is the standard configuration line for pyenv on macOS with Zsh
    local pyenv_init_line='eval "$(pyenv init -)"'

    touch "$PROFILE_FILE"

    if ! grep -qF -- "$pyenv_init_line" "$PROFILE_FILE"; then
        info "Adding pyenv configuration to '$PROFILE_FILE'."
        echo -e "\n# Initialize pyenv\n$pyenv_init_line" >> "$PROFILE_FILE"
    else
        info "pyenv configuration already exists in '$PROFILE_FILE'."
    fi
}

install_python() {
    # Load pyenv into the current script session to make it available
    eval "$(pyenv init -)"

    info "Checking installed Python versions..."
    if pyenv versions --bare | grep -q "^${PYTHON_VERSION}$"; then
        info "Python ${PYTHON_VERSION} is already installed. Skipping installation."
    else
        info "Installing Python ${PYTHON_VERSION}... (This will take several minutes)"
        pyenv install "$PYTHON_VERSION"
    fi
    
    info "Setting Python ${PYTHON_VERSION} as the global default for this user..."
    pyenv global "$PYTHON_VERSION"
    success "Python ${PYTHON_VERSION} is now the default."
}

verify_installation() {
    printf "\n"
    success "Python setup is complete!"
    info "Please restart your terminal or run 'source %s' to apply changes."
    info "After restarting, verify the installation with these commands:"
    printf "  ${C_YELLOW}python --version${C_RESET} (should output Python ${PYTHON_VERSION})\n"
    printf "  ${C_YELLOW}which python${C_RESET} (should point to a path inside ~/.pyenv)\n"
    printf "  ${C_YELLOW}pip --version${C_RESET} (should also point to the pyenv version)\n"
    printf "\n"
    info "You can now install packages like 'pynvim' without sudo:"
    printf "  ${C_YELLOW}pip install pynvim${C_RESET}\n"
}

# --- Main Execution ---
main() {
    check_xcode_tools
    install_homebrew
    install_pyenv_and_deps
    configure_shell
    install_python
    verify_installation
}

main
