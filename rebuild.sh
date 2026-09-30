#!/usr/bin/env bash
# rebuild.sh - apply config changes, same job as kunchen's rebuild.sh
# (his runs darwin-rebuild switch; ours runs home-manager switch).
set -euo pipefail
home-manager switch -b backup --flake "$HOME/.dotfiles#aker"
