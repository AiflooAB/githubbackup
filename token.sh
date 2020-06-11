#!/bin/bash

curl --silent \
    -X POST \
    --header "Authorization: Bearer $(./jwt.sh)" \
    --header "Accept: application/vnd.github.machine-man-preview+json" \
    "https://api.github.com/app/installations/$GITHUB_INSTALLATION_ID/access_tokens" \
    | jq --raw-output '.token'
