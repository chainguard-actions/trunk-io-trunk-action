<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is derived directly from `INPUT_TRUNK_PATH` (which is set from `inputs.trunk-path` via the `env:` block in action.yaml — a caller-controlled value). When `INPUT_TRUNK_PATH` is non-empty, `trunk_path` is written to `$GITHUB_ENV` without the required sanitization step (`printf '%s' "$trunk_path" | tr -d '\n\r'`). An attacker-controlled input containing embedded newlines could inject arbitrary key=value pairs into the runner's environment, potentially overwriting sensitive variables like `PATH` or `LD_PRELOAD`.

Failing line: `echo "TRUNK_PATH=${trunk_path}" >>"${GITHUB_ENV}"`

Fix: sanitize before writing:
```bash
safe_trunk_path=$(printf '%s' "${trunk_path}" | tr -d '\n\r')
echo "TRUNK_PATH=${safe_trunk_path}" >> "${GITHUB_ENV}"
```

Locations:

- `locate_trunk.sh:25`
- `action.yaml:19`

### script-injection (severity: high)

Rule (b): In locate_trunk.sh line 26, `${trunk_path}` is expanded unquoted in a shell command (`${trunk_path} version`). When `INPUT_TRUNK_PATH` is non-empty, `trunk_path` is set directly from that caller-controlled env var without quoting or sanitization. An attacker-supplied value containing shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) would be interpreted by the shell, enabling command injection.

Failing line: `${trunk_path} version || echo "::warning::${trunk_path} does not exist!"`

Fix: quote the variable: `"${trunk_path}" version || echo "::warning::${trunk_path} does not exist!"`

Locations:

- `locate_trunk.sh:26`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed both findings in hardened/action/locate_trunk.sh:
1. github-env-injection (line 25): Added sanitization step `safe_trunk_path=$(printf '%s' "${trunk_path}" | tr -d '\n\r')` and used `safe_trunk_path` when writing to GITHUB_ENV, preventing newline-based environment injection attacks.
2. script-injection (line 26): Quoted `${trunk_path}` as `"${trunk_path}"` in the shell command invocation, preventing shell metacharacter injection from caller-controlled input.

