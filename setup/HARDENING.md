<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.3.1** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is derived from `INPUT_TRUNK_PATH`, which is set from the user-controlled input `inputs.trunk-path` (via the `env:` block in action.yaml). The value is written to `$GITHUB_ENV` without sanitization: `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"`. An attacker-supplied value containing newline characters could inject arbitrary additional environment variables into the runner environment. The required sanitization step (`printf '%s' "$trunk_path" | tr -d '\n\r'`) is missing before the write.

Locations:

- `locate_trunk.sh:24`
- `action.yaml:20`

### script-injection (severity: high)

Sub-rule (b): In locate_trunk.sh, the variable `${trunk_path}` is expanded unquoted in the command `${trunk_path} version || echo "::warning::${trunk_path} does not exist!"`. Since `trunk_path` can be set directly from the attacker-controlled `INPUT_TRUNK_PATH` (sourced from `inputs.trunk-path`), an unquoted expansion allows the shell to parse metacharacters (`;`, `|`, `&`, `$(...)`, etc.) from the value, enabling command injection. The variable should be quoted: `"${trunk_path}" version || echo "::warning::${trunk_path} does not exist!"`.

Locations:

- `locate_trunk.sh:26`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed both findings in hardened/action/locate_trunk.sh: (1) Added newline sanitization before writing trunk_path to $GITHUB_ENV — introduced `safe_trunk_path` computed via `printf '%s' "${trunk_path}" | tr -d '\n\r'` and used that sanitized value in the echo to $GITHUB_ENV. (2) Fixed unquoted variable expansion by quoting `"${safe_trunk_path}"` in the command execution line, preventing shell metacharacter injection from attacker-controlled INPUT_TRUNK_PATH values.

