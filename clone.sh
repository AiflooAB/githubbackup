#!/bin/bash

set -euo pipefail

cd "$DEST" || exit 1
git clone --quiet --bare "$1"
