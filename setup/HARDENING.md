<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.2.4** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In `locate_trunk.sh`, the variable `trunk_path` is initialized from `INPUT_TRUNK_PATH` (which is set from `inputs.trunk-path` — an attacker-controllable action input) and then written directly to `$GITHUB_ENV` on line 25 without sanitization:

```bash
trunk_path="${INPUT_TRUNK_PATH}"   # line 12: sourced from inputs.trunk-path
...
echo "TRUNK_PATH=${trunk_path}" >>"${GITHUB_ENV}"   # line 25: unsanitized write
```

A caller can supply a value containing embedded newlines (e.g. `foo\nSECRET_TOKEN=injected`) to inject arbitrary key=value pairs into the runner's environment for all subsequent steps. The required sanitization step (`safe=$(printf '%s' "$trunk_path" | tr -d '\n\r')`) is missing before the write.

Locations:

- `locate_trunk.sh:12`
- `locate_trunk.sh:25`
- `action.yaml:19`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed github-env-injection in hardened/action/locate_trunk.sh: added sanitization of trunk_path before writing to $GITHUB_ENV. The value (sourced from INPUT_TRUNK_PATH / inputs.trunk-path, an attacker-controllable input) is now stripped of newlines and carriage returns using `printf '%s' "${trunk_path}" | tr -d '\n\r'` before being written as TRUNK_PATH to $GITHUB_ENV, preventing environment variable injection attacks.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in hardened/action/locate_trunk.sh at line 27. The unquoted `${trunk_path}` command expansion was changed to `"${trunk_path}"` to prevent shell metacharacters in the `inputs.trunk-path` workflow input from being interpreted as shell commands. The value flows from `${{ inputs.trunk-path }}` → `INPUT_TRUNK_PATH` env var → `trunk_path` variable → unquoted command execution. Quoting the expansion prevents arbitrary command execution via attacker-controlled input.

