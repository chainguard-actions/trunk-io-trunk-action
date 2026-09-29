<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v2.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is initialized directly from `${INPUT_TRUNK_PATH}`, which is set by the calling workflow via `${{ inputs.trunk-path }}` (a user-controlled input). This value is written unsanitized to `$GITHUB_ENV` on line 24: `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"`. No `printf '%s' ... | tr -d '\n\r'` sanitization is applied before the write. An attacker can supply a newline-containing value for `inputs.trunk-path` to inject arbitrary environment variable assignments into subsequent steps (e.g., overwriting `PATH`, `LD_PRELOAD`, or other sensitive variables). The fix is to sanitize the value before writing: `safe=$(printf '%s' "$trunk_path" | tr -d '\n\r'); echo "TRUNK_PATH=${safe}" >> "${GITHUB_ENV}"`.

Locations:

- `locate_trunk.sh:24`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed locate_trunk.sh line 24: sanitized trunk_path before writing to GITHUB_ENV by adding `safe_trunk_path=$(printf '%s' "${trunk_path}" | tr -d '\n\r')` and using `safe_trunk_path` in the echo statement. This prevents an attacker from injecting arbitrary environment variable assignments via a newline-containing `inputs.trunk-path` value.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed locate_trunk.sh line 28: changed `${trunk_path} version` to `"${trunk_path}" version`. The unquoted variable expansion allowed user-controlled input (from `inputs.trunk-path` via `INPUT_TRUNK_PATH`) containing shell metacharacters to cause unintended command execution. Quoting the variable ensures it is treated as a single argument (the path to the trunk binary) rather than being subject to word splitting and glob expansion.

