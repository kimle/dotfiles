#!/bin/sh

set -xo pipefail

bat cache --build
echo 'export BAT_THEME="Forest Night"' >> ~/.zshrc
source ~/.zshrc
