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

if [[ ${GITHUB_EVENT_BEFORE} == "0000000000000000000000000000000000000000" ]]; then
  # Github will send us all 0s for the before hash in a few circumstances, such as the first commit to a repo
  # or pushing a tag. In these instances we will check the whole repo.
  "${TRUNK_PATH}" check \
    --ci \
    --all \
    --github-commit "${GITHUB_EVENT_AFTER}" \
    "${input_args[@]}"
  exit
fi

if [[ ${GITHUB_REF_NAME} == gh-readonly-queue/* ]]; then
  # If we are running via the GH merge queue then we use HEAD^1 as the commit as github.event.before will be inaccurate.
  head_sha=$(git rev-parse HEAD)
  fetch --depth=2 origin "${head_sha}"
  upstream=$(git rev-parse HEAD^1)
  echo "Detected merge queue commit, using HEAD^1 (${upstream}) as upstream"
fi

if [[ -z ${upstream+x} ]]; then
  # Otherwise use github.event.before as the upstream.
  upstream="${GITHUB_EVENT_BEFORE}"
  fetch origin "${upstream}"
fi

"${TRUNK_PATH}" check \
  --ci \
  --upstream "${upstream}" \
  --github-commit "${GITHUB_EVENT_AFTER}" \
  "${input_args[@]}"
