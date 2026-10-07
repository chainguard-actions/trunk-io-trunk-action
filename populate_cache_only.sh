#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS into an array (handles quoted args safely)
input_arguments=()
if [ -n "${INPUT_ARGUMENTS}" ]; then
  while IFS= read -r -d '' t; do input_arguments+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" install \
  --ci \
  "${input_arguments[@]+"${input_arguments[@]}"}"
