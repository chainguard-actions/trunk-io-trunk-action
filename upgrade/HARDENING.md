<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) violation: Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` inside shell command strings. Any `${{ ... }}` expression interpolated directly inside a `run:` block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it, bypassing shell quoting. Offending lines:
- "Locate trunk" step: `${{ github.action_path }}/../setup/locate_trunk.sh`
- "Detect setup strategy" step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- "Run upgrade" step: `${{ github.action_path }}/upgrade.sh`
- "Cleanup temporary files" step: `${{ github.action_path }}/../cleanup.sh`

Fix: replace each `${{ github.action_path }}` in `run:` blocks with the environment variable `$GITHUB_ACTION_PATH`, which is already set by the runner and does not require template interpolation.

Locations:

- `action.yaml:94`
- `action.yaml:107`
- `action.yaml:116`
- `action.yaml:124`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Replaced all four occurrences of `${{ github.action_path }}` in `run:` blocks within hardened/action/action.yaml with `$GITHUB_ACTION_PATH`. The affected steps were: 'Locate trunk' (locate_trunk.sh), 'Detect setup strategy' (ln -s for setup-env), 'Run upgrade' (upgrade.sh), and 'Cleanup temporary files' (cleanup.sh). Using the runner-provided environment variable $GITHUB_ACTION_PATH instead of template interpolation eliminates the script-injection risk.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed upgrade.sh:
1. script-injection (line 7): Replaced unquoted ${UPGRADE_ARGUMENTS} with xargs-based tokenization into a bash array (upgrade_args), guarded by [ -n ] check to prevent empty-input issues. Array expanded safely with the bash ${arr[@]+"${arr[@]}"} idiom to handle set -u with empty arrays.
2. github-env-injection (lines 44, 51): Sanitized PR_TITLE via 'printf "%s" "${title_message}" | tr -d "\n\r"' before writing to GITHUB_ENV. Changed PR_DESCRIPTION heredoc delimiter from 'EOF' to 'TRUNK_UPGRADE_EOF' to prevent delimiter injection from trunk output content.

