#!/bin/bash

# A script to install a modern version of Python in the user's home directory
# without requiring sudo, using the 'pyenv' version manager.

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

# Specify the Python version
PYTHON_VERSION="3.14"

current_shell=$(basename "$SHELL")
PROFILE_FILE=""

case "$current_shell" in
    zsh)
        PROFILE_FILE=~/.zshrc
        ;;
    bash)
        PROFILE_FILE=~/.bashrc
        ;;
    *)
        # Fallback for other shells like sh, dash, etc.
        warn "Could not detect zsh or bash as the default shell. Falling back to ~/.profile."
        PROFILE_FILE=~/.profile
        ;;
esac

info "Detected shell: $current_shell. Using profile file: $PROFILE_FILE"

# --- Main Functions ---

check_build_dependencies() {
    info "Checking for Python build dependencies..."
    # These are required by pyenv to compile Python from source.
    local dependencies=(
        build-essential libssl-dev zlib1g-dev libbz2-dev
        libreadline-dev libsqlite3-dev curl libncurses-dev
        xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
    )
    
    local missing_deps=()
    for dep in "${dependencies[@]}"; do
        if ! dpkg -s "$dep" >/dev/null 2>&1; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        warn "Build dependencies are missing. You may need sudo access to install them."
        printf "${C_YELLOW}Please run the following command, or ask an administrator to run it for you:${C_RESET}\n"
        echo "sudo apt-get install -y ${missing_deps[*]}"
        exit 1
    else
        success "All build dependencies are present."
    fi
}

install_pyenv() {
    if [ -d "$HOME/.pyenv" ]; then
        info "pyenv is already installed. Updating..."
        (cd "$HOME/.pyenv" && git pull)
    else
        info "Installing pyenv..."
        curl https://pyenv.run | bash
    fi
}

configure_shell() {
    info "Configuring shell to load pyenv on login..."
    local pyenv_config=(
        'export PYENV_ROOT="$HOME/.pyenv"'
        'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
        'eval "$(pyenv init -)"'
    )

    # Ensure the profile file exists
    touch "$PROFILE_FILE"

    for line in "${pyenv_config[@]}"; do
        if ! grep -qF -- "$line" "$PROFILE_FILE"; then
            info "Adding to '$PROFILE_FILE': $line"
            echo "$line" >> "$PROFILE_FILE"
        else
            info "Already in '$PROFILE_FILE': $line"
        fi
    done
}

install_python() {
    # Load pyenv into the current script session to make it available
    export PYENV_ROOT="$HOME/.pyenv"
    command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
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
    info "Please restart your shell or run 'source %s' to apply changes."
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
    check_build_dependencies
    install_pyenv
    configure_shell
    install_python
    verify_installation
}

main
