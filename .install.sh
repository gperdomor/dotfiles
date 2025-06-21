#!/bin/bash

# filepath: /Users/gperdomor/.local/share/chezmoi/.install.sh

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if we're on macOS
check_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        log_error "This script is designed for macOS only"
        log_info "Current OS: $(uname -s)"
        exit 1
    fi
}

# Install Xcode Command Line Tools
install_xcode_tools() {
    log_info "Checking Xcode Command Line Tools..."

    # Check if Xcode Command Line Tools are already installed
    if xcode-select -p >/dev/null 2>&1; then
        local xcode_path
        xcode_path=$(xcode-select -p)
        log_success "Xcode Command Line Tools are already installed at: $xcode_path"
        return 0
    fi

    log_info "Installing Xcode Command Line Tools..."
    log_warning "This may take a while and will require user interaction..."
    echo

    # Install Xcode Command Line Tools
    if xcode-select --install 2>/dev/null; then
        log_info "Xcode Command Line Tools installation initiated"
        echo
        echo "Please complete the installation in the popup dialog that appeared."
        echo "The installation may take several minutes depending on your internet connection."
        echo

        # Wait for installation to complete
        log_info "Waiting for Xcode Command Line Tools installation to complete..."

        # Check every 10 seconds if installation is complete
        local max_attempts=270  # 45 minutes maximum
        local attempt=0

        while ! xcode-select -p >/dev/null 2>&1; do
            if [[ $attempt -ge $max_attempts ]]; then
                log_error "Xcode Command Line Tools installation timed out"
                log_info "Please install manually and run this script again"
                exit 1
            fi

            echo -n "."
            sleep 10
            ((attempt++))
        done

        echo
        log_success "Xcode Command Line Tools installed successfully!"

        # Accept the license if needed
        if ! sudo xcodebuild -license accept 2>/dev/null; then
            log_warning "Could not automatically accept Xcode license"
            log_info "You may need to run 'sudo xcodebuild -license accept' manually"
        fi

    else
        # Handle the case where installation dialog is already open or other issues
        local exit_code=$?
        if [[ $exit_code -eq 1 ]]; then
            log_warning "Xcode Command Line Tools installation dialog may already be open"
            log_info "Please complete the installation and press Enter to continue..."
            read -r

            # Check again if tools are now installed
            if xcode-select -p >/dev/null 2>&1; then
                log_success "Xcode Command Line Tools are now installed!"
            else
                log_error "Xcode Command Line Tools installation failed"
                log_info "Please install manually using: xcode-select --install"
                exit 1
            fi
        else
            log_error "Failed to initiate Xcode Command Line Tools installation"
            exit 1
        fi
    fi
}

# Install Homebrew if not present
install_homebrew() {
    if command_exists brew; then
        log_success "Homebrew is already installed"
        return 0
    fi

    log_info "Installing Homebrew..."
    if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        log_success "Homebrew installed successfully"

        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    else
        log_error "Failed to install Homebrew"
        exit 1
    fi
}

# Install 1Password desktop app
install_1password_app() {
    if [[ -d "/Applications/1Password.app" ]]; then
        log_success "1Password app is already installed"
        return 0
    fi

    log_info "Installing 1Password desktop app..."
    if brew install --cask 1password; then
        log_success "1Password app installed successfully"
    else
        log_error "Failed to install 1Password app"
        exit 1
    fi
}

# Install 1Password CLI
install_1password_cli() {
    if command_exists op; then
        local version
        version=$(op --version 2>/dev/null || echo "unknown")
        log_success "1Password CLI is already installed (version: $version)"
        return 0
    fi

    log_info "Installing 1Password CLI..."
    if brew install 1password-cli; then
        log_success "1Password CLI installed successfully"
    else
        log_error "Failed to install 1Password CLI"
        exit 1
    fi
}

# Check 1Password CLI integration
check_1password_integration() {
    log_info "Checking 1Password CLI integration..."

    if ! command_exists op; then
        log_error "1Password CLI not found after installation"
        return 1
    fi

    # Test if we can access 1Password
    if op account list >/dev/null 2>&1; then
        log_success "1Password CLI integration is working"
        return 0
    else
        log_warning "1Password CLI integration may not be properly configured"
        return 1
    fi
}

