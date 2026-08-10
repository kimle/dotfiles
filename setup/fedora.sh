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

    # Make man pages available in general: tsflags=nodocs in /etc/dnf/dnf.conf
    # suppresses installation of docs/man pages for every package. Remove it so
    # packages ship their man pages, then reinstall everything to restore the
    # docs that were skipped while it was set.
    if grep -q '^tsflags=nodocs' /etc/dnf/dnf.conf; then
        info "Removing tsflags=nodocs from /etc/dnf/dnf.conf (man pages were disabled)"
        sudo sed -i '/^tsflags=nodocs/d' /etc/dnf/dnf.conf
        info "Reinstalling packages to restore man pages/docs..."
        mapfile -t all_pkgs < <(rpm -qa)
        sudo dnf reinstall -y "${all_pkgs[@]}" \
            || info "Failed to restore docs for some packages; run 'sudo dnf reinstall \$(rpm -qa)' manually"
    fi

    sudo dnf update -y

    sudo dnf install --skip-unavailable -y \
        git ripgrep eza bat fish jq gcc git-delta vim curl fastfetch tmux fd-find age \
        podman docker-compose-plugin fzf zoxide chezmoi \
        ncurses netcat man-db man-pages
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
    setup_atuin
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

    success "Fedora setup completed successfully!"
    echo "Restart your terminal or run: exec fish"
}

main "$@"
