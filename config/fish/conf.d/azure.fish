# azure.fish — Azure CLI profile switching via AZURE_CONFIG_DIR
#
# Each profile is a separate ~/.azure.profiles/<name> directory holding its
# own login state, so multiple identities/tenants can coexist without
# re-logging in.
#
# Usage:
#   az-use <name>        # switch to ~/.azure.profiles/<name> (run `az login` once per profile)
#   az-profile           # show the active profile
#   az-profiles          # list all profiles, marking the active one
#   az-profile-clear     # revert to the default ~/.azure

if command -q az
    set -g __az_profiles_root $HOME/.azure.profiles

    function az-use --description 'Switch Azure CLI profile (AZURE_CONFIG_DIR=~/.azure.profiles/<name>)'
        if test (count $argv) -ne 1
            echo "usage: az-use <name>" >&2
            return 1
        end
        set -gx AZURE_CONFIG_DIR $__az_profiles_root/$argv[1]
        echo "az profile: $argv[1] ($AZURE_CONFIG_DIR)"
        if not test -f $AZURE_CONFIG_DIR/azureProfile.json
            echo "(no login found — run `az login` to initialise this profile)"
        end
    end

    function az-profile --description 'Show the active Azure CLI profile'
        if set -q AZURE_CONFIG_DIR
            echo $AZURE_CONFIG_DIR
        else
            echo "default (~/.azure)"
        end
    end

    function az-profiles --description 'List Azure CLI profiles (active one marked with *)'
        if not test -d $__az_profiles_root
            echo "no profiles yet — create one with `az-use <name>` then `az login`"
            return 0
        end
        set -l active ''
        if set -q AZURE_CONFIG_DIR
            set active (basename $AZURE_CONFIG_DIR)
        end
        for dir in $__az_profiles_root/*/
            set -l name (basename $dir)
            if test "$name" = "$active"
                echo "* $name"
            else
                echo "  $name"
            end
        end
    end

    function az-profile-clear --description 'Revert to the default Azure CLI profile (~/.azure)'
        set -e AZURE_CONFIG_DIR
        echo "az profile: default (~/.azure)"
    end
end
