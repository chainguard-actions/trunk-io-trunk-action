#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
# quote-aware manner so that shell metacharacters are never evaluated.
input_args=()
if [ -n "${INPUT_ARGUMENTS:-}" ]; then
  while IFS= read -r -d '' t; do input_args+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" install \
  --ci \
  "${input_args[@]}"
