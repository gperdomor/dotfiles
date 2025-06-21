#!/bin/bash

set -euo pipefail

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

# Configuration
readonly DEVELOPER_DIR="$HOME/Developer"
readonly REPOSITORIES=(
    "gperdomor/nx-tools"
)

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

# Check if required tools are available
check_prerequisites() {
    local required_tools=("gh" "git")
    local missing_tools=()

    for tool in "${required_tools[@]}"; do
        if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
        fi
    done

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install the missing tools and try again"
        return 1
    fi

    return 0
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
    if ! check_prerequisites; then
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

    echo
    # Summary
    if [[ $failures -eq 0 ]]; then
        log_success "🎉 Developer environment setup completed successfully!"
    else
        log_warning "⚠️  Setup completed with $failures failure(s)"
    fi

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

    echo
    log_info "💡 Tips:"
    echo "  • Developer directory: $DEVELOPER_DIR"
    echo "  • Use 'cd \$HOME/Developer' to navigate to the directory"
    echo "  • Add more repositories to the REPOSITORIES array if needed"

    # Exit with error code if any operations failed
    if [[ $failures -gt 0 ]]; then
        exit 1
    fi
}

# Trap errors and cleanup
trap 'log_error "Script failed on line $LINENO"' ERR

# Run main function
main "$@"