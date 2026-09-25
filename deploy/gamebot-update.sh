#!/bin/bash
# Fast-forward pull gamebot and reinstall if HEAD changed.
set -euo pipefail

REPO="${GAMEBOT_REPO:-$HOME/src/gamebot}"
PLUGIN_REPO="${GAMEBOT_PLUGIN_REPO:-$HOME/src/gamebot-plugin-chess}"
BRANCH="${GAMEBOT_BRANCH:-main}"
SERVICE="${GAMEBOT_SERVICE:-gamebot.service}"

cd "$REPO"
old=$(git rev-parse HEAD)
git fetch origin "$BRANCH"
if ! git merge --ff-only "origin/$BRANCH"; then
  echo "ff-only failed; fix the repo manually" >&2
  exit 1
fi
new=$(git rev-parse HEAD)

if [[ "$old" == "$new" ]]; then
  echo "already up to date ($new)"
  exit 0
fi

echo "updated $old -> $new"
# shellcheck disable=SC1091
source "$REPO/.venv/bin/activate"
pip install -e "$REPO" -e "$PLUGIN_REPO" --quiet

if systemctl is-enabled --quiet "$SERVICE" 2>/dev/null; then
  sudo systemctl restart "$SERVICE"
  echo "restarted $SERVICE"
else
  echo "service $SERVICE not enabled; skip restart"
fi
