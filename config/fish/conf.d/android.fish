# android.fish — Android SDK environment
#
# Android Studio installs the SDK to ~/Library/Android/sdk on macOS (and to
# ~/Android/Sdk on Linux). Nothing here runs until that directory exists, so
# the config is harmless on machines without Android Studio.
#
# ANDROID_HOME is the variable Gradle, AGP, React Native and Flutter read.
# ANDROID_SDK_ROOT is deprecated upstream and intentionally not set — the
# cmdline-tools warn when the two disagree.

for __android_sdk in $HOME/Library/Android/sdk $HOME/Android/Sdk
    if test -d $__android_sdk
        set -gx ANDROID_HOME $__android_sdk
        break
    end
end
set -e __android_sdk

if set -q ANDROID_HOME
    # Appended, not prepended, so SDK components never shadow Homebrew binaries.
    # Each directory only appears once the matching SDK package is installed.
    for __android_bin in \
        $ANDROID_HOME/cmdline-tools/latest/bin \
        $ANDROID_HOME/platform-tools \
        $ANDROID_HOME/emulator

        if test -d $__android_bin
            fish_add_path -ga $__android_bin
        end
    end
    set -e __android_bin
end
