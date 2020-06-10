#!/bin/bash

set -euo pipefail

GITHUB_USER=ecksun

./ok.sh org_repos AiflooAB _filter='.[].clone_url' | sed "s/github.com/${GITHUB_USER}:${GITHUB_TOKEN}@github.com/"
