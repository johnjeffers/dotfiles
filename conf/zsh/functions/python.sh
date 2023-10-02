#!/usr/bin/env bash

# export PYPI_URL.
# This used to be an alias, but it made the shell take too long to start
# because it had to evaluate 'catoken' every time the shell started.
# pypiurl() {
#     catoken="$(aws codeartifact get-authorization-token --profile airdna-dev --domain airdna-svc --domain-owner 537022569116 --query authorizationToken --output text)"
#     export PYPI_URL=https://aws:${catoken}@airdna-svc-537022569116.d.codeartifact.us-east-1.amazonaws.com/pypi/pypi/simple/
# }