# Interactive setup guidance
guide_1password_setup() {
    echo
    log_info "Setting up 1Password integration..."
    echo
    echo "Please complete the following steps:"
    echo "  1. Open 1Password desktop app"
    echo "  2. Sign in to all your accounts"
    echo "  3. Go to Settings → Developer"
    echo "  4. Enable 'Integrate with 1Password CLI'"
    echo "  5. Enable 'Use the SSH Agent'"
    echo

    # Wait for user confirmation with proper input handling
    if [[ -t 0 ]]; then
        # Interactive terminal
        read -p "Press Enter when you've completed the setup above..." -r < /dev/tty
    else
        # Non-interactive (e.g., curl | bash)
        echo "Press Enter when you've completed the setup above..."
        read -r < /dev/tty || {
            log_warning "Unable to wait for user input in non-interactive mode"
            log_info "Continuing with 1Password integration test..."
            sleep 3
        }
    fi
    echo

    # Test the integration
    log_info "Testing 1Password CLI integration..."
    if op account list >/dev/null 2>&1; then
        log_success "1Password CLI integration is working correctly!"

        # Show available accounts
        echo
        log_info "Available 1Password accounts:"
        op account list --format=table 2>/dev/null || echo "  (Unable to list accounts - this is normal for some configurations)"
    else
        log_warning "1Password CLI integration test failed"
        echo
        echo "Troubleshooting tips:"
        echo "  • Make sure 1Password desktop app is running"
        echo "  • Verify CLI integration is enabled in Settings → Developer"
        echo "  • Try restarting the 1Password app"
        echo "  • Check that you're signed in to at least one account"
        echo

        if [[ -t 0 ]]; then
            # Interactive terminal
            read -p "Would you like to try the test again? (y/N): " -r < /dev/tty
            if [[ $REPLY =~ ^[Yy]$ ]]; then
                check_1password_integration
            fi
        else
            # Non-interactive mode
            log_info "Running in non-interactive mode, skipping retry prompt"
            log_info "You can run 'op account list' manually to test integration later"
        fi
    fi
}

# Install additional useful tools
install_additional_tools() {
    local tools=(
        "chezmoi"
        "git"
    )

    log_info "Installing additional development tools..."

    for tool in "${tools[@]}"; do
        if command_exists "$tool"; then
            log_success "$tool is already installed"
        else
            log_info "Installing $tool..."
            if brew install "$tool"; then
                log_success "$tool installed successfully"
            else
                log_warning "Failed to install $tool (continuing anyway)"
            fi
        fi
    done
}

# Update Homebrew and cleanup
update_homebrew() {
    log_info "Updating Homebrew and cleaning up..."

    if brew update && brew upgrade && brew cleanup; then
        log_success "Homebrew updated and cleaned up"
    else
        log_warning "Homebrew update/cleanup had some issues (continuing anyway)"
    fi
}

# Initialize dotfiles with chezmoi
initialize_dotfiles() {
    echo
    log_info "Initializing dotfiles with chezmoi..."

    if [[ -d "$HOME/.local/share/chezmoi" ]]; then
        log_warning "Chezmoi directory already exists"
        
        if [[ -t 0 ]]; then
            # Interactive terminal
            read -p "Do you want to reinitialize? This will backup existing config. (y/N): " -r < /dev/tty
        else
            # Non-interactive mode
            echo "Do you want to reinitialize? This will backup existing config. (y/N):"
            read -r < /dev/tty || {
                log_info "Running in non-interactive mode, skipping reinitialization"
                return 0
            }
        fi
        
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            # Backup existing chezmoi directory
            local backup_dir="$HOME/.local/share/chezmoi.backup.$(date +%Y%m%d_%H%M%S)"
            mv "$HOME/.local/share/chezmoi" "$backup_dir"
            log_info "Existing chezmoi directory backed up to: $backup_dir"
        else
            log_info "Skipping chezmoi initialization"
            return 0
        fi
    fi

    log_info "Initializing chezmoi with dotfiles repository..."
    if chezmoi init --apply gperdomor/dotfiles; then
        log_success "Dotfiles initialized and applied successfully!"
    else
        log_error "Failed to initialize dotfiles"
        log_info "You can manually run: chezmoi init --apply gperdomor/dotfiles"
        return 1
    fi
}

# Main execution
main() {
    echo
    log_info "🏠 Starting automated macOS dotfiles setup"
    echo

    # Check environment
    check_macos

    # Install system prerequisites
    install_xcode_tools
    install_homebrew

    # Install applications and tools
    install_1password_app
    install_1password_cli
    install_additional_tools

    # Update system
    update_homebrew

    # Setup 1Password integration
    guide_1password_setup

    # Initialize dotfiles
    initialize_dotfiles

    echo
    log_success "🎉 Dotfiles setup completed successfully!"
    echo
    log_info "What was installed:"
    echo "  ✅ Xcode Command Line Tools"
    echo "  ✅ Homebrew package manager"
    echo "  ✅ 1Password app and CLI"
    echo "  ✅ Git version control"
    echo "  ✅ Chezmoi dotfiles manager"
    echo "  ✅ All configs was applied from the repository gperdomor/dotfiles"
    echo
    log_info "Next steps:"
    echo "  • Open a new terminal to load your new shell configuration"
    echo "  • Run 'chezmoi apply' to apply any future dotfiles changes"
    echo "  • Customize your setup by editing files in ~/.local/share/chezmoi"
    echo
}

# Trap errors and cleanup
trap 'log_error "Script failed on line $LINENO"' ERR

# Run main function
main "$@"