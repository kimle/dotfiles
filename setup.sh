#!/bin/bash

set -euo pipefail

# Configuration
declare -A PACKAGES=(
    [common]="git ripgrep eza fish bat jq gcc delta vim fzf curl fastfetch tmux"
    [linux]="podman"
    [fedora]="docker-compose-plugin"
    [ubuntu]="docker-compose-v2"
    [macos]=""
)


STARSHIP_CONFIG_HOME="$HOME/.config"
MISE_HOME="$HOME/.local/bin"
FISH_COMPLETIONS="$HOME/.config/fish/completions"

# Helper functions
error() {
    echo "❌ Error: $*" >&2
    exit 1
}

info() {
    echo "🔵 $*" >&2
}

success() {
    echo "✅ $*" >&2
}

install_packages() {
    local os_type="$1"
    info "Updating system packages..."

    case "$os_type" in
        linux)
            if [[ -f /etc/os-release ]]; then
                . /etc/os-release
                case "$ID" in
                    # remove tsflags=nodocs from /etc/dnf/dnf.conf before
                    # running
                    fedora)
                        sudo dnf update -y
                        sudo dnf install --skip-unavailable -y ${PACKAGES[common]} ${PACKAGES[linux]} ${PACKAGES[fedora]} \
                            ncurses netcat
                        ;;
                    ubuntu|debian)
                        sudo apt-get update -y && sudo apt-get upgrade -y
                        sudo apt-get install --ignore-missing -y ${PACKAGES[common]} ${PACKAGES[linux]} ${PACKAGES[ubuntu]} \
                            libncurses-dev
                        ;;
                    *)
                        error "Unsupported Linux distribution: $ID" ;;
                esac
            else
                error "Unknown Linux distribution"
            fi
            ;;
        darwin)
            if ! command -v brew > /dev/null; then
                info "Installing Homebrew..."
                bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
                    || error "Failed to install Homebrew"
            fi
            brew update && brew upgrade
            brew install ${PACKAGES[common]} ${PACKAGES[macos]}
            ;;
        *) error "Unsupported OS: $os_type" ;;
    esac
}

setup_eza() {
    mkdir -p "$HOME/.config/eza"
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/fish/eza.fish \
        -o "$FISH_COMPLETIONS/eza.fish" || error "Failed to download Eza completions"
    curl -fsSL https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/catppuccin.yml \
        -o "$HOME/.config/eza/theme.yml" || error "Failed to download Eza theme"
}

setup_tmux() {
    touch "$HOME/.tmux.conf"
    cat <<EOF > "$HOME/.tmux.conf"
set -g default-terminal "xterm-256color"
set -g mouse on
set -g history-limit 10000
set -g base-index 1
set -g set-titles on
EOF
}

setup_fish() {
    info "Setting up fish shell..."
    mkdir -p $FISH_COMPLETIONS

    # Set Fish as default shell
    if [[ "$SHELL" != "$(which fish)" ]]; then
        sudo chsh -s "$(which fish)" "$USER" || error "Failed to change shell to Fish"
    fi

    # Fisher plugin manager
    if ! command -v fisher > /dev/null; then
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | \
            fish -c 'source && fisher install jorgebucaran/fisher' \
            || error "Failed to install Fisher"
    fi

    local fish_config="$HOME/.config/fish/config.fish"
    if [ ! -f "$fish_config" ]; then
        cat <<EOF > $fish_config
set TERM xterm-256color
set EDITOR vim
set EZA_CONFIG_DIR $HOME/.config/eza
starship init fish | source
~/.local/bin/mise activate fish | source
fzf --fish | source
EOF
    fi
}

setup_starship() {
    info "Installing Starship prompt..."
    if ! command -v starship >/dev/null; then
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y || error "Failed to install Starship"
    fi

    mkdir -p "$STARSHIP_CONFIG_HOME"
    if [[ ! -f "$STARSHIP_CONFIG_HOME/starship.toml" ]]; then
        curl -fsSL https://raw.githubusercontent.com/kimle/dotfiles/main/.config/starship.toml \
            -o "$STARSHIP_CONFIG_HOME/starship.toml" || error "Failed to download Starship config"
        cat <<EOF >> /$HOME/.config/starship.toml
[username]
disabled = true

[container]
disabled = true
EOF
    fi
}

setup_mise() {
    info "Installing Mise..."
    if ! command -v mise >/dev/null; then
        curl -fsSL https://mise.run | sh -s -- --yes || error "Failed to install Mise"
    fi

    mkdir -p "$MISE_HOME"
    $MISE_HOME/mise use -g usage || error "Failed to setup Mise"
    $MISE_HOME/mise completion fish > "$FISH_COMPLETIONS/mise.fish"
}

setup_docker() {
    if ! command -v docker >/dev/null; then
        info "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh || error "Failed to download Docker installer"
        sudo sh get-docker.sh || error "Failed to install Docker"
        rm -f get-docker.sh
        sudo groupadd docker >/dev/null 2>&1 || true
        sudo usermod -aG docker "$USER" || error "Failed to add user to docker group"
        info "You'll need to log out and back in for Docker group changes to take effect"
    fi
}

main() {
    info "Starting system setup..."
    OS_TYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"
    [[ "$OS_TYPE" == "darwin" ]] && export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

    mkdir -p ~/.local/bin
    install_packages "$OS_TYPE"
    setup_eza
    setup_tmux
    setup_fish
    setup_starship
    setup_mise
    setup_docker

    success "Setup completed successfully!"
    echo "Restart your terminal or run: exec fish"
}

main "$@"

