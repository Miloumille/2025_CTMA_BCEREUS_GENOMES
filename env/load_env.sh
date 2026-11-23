#!/usr/bin/env bash
# Usage (bash) : source env/load_env.sh
_ENV_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PROJECT_ROOT="$(dirname "$_ENV_DIR")"
set -a
[ -f "$HOME/.config/bioinfo/machine.env" ] && . "$HOME/.config/bioinfo/machine.env"
. "$_ENV_DIR/paths.env"
[ -f "$_ENV_DIR/paths.local.env" ] && . "$_ENV_DIR/paths.local.env"
set +a
unset _ENV_DIR
