<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` into shell command strings. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted by the Actions template engine before the shell ever sees it, bypassing shell quoting. Offending lines:
- Line 109: `${{ github.action_path }}/../setup/locate_trunk.sh`
- Line 121: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- Line 133: `${{ github.action_path }}/upgrade.sh`
- Line 141: `${{ github.action_path }}/../cleanup.sh`
Fix: use the `$GITHUB_ACTION_PATH` environment variable instead (e.g. `"$GITHUB_ACTION_PATH/../setup/locate_trunk.sh"`).

Locations:

- `action.yaml:109`
- `action.yaml:121`
- `action.yaml:133`
- `action.yaml:141`

### script-injection (severity: high)

Rule (b): In upgrade.sh, the env vars `${UPGRADE_ARGUMENTS}` (line 7) and `${LOWERCASE_TITLE}` (line 25) are expanded unquoted in shell. Both are sourced from workflow inputs (`inputs.arguments` and `inputs.lowercase-title` respectively, set via the `env:` block of the 'Run upgrade' step in action.yaml). Unquoted expansion of workflow-controllable data allows shell metacharacter injection (`;`, `|`, `&`, `$(...)`, etc.).
- Line 7: `${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS} | sed ...` — `UPGRADE_ARGUMENTS` is unquoted
- Line 25: `if [[ ${LOWERCASE_TITLE} == "true" ]]; then` — `LOWERCASE_TITLE` is unquoted
Fix: quote all expansions: `"${UPGRADE_ARGUMENTS}"` and `"${LOWERCASE_TITLE}"`.

Locations:

- `upgrade.sh:7`
- `upgrade.sh:25`

### github-env-injection (severity: high)

In upgrade.sh, the variable `title_message` (which may incorporate `new_cli_version` parsed from tool output influenced by the caller-controlled `UPGRADE_ARGUMENTS` input) and `description` (derived from the full upgrade output) are written unsanitized to `$GITHUB_ENV` without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline embedded in either value would allow injection of arbitrary environment variables into subsequent steps.
- Lines 40-43: `PR_DESCRIPTION` written via heredoc using `${description}` with no newline sanitization
- Line 44: `echo "PR_TITLE=${title_message}" >> "${GITHUB_ENV}"` with no newline sanitization
Fix: sanitize both values with `printf '%s' "$var" | tr -d '\n\r'` before writing to `$GITHUB_ENV`.

Locations:

- `upgrade.sh:40`
- `upgrade.sh:44`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed three findings across two files:

1. action.yaml (script-injection): Replaced all 4 occurrences of `${{ github.action_path }}` in run: blocks with `$GITHUB_ACTION_PATH` environment variable, preventing template-engine injection before shell execution.

2. upgrade.sh (script-injection): 
   - UPGRADE_ARGUMENTS (an args-style list input) is now tokenized via xargs into a bash array and expanded safely, preserving argument boundaries while preventing shell metacharacter injection.
   - LOWERCASE_TITLE is now quoted as "${LOWERCASE_TITLE}" in the [[ ]] test.

3. upgrade.sh (github-env-injection): Added sanitization of title_message and description before writing to $GITHUB_ENV using printf + tr -d to strip newlines/carriage returns, preventing injection of arbitrary environment variables via embedded newlines.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two instances of unquoted `${TRUNK_PATH}` in command position in hardened/action/upgrade.sh:
- Line 11: `upgrade_output=$(${TRUNK_PATH} upgrade ...)` → `upgrade_output=$("${TRUNK_PATH}" upgrade ...)`
- Line 33: `${TRUNK_PATH} daemon shutdown` → `"${TRUNK_PATH}" daemon shutdown`

Quoting the variable prevents shell metacharacter injection if TRUNK_PATH contains special characters.

