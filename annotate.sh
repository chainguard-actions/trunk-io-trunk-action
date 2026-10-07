#!/bin/bash

set -euo pipefail

# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
# quote-aware manner so that shell metacharacters are never evaluated.
input_args=()
if [ -n "${INPUT_ARGUMENTS:-}" ]; then
  while IFS= read -r -d '' t; do input_args+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

"${TRUNK_PATH}" check github_annotate \
  --ci \
  --upstream HEAD \
  --github-commit "${GITHUB_EVENT_WORKFLOW_RUN_HEAD_SHA}" \
  --github-label "${INPUT_LABEL}" \
  "${TRUNK_TMPDIR}/annotations.bin" \
  "${input_args[@]}"
