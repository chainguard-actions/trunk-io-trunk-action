#!/bin/bash

set -euo pipefail

# Split INPUT_ARGUMENTS into an array to avoid unquoted word-splitting injection
read -ra arguments_array <<< "${INPUT_ARGUMENTS}"

"${TRUNK_PATH}" check github_annotate \
  --ci \
  --upstream HEAD \
  --github-commit "${GITHUB_EVENT_WORKFLOW_RUN_HEAD_SHA}" \
  --github-label "${INPUT_LABEL}" \
  "${TRUNK_TMPDIR}/annotations.bin" \
  "${arguments_array[@]+"${arguments_array[@]}"}"
