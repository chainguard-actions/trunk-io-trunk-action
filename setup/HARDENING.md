<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh (called from action.yaml), the variable `trunk_path` is derived from `INPUT_TRUNK_PATH`, which is set from the untrusted user input `${{ inputs.trunk-path }}`. On line 25, this value is written directly to `$GITHUB_ENV` via `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"` without the required sanitization step (`printf '%s' "$trunk_path" | tr -d '\n\r'`). A malicious caller could inject newlines into `inputs.trunk-path` to set arbitrary environment variables in subsequent steps.

Locations:

- `locate_trunk.sh:25`
- `action.yaml:20`

### script-injection (severity: high)

Rule (b) violation: In locate_trunk.sh line 27, the variable `${trunk_path}` — which holds a value sourced from the workflow-controllable `INPUT_TRUNK_PATH` (mapped from `${{ inputs.trunk-path }}`) — is used unquoted in both a command execution position (`${trunk_path} version`) and inside an echo string (`echo "::warning::${trunk_path} does not exist!"`). An unquoted shell variable expansion of untrusted data allows shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) embedded in the input to be interpreted by the shell, enabling command injection. The variable must be double-quoted: `"${trunk_path}" version`.

Locations:

- `locate_trunk.sh:27`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed locate_trunk.sh: (1) Added newline sanitization before writing trunk_path to GITHUB_ENV — captured sanitized value into safe_trunk_path via `printf '%s' "${trunk_path}" | tr -d '\n\r'` in a separate assignment, then wrote safe_trunk_path to GITHUB_ENV. (2) Double-quoted `"${trunk_path}"` in the command execution position to prevent shell metacharacter injection.

