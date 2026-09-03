<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): `${{ github.action_path }}` is interpolated directly inside `run:` shell command strings in multiple steps of action.yaml. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted into the shell command string before the shell parses it. Affected lines:
- "Locate trunk" step: `${{ github.action_path }}/../setup/locate_trunk.sh`
- "Detect setup strategy" step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- "Run upgrade" step: `${{ github.action_path }}/upgrade.sh`
- "Cleanup temporary files" step: `${{ github.action_path }}/../cleanup.sh`

Locations:

- `action.yaml:96`
- `action.yaml:108`
- `action.yaml:119`
- `action.yaml:127`

### github-env-injection (severity: high)

upgrade.sh writes values derived from caller-controlled (untrusted) env vars to `$GITHUB_ENV` without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). Specifically:
1. `${description}` — derived from `${trimmed_upgrade_output}` which is processed from `${UPGRADE_ARGUMENTS}` (set by the calling workflow via `inputs.arguments`) — is written to `$GITHUB_ENV` using a heredoc (`PR_DESCRIPTION<<EOF ... EOF`). A newline in the value can break the heredoc delimiter and inject arbitrary env vars.
2. `${title_message}` — influenced by `${LOWERCASE_TITLE}` (set from `inputs.lowercase-title`) — is written as `PR_TITLE=${title_message}` to `$GITHUB_ENV` without sanitization. A newline in the value can inject additional environment variables.
Neither write is preceded by the required `printf '%s' "$VAR" | tr -d '\n\r'` sanitization.

Locations:

- `upgrade.sh:47`
- `upgrade.sh:51`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed script-injection in action.yaml by moving all 4 occurrences of `${{ github.action_path }}` from run: shell strings into env: blocks (as ACTION_PATH), then referencing them as quoted shell variables. Fixed github-env-injection in upgrade.sh by: (1) sanitizing title_message with `printf '%s' | tr -d '\n\r'` before writing PR_TITLE to GITHUB_ENV, and (2) using a cryptographically random heredoc delimiter for PR_DESCRIPTION to prevent an attacker-controlled description value from matching the delimiter and injecting additional environment variables.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed upgrade.sh:
1. Line 7: Double-quoted `${TRUNK_PATH}` → `"${TRUNK_PATH}"`. Replaced unquoted `${UPGRADE_ARGUMENTS}` with a safe xargs-based tokenization into a bash array (`upgrade_args`), then expanded as `"${upgrade_args[@]}"`. This prevents shell metacharacter injection while correctly handling the multi-argument nature of the `arguments` input.
2. Line 30: Double-quoted `${TRUNK_PATH}` → `"${TRUNK_PATH}"` in the `daemon shutdown` call.
The script uses `#!/bin/bash`, so bash arrays and process substitution (`< <(...)`) are valid.

