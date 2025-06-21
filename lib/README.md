# Shell Utilities Library

This directory contains shared utilities for chezmoi shell scripts.

## Files

### `shell-utils.sh`

A shared library containing common logging functions and utilities used across all chezmoi scripts.

#### Features

- **Colored Logging**: Consistent colored output with emoji icons
- **Error Handling**: Standardized error trapping and reporting
- **Prerequisites Checking**: Generic function to check for required tools
- **Timing Utilities**: Functions to measure and format execution time
- **Summary Display**: Standardized success/failure reporting
- **Tips Display**: Consistent tips section formatting

#### Usage

```bash
#!/bin/bash

set -euo pipefail

# Source shared utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/shell-utils.sh"

# Setup error handling
setup_simple_error_trap

# Use logging functions
log_info "Starting operation..."
log_success "Operation completed successfully"
log_warning "This is a warning"
log_error "An error occurred"

# Check prerequisites
check_prerequisites "git" "curl" "brew"

# Show summary
show_summary $failures \
    "All operations completed successfully!" \
    "Operations completed with failures"

# Show tips
show_tips \
    "Use 'command --help' for more information" \
    "Check logs in /var/log for details" \
    "Run with DEBUG=1 for verbose output"
```

#### Available Functions

##### Logging Functions

- `log_debug(message)` - Debug messages (only shown when DEBUG=1)
- `log_info(message)` - Information messages
- `log_success(message)` - Success messages
- `log_warning(message)` - Warning messages
- `log_error(message)` - Error messages
- `log_header(message)` - Header messages

##### Utility Functions

- `print_separator()` - Print a visual separator line
- `check_prerequisites(tool1 tool2 ...)` - Check if required tools are available
- `handle_error(line_number [error_code] [command])` - Generic error handler
- `setup_error_handling()` - Setup advanced error handling trap
- `setup_simple_error_trap()` - Setup simple error handling trap
- `time_command(command...)` - Execute command and return duration
- `format_duration(seconds)` - Format duration in human readable format
- `show_script_header(title [version])` - Show standardized script header
- `show_summary(failures success_msg failure_msg)` - Show operation summary
- `show_tips(tip1 tip2 ...)` - Show tips section

#### Environment Variables

- `DEBUG` - Set to "1" to enable debug logging

#### Color Constants

The library defines the following color constants:

- `RED`, `GREEN`, `YELLOW`, `BLUE`, `CYAN` - Standard colors
- `BOLD` - Bold text
- `NC` - No Color (reset)

## Migration

All chezmoi scripts have been updated to use this shared library, eliminating code duplication and ensuring consistent behavior across all scripts.

### Benefits

1. **DRY Principle**: No more duplicated logging functions
2. **Consistency**: All scripts use the same logging format and colors
3. **Maintainability**: Changes to logging behavior only need to be made in one place
4. **Extensibility**: New utility functions can be added and used by all scripts
5. **Testing**: Shared functions can be tested once and used everywhere
