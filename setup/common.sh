#!/bin/bash

# Common setup functions shared by OS-specific installers.
# Each OS script should source this file, then call the desired functions.

set -euo pipefail

STARSHIP_CONFIG_HOME="$HOME/.config"
MISE_HOME="$HOME/.local/bin"
FISH_COMPLETIONS="$HOME/.config/fish/completions"

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

# ──────────────────────────────────────────────
# Tool-specific setup functions
# ──────────────────────────────────────────────

setup_eza() {
    mkdir -p "$HOME/.config/eza"
    if [ ! -f "$FISH_COMPLETIONS/eza.fish" ]; then
        curl -fsSL https://raw.githubusercontent.com/eza-community/eza/refs/heads/main/completions/fish/eza.fish \
            -o "$FISH_COMPLETIONS/eza.fish" || error "Failed to download Eza completions"
    fi
    if [ ! -f "$HOME/.config/eza/theme.yml" ]; then
        curl -fsSL https://raw.githubusercontent.com/eza-community/eza-themes/refs/heads/main/themes/catppuccin-frappe.yml \
            -o "$HOME/.config/eza/theme.yml" || error "Failed to download Eza theme"
    fi
}

setup_fzf() {
    info "Setting up fzf..."
    if ! command -v fzf > /dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install
    else
        info "fzf already installed"
    fi
}

setup_atuin() {
    info "Setting up Atuin..."
    if ! command -v atuin > /dev/null; then
        if [ ! -x "$HOME/.atuin/bin/atuin" ]; then
            # Official installer; --non-interactive skips all prompts.
            # ATUIN_NO_MODIFY_PATH=1 keeps it from editing shell profiles,
            # we manage PATH ourselves via the ~/.local/bin symlink below.
            curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh \
                | ATUIN_NO_MODIFY_PATH=1 sh -s -- --non-interactive \
                || error "Failed to install Atuin"
        fi
        ln -sf "$HOME/.atuin/bin/atuin" "$HOME/.local/bin/atuin"
    fi
    atuin gen-completions --shell fish --out-dir "$FISH_COMPLETIONS" \
        || error "Failed to generate atuin completions"
}

setup_bat() {
    # On some distros (Ubuntu) the binary is called batcat.
    # On Fedora / macOS it is bat.
    if ! command -v bat > /dev/null; then
        if ! command -v batcat > /dev/null; then
            info "bat not found, install it manually"
        else
            sudo ln -s "$(which batcat)" ~/.local/bin/bat
        fi
    fi
    if [ ! -d "$(bat --config-dir)/themes" ]; then
        mkdir -p "$(bat --config-dir)/themes"
        curl -fsSL https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme \
            -o "$(bat --config-dir)/themes/Catppuccin Frappe.tmTheme"
        bat cache --build
        local bat_config="$(bat --config-file)"
        touch "$bat_config"
        echo "--theme=\"Catppuccin Frappe\"" >> "$bat_config"
    fi
    fish -c "set -Ux MANPAGER \"sh -c 'sed -u -e \\\"s/\\\\x1B\\\\[[0-9;]*m//g; s/.\\\\x08//g\\\" | bat -p -lman'\""
}

setup_fd() {
    if ! command -v fd > /dev/null; then
        if ! command -v fdfind > /dev/null; then
            info "fd not found, install it manually"
        else
            sudo ln -s "$(which fdfind)" ~/.local/bin/fd
        fi
    fi
}

setup_delta() {
    if ! command -v delta > /dev/null; then
        info "delta not found, install it manually"
    fi
    if [ ! -f ~/.config/delta/catppuccin.gitconfig ]; then
        mkdir -p ~/.config/delta/themes
        curl -sSfL https://raw.githubusercontent.com/catppuccin/delta/refs/heads/main/catppuccin.gitconfig \
            -o ~/.config/delta/catppuccin.gitconfig
    fi
}

