#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
input_args=()
if [ -n "${INPUT_ARGUMENTS}" ]; then
  while IFS= read -r -d '' t; do input_args+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" install \
  --ci \
  "${input_args[@]}"
