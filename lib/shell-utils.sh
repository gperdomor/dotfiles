#!/bin/bash

# Shell utilities library for chezmoi scripts
# Common logging functions and utilities

# Color codes for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# Logging functions
log_debug() {
    [[ "${DEBUG:-}" == "1" ]] && echo -e "${CYAN}🔍 DEBUG: $1${NC}" >&2
}

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

log_header() {
    echo -e "${BOLD}${CYAN}$1${NC}"
}

# Utility functions
print_separator() {
    echo -e "${CYAN}───────────────────────────────────────────────────────────────${NC}"
}

# Check if required tools are available
check_prerequisites() {
    local required_tools=("$@")
    local missing_tools=()

    log_debug "Checking prerequisites: ${required_tools[*]}"

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

    log_debug "All prerequisites satisfied"
    return 0
}

# Generic error handler for traps
handle_error() {
    local line_number=$1
    local error_code=${2:-$?}
    local command="${3:-unknown}"

    log_error "Error occurred in script at line $line_number: exit code $error_code"
    [[ "$command" != "unknown" ]] && log_error "Failed command: $command"
    exit $error_code
}

# Setup error handling trap
setup_error_handling() {
    trap 'handle_error $LINENO $? "$BASH_COMMAND"' ERR
}

# Simple error trap (backward compatibility)
setup_simple_error_trap() {
    trap 'log_error "Script failed on line $LINENO"' ERR
}

# Measure execution time
time_command() {
    local start_time
    start_time=$(date +%s)

    # Execute the command passed as arguments
    "$@"
    local exit_code=$?

    local end_time
    end_time=$(date +%s)
    local duration=$((end_time - start_time))

    echo "$duration"
    return $exit_code
}

# Format duration in human readable format
format_duration() {
    local duration=$1

    if [[ $duration -lt 60 ]]; then
        echo "${duration}s"
    elif [[ $duration -lt 3600 ]]; then
        local minutes=$((duration / 60))
        local seconds=$((duration % 60))
        echo "${minutes}m ${seconds}s"
    else
        local hours=$((duration / 3600))
        local minutes=$(((duration % 3600) / 60))
        local seconds=$((duration % 60))
        echo "${hours}h ${minutes}m ${seconds}s"
    fi
}

# Show script header with title and version
show_script_header() {
    local title="$1"
    local version="${2:-1.0.0}"

    echo
    log_header "═══════════════════════════════════════════════════════════════"
    log_header "$title v$version"
    log_header "═══════════════════════════════════════════════════════════════"
    echo
}

# Show summary with failure count
show_summary() {
    local failures=$1
    local success_message="${2:-"Operation completed successfully!"}"
    local failure_message="${3:-"Operation completed with failures"}"

    echo
    if [[ $failures -eq 0 ]]; then
        log_success "🎉 $success_message"
    else
        log_warning "⚠️  $failure_message: $failures failure(s)"
    fi
}

# Show tips section
show_tips() {
    local tips=("$@")

    echo
    log_info "💡 Tips:"
    for tip in "${tips[@]}"; do
        echo "  • $tip"
    done
}
