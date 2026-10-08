#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS (a whitespace-separated list of extra CLI flags) into an array
_input_arguments=()
if [ -n "${INPUT_ARGUMENTS}" ]; then
  while IFS= read -r -d '' t; do _input_arguments+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" install \
  --ci \
  "${_input_arguments[@]}"
