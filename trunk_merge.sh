#!/bin/bash

set -euo pipefail

# shellcheck source=git_github.sh
source "${BASH_SOURCE[0]%/*}/git_github.sh"

if [[ ${INPUT_DEBUG} == "true" ]]; then
  set -x
fi

# Tokenize INPUT_ARGUMENTS (an args-style list) into an array using xargs so that
# quoted sub-arguments are handled correctly without enabling shell injection.
input_arguments=()
if [ -n "${INPUT_ARGUMENTS}" ]; then
  while IFS= read -r -d '' t; do input_arguments+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

head_sha=$(git rev-parse HEAD)
fetch --depth=2 origin "${head_sha}"
upstream=$(git rev-parse HEAD^1)
git_commit=$(git rev-parse HEAD^2)
echo "Detected merge queue commit, using HEAD^1 (${upstream}) as upstream and HEAD^2 (${git_commit}) as github commit"

"${TRUNK_PATH}" check \
  --ci \
  --upstream "${upstream}" \
  --github-commit "${git_commit}" \
  --github-label "${INPUT_LABEL}" \
  "${input_arguments[@]}"
