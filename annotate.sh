#!/bin/bash

set -euo pipefail

# Split INPUT_ARGUMENTS exactly like upstream's unquoted ${INPUT_ARGUMENTS} (whitespace split + glob).
# shellcheck disable=SC2206
input_args=(${INPUT_ARGUMENTS})

"${TRUNK_PATH}" check github_annotate \
  --ci \
  --upstream HEAD \
  --github-commit "${GITHUB_EVENT_WORKFLOW_RUN_HEAD_SHA}" \
  --github-label "${INPUT_LABEL}" \
  "${TRUNK_TMPDIR}/annotations.bin" \
  ${input_args[@]+"${input_args[@]}"}
