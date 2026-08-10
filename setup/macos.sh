#!/bin/bash

# macOS-specific development environment setup.
# Sourcing setup/common.sh for shared configuration functions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=setup/common.sh
source "$SCRIPT_DIR/common.sh"

# ──────────────────────────────────────────────
# macOS package installation via Homebrew
# ──────────────────────────────────────────────

install_packages() {
    info "Installing packages on macOS…"

    if ! command -v brew >/dev/null; then
        info "Installing Homebrew…"
        bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
            || error "Failed to install Homebrew"
    fi

    brew update && brew upgrade

    brew install \
        git ripgrep eza bat fish jq gcc git-delta vim curl fastfetch tmux fd-find age \
        fzf zoxide chezmoi
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────

main() {
    info "Starting macOS setup…"

    export PATH="$HOME/.local/bin:/opt/homebrew/bin:$PATH"

    mkdir -p "$MISE_HOME"
    mkdir -p "$FISH_COMPLETIONS"
    mkdir -p "$HOME/misc"

    install_packages
    setup_eza
    setup_bat
    setup_fd
    setup_fzf
    setup_delta
    setup_tmux
    setup_fish
    setup_starship
    setup_mise
    setup_chezmoi
    setup_nvm
    setup_docker
    setup_vim

    chezmoi apply || error "Failed to apply chezmoi dotfiles"

    success "macOS setup completed successfully!"
    echo "Restart your terminal or run: exec fish"
}

main "$@"
