#!/bin/bash
# modules/linux/defaults.sh — Linux desktop settings via gsettings/dconf
# Only applies if GNOME desktop is detected.

setup_linux_defaults() {
    if ! command -v gsettings &>/dev/null; then
        echo "gsettings not found. Skipping Linux desktop defaults."
        return 0
    fi

    echo "Applying Linux desktop defaults..."

    # Show hidden files in file manager
    gsettings set org.gtk.Settings.FileChooser show-hidden true 2>/dev/null || true

    # Set restrictive umask
    if ! grep -q 'umask 0077' ~/.profile 2>/dev/null; then
        echo 'umask 0077' >> ~/.profile
    fi

    echo "Linux defaults applied."
}

setup_linux_defaults
