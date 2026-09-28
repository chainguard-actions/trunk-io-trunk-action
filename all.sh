#!/bin/bash

set -euo pipefail

if [[ ${INPUT_DEBUG} == "true" ]]; then
  set -x
fi

# Tokenize INPUT_ARGUMENTS (a whitespace-separated list) into an array using
# xargs so that quoted sub-arguments are handled correctly.
input_arguments=()
if [[ -n ${INPUT_ARGUMENTS} ]]; then
  while IFS= read -r -d '' t; do input_arguments+=("$t"); done \
    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
fi

fetch() {
  git -c protocol.version=2 fetch -q \
    --no-tags \
    --no-recurse-submodules \
    "$@"
}

MINIMUM_UPLOAD_ID_VERSION=1.12.3

echo "::warning::Check uploads and check all mode is no longer supported. Please see https://docs.trunk.io/code-quality/setup-and-installation/prevent-new-issues/migration-guide for more information."
if [[ -z ${INPUT_TRUNK_TOKEN} ]]; then
  "${TRUNK_PATH}" check \
    --ci \
    --all \
    --github-commit "${GITHUB_SHA}" \
    "${input_arguments[@]}"
elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
  latest_raw_upload="$(mktemp)"
  prev_ref="$("${TRUNK_PATH}" check get-latest-raw-output \
    --series "${INPUT_UPLOAD_SERIES:-${GITHUB_REF_NAME}}" \
    "${latest_raw_upload}")"
  htl_args=()
  if [[ ${prev_ref} =~ .*"new series".* ]]; then
    echo "${prev_ref}"
  else
    htl_args+=("--htl-factories-path=${latest_raw_upload}")
    fetch origin "${prev_ref}"
  fi
  upload_id_args=()
  if [[ -n ${INPUT_UPLOAD_ID-} ]]; then # if upload ID unset, skip it instead of erroring
    upload_id_args=(--upload-id "${INPUT_UPLOAD_ID}")
    trunk_version="$(${TRUNK_PATH} version)"
    # trunk-ignore-begin(shellcheck/SC2312): the == will fail if anything inside the $() fails
    if sort_result=$(printf "%s\n%s\n" "${MINIMUM_UPLOAD_ID_VERSION}" "${trunk_version}" | sort --version-sort); then
      if [[ $(echo "${sort_result}" | head -n 1) == "${trunk_version}" ]]; then
        echo "::error::Please update your CLI to ${MINIMUM_UPLOAD_ID_VERSION} or higher (current version ${trunk_version})."
        exit 1
      fi
    else
      echo "::warning::sort --version-sort failed - continuing without checking CLI version"
    fi
    # trunk-ignore-end(shellcheck/SC2312)
  fi
  "${TRUNK_PATH}" check \
    --all \
    --upload \
    "${htl_args[@]}" \
    "${upload_id_args[@]}" \
    --series "${INPUT_UPLOAD_SERIES:-${GITHUB_REF_NAME}}" \
    "${input_arguments[@]}"
else
  "${TRUNK_PATH}" check \
    --all \
    --upload \
    --series "${INPUT_UPLOAD_SERIES:-${INPUT_GITHUB_REF_NAME}}" \
    --token "${INPUT_TRUNK_TOKEN}" \
    "${input_arguments[@]}"
fi
