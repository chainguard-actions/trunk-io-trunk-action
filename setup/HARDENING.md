<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.2.4** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is derived from `INPUT_TRUNK_PATH`, which is populated from the untrusted `inputs.trunk-path` action input (set via `${{ inputs.trunk-path }}` in action.yaml). This value is written directly to `$GITHUB_ENV` without sanitization: `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"`. An attacker-controlled input containing embedded newlines could inject arbitrary key=value pairs into the runner's environment, potentially overwriting sensitive environment variables for subsequent steps. The required sanitization step (`printf '%s' "$trunk_path" | tr -d '\n\r'`) is missing before the write.

Locations:

- `locate_trunk.sh:22`
- `action.yaml:23`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed github-env-injection in hardened/action/locate_trunk.sh at line 22. Added sanitization of the trunk_path value (derived from INPUT_TRUNK_PATH / inputs.trunk-path) before writing to $GITHUB_ENV. The fix captures the sanitized value in a separate variable `safe_trunk_path` using `printf '%s' "${trunk_path}" | tr -d '\n\r'`, then uses that sanitized value in the echo to $GITHUB_ENV. This prevents an attacker-controlled input containing embedded newlines from injecting arbitrary key=value pairs into the runner's environment.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted variable expansion in locate_trunk.sh line 27: changed `${trunk_path} version` to `"${trunk_path}" version`. The `trunk_path` variable is derived from the workflow-controllable input `INPUT_TRUNK_PATH`, so leaving it unquoted allowed shell metacharacter injection. Quoting the expansion ensures the value is treated as a single path argument rather than being interpreted by the shell.

