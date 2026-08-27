#!/bin/bash
# Host-side setup for an apple/container container machine (macOS host).
# Run AFTER the container machine is created and its in-VM setup has run.
#
# Does, in order:
#   1. Generate an ed25519 keypair in ~/.container/ssh if missing
#   2. Push the public key into the machine's ~/.ssh/authorized_keys
#   3. Make sshd in the machine listen on the container ssh port (in
#      addition to 22, so the container tool's own integration keeps working)
#   4. Write ~/.container/ssh/config with a templated Host block
#
# Prompts for: container machine name, ssh Host alias, HostName, and user.
# Port defaults to 32222 (override with CONTAINER_MACHINE_SSH_PORT).

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=setup/common.sh
source "$SCRIPT_DIR/common.sh"

MACHINE=""
ALIAS=""
HOSTNAME=""
USER=""
PORT="${CONTAINER_MACHINE_SSH_PORT:-32222}"

SSH_DIR="$HOME/.container/ssh"
KEY="$SSH_DIR/id_ed25519"
PUB="$KEY.pub"
CONFIG="$SSH_DIR/config"

main() {
    info "Configuring container machine for SSH access..."
    [ "$(uname -s)" = "Darwin" ] || error "This script runs on the macOS host only"
    command -v container >/dev/null 2>&1 || error "apple/container CLI not found"
    command -v ssh-keygen >/dev/null 2>&1 || error "ssh-keygen not found"

    read_config

    mkdir -p "$SSH_DIR"
    chmod 700 "$SSH_DIR"

    generate_key
    ensure_machine_running
    push_public_key
    configure_sshd
    write_ssh_config
    success "Done. Try: ssh '$ALIAS'"
}

read_config() {
    while [ -z "$MACHINE" ]; do read -rp "container machine name (see 'container machine ls'): " MACHINE; done
    while [ -z "$ALIAS" ]; do read -rp "ssh Host alias (e.g. dev.machine): " ALIAS; done
    while [ -z "$HOSTNAME" ]; do read -rp "ssh HostName (how the machine resolves): " HOSTNAME; done
    while [ -z "$USER" ]; do read -rp "ssh user: " USER; done
}

generate_key() {
    if [ -f "$KEY" ]; then
        info "SSH key already exists ($KEY)"
    else
        info "Generating ed25519 keypair..."
        ssh-keygen -t ed25519 -N "" -f "$KEY" || error "Failed to generate keypair"
    fi
}

ensure_machine_running() {
    info "Making sure machine '$MACHINE' is running..."
    container machine run -n "$MACHINE" true || error "Machine '$MACHINE' failed to start"
}

push_public_key() {
    info "Pushing public key to '$MACHINE' authorized_keys..."
    local pub
    pub="$(cat "$PUB")"
    # The container CLI joins the command args and re-parses them through the
    # machine's shell, so a nested `sh -c` wrapper does NOT work (only the word
    # right after -c would become the script). Pass the whole command as ONE
    # argument instead; the machine shell then parses it with full quoting.
    if container machine run -n "$MACHINE" -- "grep -qF '$pub' ~/.ssh/authorized_keys 2>/dev/null"; then
        info "Key already authorized"
    else
        container machine run -n "$MACHINE" -i -- \
            "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys && chmod 700 ~/.ssh" \
            < "$PUB" || error "Failed to add key to authorized_keys"
    fi
}

configure_sshd() {
    info "Making sshd listen on port $PORT (keeping 22 for the container tool)..."
    # Same quoting rule as push_public_key: no nested `sh -c`, one argument,
    # single line. `sudo` is applied per privileged command.
    container machine run -n "$MACHINE" -- \
        "sudo grep -q '^Port ${PORT}\$' /etc/ssh/sshd_config || printf '\\n# container-machine setup\\nPort ${PORT}\\n' | sudo tee -a /etc/ssh/sshd_config >/dev/null; sudo systemctl restart sshd 2>/dev/null || sudo systemctl restart ssh 2>/dev/null || sudo pkill -HUP sshd 2>/dev/null || true" \
        || error "Failed to configure sshd (is passwordless sudo set up in the machine?)"
    # The restart above is best-effort and its exit status is masked by `|| true`,
    # so verify the config change explicitly instead of trusting exit codes.
    container machine run -n "$MACHINE" -- "sudo grep -q '^Port ${PORT}\$' /etc/ssh/sshd_config" \
        || error "sshd_config does not contain 'Port $PORT' — configuration failed"
}

write_ssh_config() {
    info "Writing ssh config for '$ALIAS'..."
    cat > "$CONFIG" <<EOF
Host $ALIAS
   HostName $HOSTNAME
   Port $PORT
   ForwardAgent yes
   UserKnownHostsFile $SSH_DIR/known_hosts
   User $USER
   IdentityFile $KEY
   IdentitiesOnly yes
EOF
    chmod 600 "$CONFIG"
    ssh -G "$ALIAS" >/dev/null 2>&1 || error "ssh config failed to parse"
    info "Config written to $CONFIG (make sure your ~/.ssh/config includes this dir)"
}

main "$@"
