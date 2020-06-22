#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

curl --silent \
    -X POST \
    --header "Authorization: Bearer $("$DIR/jwt.sh")" \
    --header "Accept: application/vnd.github.machine-man-preview+json" \
    "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens" \
    | jq --raw-output '.token'
