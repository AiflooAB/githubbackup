#!/bin/bash

set -eo pipefail

if [ -z "$GITHUB_TOKEN" ] && [ -z "$GITHUB_APP_KEY" ]; then
    echo >&2 "Need either GITHUB_TOKEN or GITHUB_APP_KEY";
    exit 1
fi

if [ -n "$GITHUB_APP_KEY" ] && [ -n "$GITHUB_APP_ID" ] && [ -n "$GITHUB_INSTALLATION_ID" ]; then
    echo >&2 "Using GITHUB APP"
    GITHUB_TOKEN=$(./token.sh)
    export GITHUB_USER=x-access-token
    export GITHUB_TOKEN
fi

[ -z "$GITHUB_TOKEN" ] && ( echo >&2 "GITHUB_TOKEN needs to be set"; exit 1)
[ -z "$BACKUP_DIR" ] &&   ( echo >&2 "BACKUP_DIR needs to be set"; exit 1)

TODAY=$(date -I)
export DEST=$BACKUP_DIR/$TODAY
mkdir -p "$DEST"

./list_repos.sh | parallel ./clone.sh
