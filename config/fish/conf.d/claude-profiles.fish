# claude-profiles.fish — route Claude Code to a per-account config directory
#
# Claude Code keeps credentials, sessions and settings in one directory, selected by
# CLAUDE_CONFIG_DIR. Running several subscriptions on one machine means one config
# directory per account, picked automatically from the working directory.
#
# The path -> profile mapping is deliberately NOT in this repo: it may reference private
# paths. It lives in $CLAUDE_PROFILES_MAP, default ~/.config/claude-profiles.conf:
#
#     # <absolute path prefix>    <profile name>
#     ~/code/example-org          example
#     ~/code/example-org/sub      example-sub
#
# The longest matching prefix wins, regardless of line order, so nested mappings work.
# A profile named "foo" resolves to ~/.claude-foo; unmatched directories fall through to
# the stock ~/.claude. Lines that are blank or start with # are ignored.
#
# No `command -q claude` guard: conf.d/ is sourced before config.fish, which is what adds
# ~/.local/bin to PATH. The binary is resolved at call time instead.

function __claude_profiles_map --description 'path to the local Claude profile mapping file'
    if set -q CLAUDE_PROFILES_MAP
        echo $CLAUDE_PROFILES_MAP
    else
        echo $HOME/.config/claude-profiles.conf
    end
end

function __claude_profile_for --argument-names dir --description 'map a directory to a Claude profile name'
    set -l map (__claude_profiles_map)
    set -l best default
    set -l best_len 0

    test -r "$map"; or begin
        echo $best
        return
    end

    while read -l line
        set -l entry (string trim -- $line)
        test -z "$entry"; and continue
        string match -q '#*' -- $entry; and continue

        # The profile is the last whitespace-separated field, so prefixes containing
        # spaces are still handled correctly.
        set -l parts (string match -r '^(.*\S)\s+(\S+)$' -- $entry)
        test (count $parts) -eq 3; or continue

        set -l prefix (string replace -r '^~' $HOME -- $parts[2])
        set -l profile $parts[3]

        if test "$dir" = "$prefix"; or string match -q -- "$prefix/*" $dir
            set -l len (string length -- $prefix)
            if test $len -gt $best_len
                set best_len $len
                set best $profile
            end
        end
    end <"$map"

    echo $best
end

function __claude_config_dir_for --argument-names profile --description 'config directory for a Claude profile name'
    if test "$profile" = default -o "$profile" = personal
        echo $HOME/.claude
    else
        echo $HOME/.claude-$profile
    end
end

function claude --wraps claude --description 'Claude Code, routed to the account matching $PWD'
    # An explicit CLAUDE_CONFIG_DIR always wins: claude-as sets it, and Claude Code exports
    # it to subprocesses so a nested session stays on the same account.
    if set -q CLAUDE_CONFIG_DIR
        command claude $argv
        return
    end

    # -P so a symlinked path into a mapped tree still routes correctly.
    set -l profile (__claude_profile_for (pwd -P))

    if test "$profile" = default
        command claude $argv
    else
        set -lx CLAUDE_CONFIG_DIR (__claude_config_dir_for $profile)
        command claude $argv
    end
end

function claude-as --wraps claude --description 'run Claude Code under a named profile: claude-as <profile> [args...]'
    if test (count $argv) -lt 1
        echo "usage: claude-as <profile> [claude args...]" >&2
        return 2
    end

    set -l profile $argv[1]
    set -lx CLAUDE_CONFIG_DIR (__claude_config_dir_for $profile)
    command claude $argv[2..-1]
end

function claude-which --description 'print the Claude profile $PWD resolves to'
    if set -q CLAUDE_CONFIG_DIR
        echo "$CLAUDE_CONFIG_DIR (explicit override)"
    else
        set -l profile (__claude_profile_for (pwd -P))
        echo "$profile -> "(__claude_config_dir_for $profile)
    end
end
