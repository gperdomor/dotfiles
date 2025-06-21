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

# Check if we're on macOS
check_macos() {
    if [[ "$(uname -s)" != "Darwin" ]]; then
        log_error "This script is designed for macOS only"
        log_info "Current OS: $(uname -s)"
        exit 1
    fi
}

# Customize Finder preferences
customize_finder() {
    log_info "📁 Configuring Finder..."

    # Show status bar in the bottom of Finder windows
    defaults write com.apple.finder "ShowStatusBar" -bool "true"

    # Show path bar in the bottom of Finder windows
    # defaults write com.apple.finder "ShowPathbar" -bool "true"

    # Set the default view style for folders without custom setting (Column view)
    defaults write com.apple.finder "FXPreferredViewStyle" -string "clmv"

    # Keep folders on top when sorting by name
    defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true"

    # Show all filename extensions
    # defaults write NSGlobalDomain "AppleShowAllExtensions" -bool "true"

    # Show hidden files by default
    # defaults write com.apple.finder "AppleShowAllFiles" -bool "true"

    # Disable the warning when changing a file extension
    # defaults write com.apple.finder "FXEnableExtensionChangeWarning" -bool "false"

    # Use list view in all Finder windows by default (can be overridden per window)
    # defaults write com.apple.finder "FXPreferredViewStyle" -string "Nlsv"

    # Show the ~/Library folder
    # chflags nohidden ~/Library 2>/dev/null || true

    # Show the /Volumes folder
    # sudo chflags nohidden /Volumes 2>/dev/null || true

    # Set Home as the default location for new Finder windows
    defaults write com.apple.finder "NewWindowTarget" -string "PfDe"
    defaults write com.apple.finder "NewWindowTargetPath" -string "file://${HOME}/"

    # Disable the warning before emptying the Trash
    #defaults write com.apple.finder "WarnOnEmptyTrash" -bool "false"

    # Enable snap-to-grid for icons on the desktop and in other icon views
    #/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true
    #/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist 2>/dev/null || true

    log_success "Finder preferences customized"

    # Restart Finder to apply changes
    log_info "Restarting Finder to apply changes..."
    killall Finder 2>/dev/null || true
}

# Customize Dock preferences
customize_dock() {
    log_info "🚀 Configuring Dock..."

    # Set the icon size of Dock items in pixels (16-128, default is 64)
    defaults write com.apple.dock "tilesize" -int "42"

    # Enable magnification when hovering over Dock items
    # defaults write com.apple.dock "magnification" -bool "true"
    # defaults write com.apple.dock "largesize" -int "64"

    # Set the Dock position (left, bottom, right)
    # defaults write com.apple.dock "orientation" -string "bottom"

    # Autohide the Dock (can be toggled with ⌥⌘D)
    # defaults write com.apple.dock "autohide" -bool "false"

    # Set autohide delay to 0 for instant show/hide
    # defaults write com.apple.dock "autohide-delay" -float "0"

    # Set the animation when hiding/showing the Dock
    # defaults write com.apple.dock "autohide-time-modifier" -float "0.5"

    # Minimize windows into their application's icon
    # defaults write com.apple.dock "minimize-to-application" -bool "true"

    # Enable spring loading for all Dock items
    # defaults write com.apple.dock "enable-spring-load-actions-on-all-items" -bool "true"

    # Show indicator lights for open applications
    # defaults write com.apple.dock "show-process-indicators" -bool "true"

    # Don't animate opening applications from the Dock
    # defaults write com.apple.dock "launchanim" -bool "false"

    # Speed up Mission Control animations
    # defaults write com.apple.dock "expose-animation-duration" -float "0.1"

    # Don't group windows by application in Mission Control
    # defaults write com.apple.dock "expose-group-by-app" -bool "false"

    # Disable Dashboard
    # defaults write com.apple.dashboard "mcx-disabled" -bool "true"

    # Don't show Dashboard as a Space
    # defaults write com.apple.dock "dashboard-in-overlay" -bool "true"

    # Don't automatically rearrange Spaces based on most recent use
    # defaults write com.apple.dock "mru-spaces" -bool "false"

    # Remove the auto-hiding Dock delay
    # defaults write com.apple.dock "autohide-delay" -float "0"

    # Remove the animation when hiding/showing the Dock
    # defaults write com.apple.dock "autohide-time-modifier" -float "0"

    # Make Dock icons of hidden applications translucent
    # defaults write com.apple.dock "showhidden" -bool "true"

    # Don't show recent applications in Dock
    # defaults write com.apple.dock "show-recents" -bool "false"

    log_success "Dock preferences customized"

    # Restart Dock to apply changes
    log_info "Restarting Dock to apply changes..."
    killall Dock 2>/dev/null || true
}

