#!/bin/bash

set -euo pipefail

# shellcheck source=git_github.sh
source "${BASH_SOURCE[0]%/*}/git_github.sh"

# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
# quote-aware manner so that shell metacharacters are never evaluated.
input_args=()
if [ -n "${INPUT_ARGUMENTS:-}" ]; then
  while IFS= read -r -d '' t; do input_args+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

if [[ ${INPUT_DEBUG} == "true" ]]; then
  set -x
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
  "${input_args[@]}"
