#!/bin/bash

# Fedora-specific development environment setup.
# Sourcing setup/common.sh for shared configuration functions.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck source=setup/common.sh
source "$SCRIPT_DIR/common.sh"

# ──────────────────────────────────────────────
# Fedora package installation via DNF
# ──────────────────────────────────────────────

install_packages() {
    info "Installing packages on Fedora…"

    # Remove tsflags=nodocs from /etc/dnf/dnf.conf before running

    sudo dnf update -y

    sudo dnf install --skip-unavailable -y \
        git ripgrep eza bat fish jq gcc git-delta vim curl fastfetch tmux fd-find age \
        podman docker-compose-plugin fzf zoxide \
        ncurses netcat
}

# ──────────────────────────────────────────────
# Main
# ──────────────────────────────────────────────

main() {
    info "Starting Fedora setup…"

    export PATH="$HOME/.local/bin:$PATH"

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
    setup_nvm
    setup_docker
    setup_vim

    success "Fedora setup completed successfully!"
    echo "Restart your terminal or run: exec fish"
}

main "$@"
