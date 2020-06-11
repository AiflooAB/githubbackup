#!/bin/bash

set -euo pipefail

header=$(jq --compact-output . <<<'{
	"alg": "RS256"
}')

payload=$(
	jq --null-input \
        --compact-output \
        --arg time_str "$(date +%s)" \
        --arg exp_str "$(date --date="now + 10 minutes" +%s)" \
        --arg iss "$GITHUB_APP_ID" \
	'{
        "iat": ($time_str | tonumber),
        "exp": ($exp_str  | tonumber),
        "iss": $iss,
     }'
)

base64_encode()
{
	# Use `tr` to URL encode the output from base64.
	cat | base64 | tr -d '=' | tr '/+' '_-' | tr -d '\n'
}

encoded_payload="$(base64_encode <<<"${header}").$(base64_encode <<<"${payload}")"
signature=$(echo -n "${encoded_payload}" | openssl dgst -binary -sha256 -sign "$GITHUB_APP_KEY" | base64_encode)

echo "${encoded_payload}.${signature}"
