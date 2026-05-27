#!/bin/bash
# extras/firefox.sh — Configure Firefox profiles (macOS only)
set -e
set -u

if [[ "$(uname -s)" != "Darwin" ]]; then
    echo "firefox.sh is macOS-only. Skipping."
    exit 0
fi

if pgrep -x firefox >/dev/null 2>&1; then
    echo "Firefox is running. Quit Firefox before running this script (SQLite writes can corrupt the DB)."
    exit 1
fi

PROFILES_PATH="/Users/$USER/Library/Application Support/Firefox/Profiles"
DEFAULT_ZOOM="0.8"

set_default_zoom() {
    local profile_dir="$1"
    local db="$profile_dir/content-prefs.sqlite"

    if [[ ! -f "$db" ]]; then
        echo "  - content-prefs.sqlite not found, skipping default zoom"
        return 0
    fi

    sqlite3 "$db" <<SQL
INSERT OR IGNORE INTO settings(name) VALUES('browser.content.full-zoom');
DELETE FROM prefs WHERE groupID IS NULL AND settingID = (SELECT id FROM settings WHERE name='browser.content.full-zoom');
INSERT INTO prefs(groupID, settingID, value, timestamp) VALUES(NULL, (SELECT id FROM settings WHERE name='browser.content.full-zoom'), $DEFAULT_ZOOM, strftime('%s','now'));
SQL
    echo "  - default zoom set to ${DEFAULT_ZOOM}"
}

echo "=== Configuring all Firefox profiles for user: $USER ==="
echo

# Iterate over each profile directory
for PROFILE_DIR in "$PROFILES_PATH"/*; do
    if [[ -d "$PROFILE_DIR" ]]; then
        PROFILE_NAME="$(basename "$PROFILE_DIR")"

        # Skip profiles ending in ".default" (but not ".default-release")
        if [[ "$PROFILE_NAME" == *.default ]]; then
            echo "Skipping profile: $PROFILE_NAME (ends with .default)"
            continue
        fi

        echo "Configuring profile: $PROFILE_NAME"

        # 1. Ensure 'chrome' folder exists
        CHROME_FOLDER="$PROFILE_DIR/chrome"
        mkdir -p "$CHROME_FOLDER"

        # 2. Write userChrome.css safely
        CSS_FILE="$CHROME_FOLDER/userChrome.css"
        cat > "$CSS_FILE" <<'EOF'
#TabsToolbar-customization-target {
    visibility: collapse !important;
}
#TabsToolbar {
    visibility: collapse;
}
EOF
        echo "  - userChrome.css created/overwritten"

        # 3. Update prefs.js with required prefs
        PREFS_FILE="$PROFILE_DIR/prefs.js"
        if [[ -f "$PREFS_FILE" ]]; then
            add_pref_if_missing() {
                local key="$1"
                local value="$2"
                if grep -q "$key" "$PREFS_FILE"; then
                    echo "  - $key already configured"
                else
                    echo "user_pref(\"$key\", $value);" >> "$PREFS_FILE"
                    echo "  - Added $key"
                fi
            }

            add_pref_if_missing "toolkit.legacyUserProfileCustomizations.stylesheets" "true"
            add_pref_if_missing "font.name.serif.x-western" "\"MesloLGL Nerd Font\""
            add_pref_if_missing "font.size.variable.x-western" "12"
        else
            echo "  - prefs.js not found, skipping preference configuration"
        fi

        # 4. Set global default zoom in content-prefs.sqlite
        set_default_zoom "$PROFILE_DIR"

        echo "Done with $PROFILE_NAME"
        echo
    fi
done

echo "=== All profiles configured successfully ==="