setup_tmux() {
    if [ ! -d $HOME/.config/tmux/plugins/catppuccin/tmux ]; then
        mkdir -p ~/.config/tmux/plugins/catppuccin
        git clone -b v2.1.2 https://github.com/catppuccin/tmux.git $HOME/.config/tmux/plugins/catppuccin/tmux
    fi
    if [ ! -f "$HOME/.tmux.conf" ]; then
        touch "$HOME/.tmux.conf"
    else
        mv -f "$HOME/.tmux.conf" "$HOME/.tmux.conf.bak"
    fi
    cat <<EOF > "$HOME/.tmux.conf"
set -g default-terminal "xterm-256color"
set -g mouse on
set -g history-limit 10000
set -g base-index 1
set -g set-titles on

set-option -g renumber-windows on

# bind prefix to CTRL-Space
unbind C-b
set -g prefix C-Space
bind C-Space send-prefix

set -g @catppuccin_flavor "mocha"
set -g @catppuccin_window_status_style "default"

run ~/.config/tmux/plugins/catppuccin/tmux/catppuccin.tmux

set -g status-right-length 100
set -g status-left-length 100
set -g status-left ""
set -g status-right "#{E:@catppuccin_status_application}"

EOF
}

setup_fish() {
    info "Setting up fish shell..."
    mkdir -p $FISH_COMPLETIONS

    # Set Fish as default shell
    if [[ "$SHELL" != "$(which fish)" ]]; then
        sudo chsh -s "$(which fish)" "$(whoami)" || error "Failed to change shell to Fish"
    fi

    # Fisher plugin manager
    if ! command -v fisher > /dev/null; then
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | \
            fish -c 'source && fisher install jorgebucaran/fisher' \
            || error "Failed to install Fisher"
    fi

    # install catppuccin theme
    fish -c 'fish_config theme choose catppuccin-mocha'

    # install forgit
    fisher install wfxr/forgit

    local fish_config="$HOME/.config/fish/config.fish"
    if [ -f "$fish_config" ] && [ ! -f "$fish_config.bak" ]; then
        mv -f "$fish_config" "$fish_config.bak"
    fi
    cat <<EOF > $fish_config
set TERM xterm-256color
set EDITOR vim
set EZA_CONFIG_DIR $HOME/.config/eza
atuin init fish | source
starship init fish | source
~/.local/bin/mise activate fish | source
zoxide init fish | source
fzf --fish | source
EOF
}

setup_starship() {
    info "Installing Starship prompt..."
    if ! command -v starship >/dev/null; then
        curl -fsSL https://starship.rs/install.sh | sh -s -- -y || error "Failed to install Starship"
    fi

    # Source directory where this script (or the common.sh) lives
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    mkdir -p "$STARSHIP_CONFIG_HOME"
    if [[ ! -f "$STARSHIP_CONFIG_HOME/starship.toml" ]]; then
        cp "$script_dir/../.config/starship.toml" "$STARSHIP_CONFIG_HOME/starship.toml"
        cat <<EOF >> "$STARSHIP_CONFIG_HOME/starship.toml"

# added by setup script
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
    $MISE_HOME/mise use -g usage || error "Failed to setup usage"
    $MISE_HOME/mise completion fish > "$FISH_COMPLETIONS/mise.fish"
}

setup_nvm() {
    info "Setting up nvm (nvm.fish)…"

    # Install nvm.fish via Fisher (fish-native Node version manager)
    fish -c 'fisher install jorgebucaran/nvm.fish' \
        || error "Failed to install nvm.fish"

    # Install the current (latest) Node.js release, pin it as the default
    # for new shells via the universal nvm_default_version, and report the
    # installed version. --silent keeps stdout clean for the version capture.
    local node_version
    node_version="$(fish -c 'nvm install latest --silent; and set --universal nvm_default_version (node --version); and node --version' 2>/dev/null)" \
        || error "Failed to install current Node.js via nvm"
    success "nvm (nvm.fish) with Node.js ${node_version:-installed}"
}

setup_docker() {
    if ! command -v docker >/dev/null; then
        info "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh || error "Failed to download Docker installer"
        sudo sh get-docker.sh || error "Failed to install Docker"
        rm -f get-docker.sh
        sudo groupadd docker >/dev/null 2>&1 || true
        sudo usermod -aG docker "$(whoami)" || error "Failed to add user to docker group"
        info "You'll need to log out and back in for Docker group changes to take effect"
    fi
}

setup_vim() {
    info "Setting up Vim..."
    mkdir -p "$HOME/.vimtmp"
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    cp -r "$script_dir/../.vim/" "$HOME/.vim/"
    cp "$script_dir/../.vimrc" "$HOME/.vimrc"
    git clone https://github.com/catppuccin/vim.git "$HOME/misc/vim"
    cp "$HOME/misc/vim/colors/"* "$HOME/.vim/colors/"
    rm -rf "$HOME/misc/vim"
}
