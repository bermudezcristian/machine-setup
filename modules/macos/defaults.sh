#!/bin/bash
# modules/macos/defaults.sh — macOS system defaults
# Merged superset from macos-setup and dotfiles repos.

setup_macos_defaults() {
    echo "Applying macOS system defaults..."

    # ----- Finder -----
    # Show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
    # Show hidden files
    defaults write com.apple.finder AppleShowAllFiles -bool true
    # Default to list view
    defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

    # ----- Trackpad -----
    # Tap to click
    defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
    # Three finger drag
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 0
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerVertSwipeGesture -int 0

    # ----- Keyboard -----
    # Fast key repeat
    defaults write -globalDomain KeyRepeat -int 2
    # Short delay until repeat
    defaults write -globalDomain InitialKeyRepeat -int 15

    # ----- Dock -----
    # Auto-hide Dock
    defaults write com.apple.dock autohide -bool true

    # ----- Stage Manager / Desktop -----
    defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1
    defaults write com.apple.WindowManager AutoHide -bool false
    defaults write com.apple.WindowManager HideDesktop -bool true
    defaults write com.apple.WindowManager StageManagerHideWidgets -bool false
    defaults write com.apple.WindowManager StandardHideDesktopIcons -bool true
    defaults write com.apple.WindowManager StandardHideWidgets -bool true

    # ----- Apply changes -----
    killall Finder 2>/dev/null || true
    killall Dock 2>/dev/null || true

    echo "macOS defaults applied."
}

setup_macos_defaults
