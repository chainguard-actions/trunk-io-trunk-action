<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.2.2** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the variable `trunk_path` is populated directly from `INPUT_TRUNK_PATH`, which is set to `${{ inputs.trunk-path }}` (an attacker-controlled input). When the input is non-empty, `trunk_path` is written to `$GITHUB_ENV` without sanitization: `echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"`. An attacker can supply a value containing newline characters (e.g. `foo\nSECRET_VAR=injected`) to inject arbitrary environment variables into subsequent steps. The required sanitization step (`safe=$(printf '%s' "$trunk_path" | tr -d '\n\r')`) is missing before the write.

Locations:

- `locate_trunk.sh:22`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed locate_trunk.sh: sanitized `trunk_path` before writing to $GITHUB_ENV by adding `safe_trunk_path="$(printf '%s' "${trunk_path}" | tr -d '\n\r')"` and using `safe_trunk_path` in the echo statement. This prevents newline injection via the `inputs.trunk-path` input.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted command expansion in locate_trunk.sh line 27: changed `${trunk_path} version` to `"${trunk_path}" version`. The variable `trunk_path` is derived from `INPUT_TRUNK_PATH` (which comes from the workflow-controllable `inputs.trunk-path`), so an attacker-controlled value containing shell metacharacters could have caused arbitrary command injection. Quoting the expansion prevents the shell from interpreting metacharacters in the value.

