#!/bin/bash

set -euo pipefail

[ -z "$GITHUB_TOKEN" ] && ( echo >&2 "GITHUB_TOKEN needs to be set"; exit 1)
[ -z "$BACKUP_DIR" ] &&   ( echo >&2 "BACKUP_DIR needs to be set"; exit 1)

TODAY=$(date -I)
export DEST=$BACKUP_DIR/$TODAY
mkdir -p "$DEST"

./list_repos.sh | sort --random-sort | head | parallel ./clone.sh
