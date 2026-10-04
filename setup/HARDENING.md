<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.2.2** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

In locate_trunk.sh, the value of INPUT_TRUNK_PATH (sourced from inputs.trunk-path via the env: block in action.yaml) is assigned to the shell variable `trunk_path` and then written directly to $GITHUB_ENV on line 25 (`echo "TRUNK_PATH=${trunk_path}" >> "${GITHUB_ENV}"`) without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). A caller-supplied value containing embedded newlines could inject arbitrary key=value pairs into the runner's environment, potentially overwriting sensitive environment variables used by subsequent steps.

Locations:

- `locate_trunk.sh:25`
- `action.yaml:21`

### script-injection (severity: high)

Rule (b) violation: In locate_trunk.sh line 27, the shell variable `trunk_path` — which is derived from the untrusted input INPUT_TRUNK_PATH (inputs.trunk-path) — is expanded unquoted as a command: `${trunk_path} version`. An unquoted expansion allows the shell to parse metacharacters (spaces, semicolons, pipes, glob characters, etc.) from the attacker-controlled value, enabling command injection. The variable should be quoted: `"${trunk_path}" version`.

Locations:

- `locate_trunk.sh:27`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed both findings in hardened/action/locate_trunk.sh:
1. github-env-injection (line 25): Added sanitization step before writing trunk_path to $GITHUB_ENV. The value is now passed through `printf '%s' "${trunk_path}" | tr -d '\n\r'` to strip embedded newlines/carriage returns before being written as `TRUNK_PATH=${safe_trunk_path}` to $GITHUB_ENV.
2. script-injection (line 27): Quoted the `${trunk_path}` variable when used as a command (`"${trunk_path}" version`) to prevent shell metacharacter injection from attacker-controlled input values.

