#!/bin/bash
# modules/shared/ssh.sh — Generate SSH key and configure SSH defaults

setup_ssh() {
    echo "Configuring SSH..."

    local ssh_dir="$HOME/.ssh"
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    # Generate ED25519 key if none exists
    if [[ ! -f "$ssh_dir/id_ed25519" ]]; then
        echo "Generating ED25519 SSH key..."
        echo "Enter your email for the SSH key (or press Enter to skip):"
        read -r ssh_email
        if [[ -n "$ssh_email" ]]; then
            ssh-keygen -t ed25519 -C "$ssh_email" -f "$ssh_dir/id_ed25519"
            echo "SSH key generated at $ssh_dir/id_ed25519"
        else
            echo "Skipped SSH key generation."
        fi
    else
        echo "SSH key already exists at $ssh_dir/id_ed25519"
    fi

    # Write sensible SSH config defaults if not already present
    local ssh_config="$ssh_dir/config"
    if [[ ! -f "$ssh_config" ]]; then
        echo "Writing SSH config defaults..."
        cat > "$ssh_config" <<'SSHEOF'
# Default SSH configuration
# Add host-specific blocks below or in ~/.ssh/config.d/

Host *
    AddKeysToAgent 3600
    IdentityFile ~/.ssh/id_ed25519
    ServerAliveInterval 60
    ServerAliveCountMax 3
SSHEOF
        # Note: UseKeychain intentionally omitted — passphrase is never
        # persisted, so it must be entered manually after each expiry.
        # This limits the window where an unlocked session can be abused.
        chmod 600 "$ssh_config"
        echo "SSH config written."
    else
        echo "SSH config already exists. Skipping."
    fi

    # Start ssh-agent if not running
    if ! pgrep -u "$USER" ssh-agent &>/dev/null; then
        eval "$(ssh-agent -s)" &>/dev/null
        echo "ssh-agent started."
    fi

    # Add key to agent if it exists
    if [[ -f "$ssh_dir/id_ed25519" ]]; then
        ssh-add -t 3600 "$ssh_dir/id_ed25519" 2>/dev/null || true
    fi

    echo "SSH configured."
}

setup_ssh
