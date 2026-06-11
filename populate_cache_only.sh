#!/bin/bash

set -euo pipefail

"${TRUNK_PATH}" install \
  --ci \
  ${INPUT_ARGUMENTS:+"$INPUT_ARGUMENTS"}
