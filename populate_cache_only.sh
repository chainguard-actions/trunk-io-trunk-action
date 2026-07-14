#!/bin/bash

set -euo pipefail

# Split INPUT_ARGUMENTS into an array to avoid unquoted word-splitting injection
read -ra arguments_array <<< "${INPUT_ARGUMENTS}"

"${TRUNK_PATH}" install \
  --ci \
  "${arguments_array[@]+"${arguments_array[@]}"}"
