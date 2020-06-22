#!/bin/bash

set -euo pipefail

if [ -n "$GITHUB_APP_KEY" ] && [ -n "$GITHUB_APP_ID" ] && [ -n "$GITHUB_INSTALLATION_ID" ]; then
    export GIT_ASKPASS="$PWD/token.sh"
    export GITHUB_USER=x-access-token
fi

cd "$DEST" || exit 1
repo=$(sed "s/github.com/${GITHUB_USER}@github.com/" <<<"$1")

echo "[CLONE] Started:  $1"

git clone --quiet --bare "$repo"

echo "[CLONE] Finished: $1"
