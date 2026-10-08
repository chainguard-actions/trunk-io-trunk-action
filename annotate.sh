#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS (a whitespace-separated list of extra CLI flags) into an array
_input_arguments=()
if [ -n "${INPUT_ARGUMENTS}" ]; then
  while IFS= read -r -d '' t; do _input_arguments+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" check github_annotate \
  --ci \
  --upstream HEAD \
  --github-commit "${GITHUB_EVENT_WORKFLOW_RUN_HEAD_SHA}" \
  --github-label "${INPUT_LABEL}" \
  "${TRUNK_TMPDIR}/annotations.bin" \
  "${_input_arguments[@]}"
