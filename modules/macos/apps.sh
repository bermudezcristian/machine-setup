#!/bin/bash
# modules/macos/apps.sh — Mac App Store apps via mas

install_mas_apps() {
    echo "Installing Mac App Store apps..."

    if ! command -v mas &>/dev/null; then
        echo "mas not found — it should have been installed via Brewfile. Skipping."
        return 0
    fi

    # App ID:App Name pairs (bash 3.2 compatible)
    local mas_apps="1333542190:1Password 408981434:iMovie 497799835:Xcode"

    for entry in $mas_apps; do
        local app_id="${entry%%:*}"
        local app_name="${entry##*:}"
        if mas list | grep -q "$app_id"; then
            echo "$app_name already installed."
        else
            echo "Installing $app_name..."
            mas install "$app_id" || echo "Failed to install $app_name."
        fi
    done

    # Accept Xcode license if Xcode is installed
    if mas list | grep -q "497799835"; then
        echo "Accepting Xcode license..."
        sudo xcodebuild -license accept 2>/dev/null || true
    fi

    echo "MAS apps installed."
}

install_mas_apps
