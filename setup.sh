#!/bin/bash

# Thin dispatcher: detects the OS and delegates to the OS-specific setup script.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

OS_TYPE="$(uname -s | tr '[:upper:]' '[:lower:]')"

case "$OS_TYPE" in
    darwin)
        exec "$SCRIPT_DIR/setup/macos.sh"
        ;;
    linux)
        if [[ -f /etc/os-release ]]; then
            . /etc/os-release
            case "$ID" in
                fedora)
                    exec "$SCRIPT_DIR/setup/fedora.sh"
                    ;;
                ubuntu|debian)
                    echo "Ubuntu/Debian setup not yet extracted — falling through to original script."
                    echo "Run the original setup logic inline, or use the full setup.sh as before."
                    exit 1
                    ;;
                *)
                    echo "Unsupported Linux distribution: $ID" >&2
                    exit 1
                    ;;
            esac
        else
            echo "Unknown Linux distribution" >&2
            exit 1
        fi
        ;;
    *)
        echo "Unsupported OS: $OS_TYPE" >&2
        exit 1
        ;;
esac
