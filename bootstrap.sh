#!/usr/bin/env bash
# bootstrap.sh - first-time setup, the WSL version of kunchen's bootstrap.sh.
# Nix is assumed installed already (Determinate installer). This script:
#   1. symlinks this repo to ~/.dotfiles (home.nix points through that path)
#   2. runs the first home-manager switch
# After this, use ./rebuild.sh for every config change.
set -euo pipefail
cd "$(dirname "$0")"

ln -sfn "$PWD" "$HOME/.dotfiles"

# -b backup: any existing file home-manager wants to manage gets renamed
# to <name>.backup instead of blocking the switch
nix run home-manager/release-26.05 -- switch -b backup --flake .#aker

echo
echo "Done. To make zsh your login shell:"
echo "  command -v zsh | sudo tee -a /etc/shells && chsh -s \"\$(command -v zsh)\""
