# export ANDROID_HOME=$HOME/Library/Android/sdk
# export ANDROID_NDK=$HOME/Library/Android/sdk/ndk-bundle
# export PATH=${PATH}:$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_NDK

#starship
export STARSHIP_CONFIG=~/.starship.toml
eval "$(starship init zsh)"

#fnm
eval "$(fnm env --use-on-cd)"

# pnpm
# export PNPM_HOME="/Users/gperdomor/Library/pnpm"
# export PATH="$PNPM_HOME:$PATH"
# pnpm end