# Customize Trackpad preferences
customize_trackpad() {
    log_info "👆 Configuring Trackpad..."

    # Enable tap to click for this user and for the login screen
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "Clicking" -bool "true"
    defaults -currentHost write NSGlobalDomain "com.apple.mouse.tapBehavior" -int "1"
    defaults write NSGlobalDomain "com.apple.mouse.tapBehavior" -int "1"

    # Enable secondary click (right-click) with two finger tap
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadRightClick" -bool "true"
    defaults -currentHost write NSGlobalDomain "com.apple.trackpad.enableSecondaryClick" -bool "true"
    defaults write NSGlobalDomain "com.apple.trackpad.enableSecondaryClick" -bool "true"

    # Set secondary click to bottom right corner (0=bottom right, 1=bottom left)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadCornerSecondaryClick" -int "0"
    # defaults -currentHost write NSGlobalDomain "com.apple.trackpad.cornerClick" -int "0"
    # defaults write NSGlobalDomain "com.apple.trackpad.cornerClick" -int "0"

    # Enable three finger drag
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadThreeFingerDrag" -bool "true"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"

    # Set trackpad tracking speed (0=slow, 3=fast)
    # defaults write NSGlobalDomain "com.apple.trackpad.scaling" -float "2.5"

    # Enable natural scrolling (content tracks finger movement)
    # defaults write NSGlobalDomain "com.apple.swipescrolldirection" -bool "true"

    # Enable pinch to zoom
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadPinch" -bool "true"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadPinch" -bool "true"

    # Enable smart zoom (double-tap with two fingers)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadTwoFingerDoubleTapGesture" -bool "true"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadTwoFingerDoubleTapGesture" -bool "true"

    # Enable rotate gesture
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadRotate" -bool "true"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadRotate" -bool "true"

    # Enable notification center gesture (two finger slide from right edge)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadTwoFingerFromRightEdgeSwipeGesture" -int "3"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadTwoFingerFromRightEdgeSwipeGesture" -int "3"

    # Enable Mission Control gesture (four finger swipe up)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadFourFingerVertSwipeGesture" -int "2"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadFourFingerVertSwipeGesture" -int "2"

    # Enable App Exposé gesture (four finger swipe down)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadFourFingerPinchGesture" -int "2"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadFourFingerPinchGesture" -int "2"

    # Enable application switching gesture (four finger swipe left/right)
    # defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad "TrackpadFourFingerHorizSwipeGesture" -int "2"
    # defaults write com.apple.AppleMultitouchTrackpad "TrackpadFourFingerHorizSwipeGesture" -int "2"

    # Enable Launchpad gesture (pinch with thumb and three fingers)
    # defaults write com.apple.dock "showLaunchpadGestureEnabled" -bool "true"

    # Enable Show Desktop gesture (spread thumb and three fingers)
    # defaults write com.apple.dock "showDesktopGestureEnabled" -bool "true"

    # Disable force click and haptic feedback (can be battery draining)
    # defaults write NSGlobalDomain "com.apple.trackpad.forceClick" -bool "false"
    # defaults write com.apple.AppleMultitouchTrackpad "ForceSuppressed" -bool "true"

    # Set click pressure (0=light, 1=medium, 2=firm)
    # defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "1"
    # defaults write com.apple.AppleMultitouchTrackpad "SecondClickThreshold" -int "1"

    # Enable silent clicking (reduce trackpad noise)
    # defaults write com.apple.AppleMultitouchTrackpad "ActuationStrength" -int "0"

    log_success "Trackpad preferences customized"

    # Note: Trackpad settings typically require logout/login to take full effect
    log_info "Note: Some trackpad settings may require logout/login to take full effect"
}

# Main execution
main() {
    echo
    log_info "⚙️  Customizing preferences and settings for macOS..."
    echo

    # Check environment
    check_macos

    # Core UI Customizations
    customize_finder
    customize_dock
    customize_trackpad

    show_summary 0 \
        "System customization completed successfully!" \
        "System customization completed with failures"

    # Summary of what was configured
    echo
    log_info "📋 Configuration Summary:"
    echo "  ✅ Finder preferences (status bar, path bar, view settings)"
    echo "  ✅ Dock preferences (size, animations, behaviors)"
    echo "  ✅ Trackpad preferences (tap to click, gestures)"

    # Next steps and recommendations
    echo
    log_info "🚀 Next Steps:"
    echo "  • Some settings require a logout/login to take full effect"
    echo "  • Trackpad settings may need system restart for complete activation"
    echo "  • Run 'killall SystemUIServer' if menu bar changes don't appear"
    echo "  • Customize further by editing this script in ~/.local/share/chezmoi"

    # Optional restart recommendation
    echo
    log_warning "💡 Recommendation: Restart your Mac to ensure all settings take effect"
}

# Run main function
main "$@"