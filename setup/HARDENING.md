<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is initialized from `${INPUT_TRUNK_PATH}` (line 12), which is set by action.yaml from the untrusted input `${{ inputs.trunk-path }}`. When the user supplies a non-empty value, it flows directly into `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"` on line 25 without the required sanitization step (`printf '%s' "$trunk_path" | tr -d '\n\r'`). An attacker can embed newline characters in the input to inject arbitrary key=value pairs into the runner's environment via GITHUB_ENV.

Locations:

- `locate_trunk.sh:25`
- `action.yaml:20`

### script-injection (severity: high)

Sub-rule (b): In locate_trunk.sh line 27, `trunk_path` is expanded unquoted as a shell command: `${trunk_path} version`. The variable `trunk_path` is sourced from `${INPUT_TRUNK_PATH}` (an attacker-controlled value via `inputs.trunk-path`). Without double-quoting, shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) embedded in the input are interpreted by the shell, enabling command injection. The safe form would be `"${trunk_path}" version`.

Locations:

- `locate_trunk.sh:27`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed both findings in hardened/action/locate_trunk.sh:
1. github-env-injection (line 25): Added sanitization step using `safe_trunk_path=$(printf '%s' "${trunk_path}" | tr -d '\n\r')` before writing to GITHUB_ENV. The sanitized value is now written instead of the raw user-supplied input.
2. script-injection (line 27): Added double-quotes around `${trunk_path}` when used as a command (`"${trunk_path}" version`), preventing shell metacharacters in the user-supplied path from being interpreted by the shell.

