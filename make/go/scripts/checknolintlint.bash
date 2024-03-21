#!/usr/bin/env bash

# Managed by makego. DO NOT EDIT.

## checknolintlint exits with an exit code of 0 if nolintlint is enabled and configured properly.
## It exits with an exit code of 2 if nolintlint is not enabled in .golangci.yml.
## It exits with an exit code of 1 if nolintlint is not configured according to standards.

set -euo pipefail

# Check if nonolint linter is enabled in config
NOLINTLINT_ENABLED=0
if [[ `yq '.linters.enable // [] | any_c(. == "nolintlint")' .golangci.yml` == "true" ]]; then
    # Enabled individually
    NOLINTLINT_ENABLED=1
elif [[ `yq '.linters.enable-all' .golangci.yml` == "true" ]]; then
    # Enabled with enable-all
    NOLINTLINT_ENABLED=1
fi
if [ "${NOLINTLINT_ENABLED}" -eq 1 ]; then
    # Ensure it isn't disabled individually
    if [[ `yq '.linters.disable // [] | any_c(. == "nolintlint")' .golangci.yml` == "true" ]]; then
        NOLINTLINT_ENABLED=0
    fi
fi
if [ "${NOLINTLINT_ENABLED}" -eq 0 ]; then
    exit 2
fi

# Check if nolintlint is configured according to standards.
#
#   linters-settings:
#     nolintlint:
#       allow-unused: false
#       allow-no-explanation: []
#       require-explanation: true
#       require-specific: true
#

declare allow_unused= require_explanation= require_specific= allow_no_explanation_0=
eval $(yq --output-format shell '.linters-settings.nolintlint' .golangci.yml)
if [[ "${allow_unused}" != "false" ]]; then
    echo ".golangci.yml: nolintlint allow-unused must be set to false" >&2
    exit 1
fi
if [[ "${require_explanation}" != "true" ]]; then
    echo ".golangci.yml: nolintlint require-explanation must be set to true" >&2
    exit 1
fi
if [[ "${require_specific}" != "true" ]]; then
    echo ".golangci.yml: nolintlint require-specific must be set to true" >&2
    exit 1
fi
if [[ -n "${allow_no_explanation_0}" ]]; then
    echo ".golangci.yml: nolintlint allow-no-explanation must be empty" >&2
    exit 1
fi
exit 0
