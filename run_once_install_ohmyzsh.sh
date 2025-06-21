#!/bin/bash

set -euo pipefail

# Source shared utilities
if [[ -z "${CHEZMOI_WORKING_TREE}" ]]; then
    echo "Error, \$CHEZMOI_WORKING_TREE must be set. Please only run this script via chezmoi"
    exit 1
fi
source "${CHEZMOI_WORKING_TREE}/lib/shell-utils.sh"

# Setup error handling
setup_simple_error_trap

# Configuration
readonly OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"
readonly OH_MY_ZSH_INSTALL_URL="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh"
readonly ZSHRC_PATH="$HOME/.zshrc"

# Check prerequisites (using shared function)
check_ohmyzsh_prerequisites() {
    check_prerequisites "curl" "zsh"

    # Check if zsh is available and show version
    local zsh_version
    zsh_version=$(zsh --version 2>/dev/null | head -n1 || echo "unknown")
    log_info "Zsh version: $zsh_version"
}

# Check if Oh My Zsh is already installed
check_existing_installation() {
    if [[ -d "$OH_MY_ZSH_DIR" ]]; then
        log_info "📁 Oh My Zsh directory found at $OH_MY_ZSH_DIR"

        # Check if it looks like a valid installation
        if [[ -f "$OH_MY_ZSH_DIR/oh-my-zsh.sh" ]]; then
            local version_info=""
            if [[ -f "$OH_MY_ZSH_DIR/.git/refs/heads/master" ]]; then
                version_info=" ($(cd "$OH_MY_ZSH_DIR" && git rev-parse --short HEAD 2>/dev/null || echo "unknown"))"
            fi
            log_success "Valid Oh My Zsh installation detected$version_info"
            return 0
        else
            log_warning "Directory exists but doesn't appear to be a valid Oh My Zsh installation"
            return 1
        fi
    fi

    log_info "📭 Oh My Zsh not found, installation needed"
    return 1
}

# Backup existing .zshrc if it exists
backup_zshrc() {
    if [[ -f "$ZSHRC_PATH" ]] && [[ ! -f "$ZSHRC_PATH.backup" ]]; then
        log_info "💾 Backing up existing .zshrc"

        if cp "$ZSHRC_PATH" "$ZSHRC_PATH.backup"; then
            log_success "Backup created: $ZSHRC_PATH.backup"
            return 0
        else
            log_error "Failed to backup .zshrc"
            return 1
        fi
    elif [[ -f "$ZSHRC_PATH.backup" ]]; then
        log_info "📁 .zshrc backup already exists, skipping"
    fi

    return 0
}

# Download and install Oh My Zsh
install_oh_my_zsh() {
    log_info "📥 Downloading and installing Oh My Zsh..."

    local start_time
    start_time=$(date +%s)

    # Download and execute the installation script
    if sh -c "$(curl -fsSL "$OH_MY_ZSH_INSTALL_URL")" "" --unattended --keep-zshrc --skip-chsh; then
        local end_time
        end_time=$(date +%s)
        local duration=$((end_time - start_time))

        log_success "Oh My Zsh installed successfully in ${duration}s"
        return 0
    else
        log_error "Failed to install Oh My Zsh"
        return 1
    fi
}

# Verify installation
verify_installation() {
    log_info "🔍 Verifying Oh My Zsh installation..."

    if [[ ! -d "$OH_MY_ZSH_DIR" ]]; then
        log_error "Oh My Zsh directory not found after installation"
        return 1
    fi

    if [[ ! -f "$OH_MY_ZSH_DIR/oh-my-zsh.sh" ]]; then
        log_error "Oh My Zsh main script not found"
        return 1
    fi

    # Check for some common directories
    local expected_dirs=("themes" "plugins" "lib")
    for dir in "${expected_dirs[@]}"; do
        if [[ ! -d "$OH_MY_ZSH_DIR/$dir" ]]; then
            log_warning "Expected directory '$dir' not found"
        fi
    done

    log_success "Oh My Zsh installation verified"
    return 0
}

# Show installation status
show_installation_status() {
    log_info "📊 Installation status:"

    if [[ -d "$OH_MY_ZSH_DIR" ]]; then
        echo "  ✅ Oh My Zsh: Installed"

        # Show theme count
        local theme_count=0
        if [[ -d "$OH_MY_ZSH_DIR/themes" ]]; then
            theme_count=$(find "$OH_MY_ZSH_DIR/themes" -name "*.zsh-theme" | wc -l | tr -d ' ')
            echo "  🎨 Themes available: $theme_count"
        fi

        # Show plugin count
        local plugin_count=0
        if [[ -d "$OH_MY_ZSH_DIR/plugins" ]]; then
            plugin_count=$(find "$OH_MY_ZSH_DIR/plugins" -maxdepth 1 -type d | tail -n +2 | wc -l | tr -d ' ')
            echo "  🔌 Plugins available: $plugin_count"
        fi

        # Show version info if available
        if [[ -d "$OH_MY_ZSH_DIR/.git" ]]; then
            local commit_hash
            commit_hash=$(cd "$OH_MY_ZSH_DIR" && git rev-parse --short HEAD 2>/dev/null || echo "unknown")
            echo "  📦 Version: $commit_hash"
        fi
    else
        echo "  ❌ Oh My Zsh: Not installed"
    fi

    if [[ -f "$ZSHRC_PATH" ]]; then
        echo "  ✅ .zshrc: Present"
    else
        echo "  ❌ .zshrc: Missing"
    fi

    if [[ -f "$ZSHRC_PATH.backup" ]]; then
        echo "  💾 .zshrc backup: Available"
    fi

    echo
}

# Main execution
main() {
    echo
    log_info "🐚 Oh My Zsh Installation Manager"
    echo

    local failures=0

    # Check prerequisites
    if ! check_ohmyzsh_prerequisites; then
        ((failures++))
        return 1
    fi

    # Check if already installed
    if check_existing_installation; then
        log_success "🎉 Oh My Zsh is already installed and ready to use!"
    else
        # Backup existing .zshrc
        if ! backup_zshrc; then
            log_warning "Failed to backup .zshrc, continuing anyway"
        fi

        # Install Oh My Zsh
        if ! install_oh_my_zsh; then
            ((failures++))
        else
            # Verify installation
            if ! verify_installation; then
                ((failures++))
            fi
        fi
    fi

    # Show installation status
    show_installation_status

    # Summary
    show_summary $failures \
        "Oh My Zsh setup completed successfully!" \
        "Oh My Zsh setup completed with failures"

    show_tips \
        "Oh My Zsh directory: $OH_MY_ZSH_DIR" \
        "Configuration file: $ZSHRC_PATH" \
        "Browse themes: ls $OH_MY_ZSH_DIR/themes/" \
        "Browse plugins: ls $OH_MY_ZSH_DIR/plugins/" \
        "Update Oh My Zsh: omz update" \
        "Restart your shell or run 'exec zsh' to reload"

    # Exit with error code if any critical operations failed
    if [[ $failures -gt 0 ]]; then
        exit 1
    fi
}

# Run main function
main "$@"