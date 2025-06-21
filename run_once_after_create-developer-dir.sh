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
readonly DEVELOPER_DIR="$HOME/Developer"
readonly REPOSITORIES=(
    "gperdomor/nx-tools"
)

# Check if required tools are available (using shared function)
check_developer_prerequisites() {
    check_prerequisites "gh" "git"
}

# Create developer directory
create_developer_directory() {
    log_info "📁 Creating Developer directory at $DEVELOPER_DIR..."

    if mkdir -p "$DEVELOPER_DIR"; then
        log_success "Developer directory created successfully"
        return 0
    else
        log_error "Failed to create Developer directory"
        return 1
    fi
}

# Clone a repository if it doesn't exist
clone_repository() {
    local repo="$1"
    local repo_name
    repo_name=$(basename "$repo")
    local target_dir="$DEVELOPER_DIR/$repo_name"

    if [[ -d "$target_dir" ]]; then
        log_info "📁 Repository '$repo_name' already exists, skipping clone"
        return 0
    fi

    log_info "📥 Cloning repository '$repo'..."

    if (cd "$DEVELOPER_DIR" && gh repo clone "$repo"); then
        log_success "Repository '$repo_name' cloned successfully"
        return 0
    else
        log_error "Failed to clone repository '$repo'"
        return 1
    fi
}

# Main execution
main() {
    echo
    log_info "🏗️  Setting up Developer environment..."
    echo

    local failures=0

    # Check prerequisites
    if ! check_developer_prerequisites; then
        ((failures++))
        return 1
    fi

    # Create developer directory
    if ! create_developer_directory; then
        ((failures++))
    fi

    # Clone repositories
    for repo in "${REPOSITORIES[@]}"; do
        if ! clone_repository "$repo"; then
            ((failures++))
        fi
    done

    # Summary
    show_summary $failures \
        "Developer environment setup completed successfully!" \
        "Developer environment setup completed with failures"

    echo
    log_info "� Developer directory status:"
    for repo in "${REPOSITORIES[@]}"; do
        local repo_name
        repo_name=$(basename "$repo")
        local target_dir="$DEVELOPER_DIR/$repo_name"

        if [[ -d "$target_dir" ]]; then
            echo "  ✅ $repo_name: Available"
        else
            echo "  ❌ $repo_name: Not available"
        fi
    done

    show_tips \
        "Developer directory: $DEVELOPER_DIR" \
        "Use 'cd \$HOME/Developer' to navigate to the directory" \
        "Add more repositories to the REPOSITORIES array if needed"

    # Exit with error code if any operations failed
    if [[ $failures -gt 0 ]]; then
        exit 1
    fi
}

# Run main function
main "$@"