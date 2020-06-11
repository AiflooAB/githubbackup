#!/bin/bash

set -euo pipefail

./ok.sh org_repos "$GITHUB_ORG" _filter='.[].clone_url' | sed "s/github.com/${GITHUB_USER}:${GITHUB_TOKEN}@github.com/"
