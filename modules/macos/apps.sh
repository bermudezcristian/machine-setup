#!/bin/bash
# modules/macos/apps.sh — Mac App Store apps via mas

install_mas_apps() {
    echo "Installing Mac App Store apps..."

    if ! command -v mas &>/dev/null; then
        echo "mas not found — it should have been installed via Brewfile. Skipping."
        return 0
    fi

    # Cache installed apps list
    local installed
    installed="$(mas list)"

    # App ID:App Name pairs
    local mas_apps=(
        "408981434:iMovie"
        "497799835:Xcode"
        "1451685025:WireGuard"
    )

    for entry in "${mas_apps[@]}"; do
        local app_id="${entry%%:*}"
        local app_name="${entry##*:}"
        if echo "$installed" | grep -q "$app_id"; then
            echo "$app_name already installed."
        else
            echo "Installing $app_name..."
            mas install "$app_id" || echo "Failed to install $app_name."
        fi
    done

    echo "MAS apps installed."
}

install_mas_apps
