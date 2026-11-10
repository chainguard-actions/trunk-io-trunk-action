#!/bin/bash

set -euo pipefail

# Split INPUT_ARGUMENTS exactly like upstream's unquoted ${INPUT_ARGUMENTS} (whitespace split + glob).
# shellcheck disable=SC2206
input_args=(${INPUT_ARGUMENTS})

"${TRUNK_PATH}" install \
  --ci \
  ${input_args[@]+"${input_args[@]}"}
