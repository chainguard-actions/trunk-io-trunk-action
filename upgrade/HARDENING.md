<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 3 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` expressions inside shell command strings. Any `${{ ... }}` expression directly inside a `run:` block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it. Affected steps: 'Locate trunk' (line ~109: `${{ github.action_path }}/../setup/locate_trunk.sh`), 'Detect setup strategy' (line ~122: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`), 'Run upgrade' (line ~133: `${{ github.action_path }}/upgrade.sh`), 'Cleanup temporary files' (line ~141: `${{ github.action_path }}/../cleanup.sh`).

Locations:

- `action.yaml:109`
- `action.yaml:122`
- `action.yaml:133`
- `action.yaml:141`

### script-injection (severity: high)

Sub-rule (b): In upgrade.sh, the env var `${UPGRADE_ARGUMENTS}` (sourced from `inputs.arguments` via `env: UPGRADE_ARGUMENTS: ${{ inputs.arguments }}` in action.yaml) is expanded **unquoted** in the shell command: `${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS}`. An unquoted shell expansion of a caller-controlled value allows word-splitting and glob expansion, enabling command injection. The shellcheck suppression comment (`trunk-ignore(shellcheck/SC2086)`) acknowledges the unquoted expansion but does not mitigate the security risk.

Locations:

- `upgrade.sh:7`
- `action.yaml:135`

### github-env-injection (severity: high)

In upgrade.sh, the variable `${description}` is written to `$GITHUB_ENV` using a heredoc (lines 47-51) without sanitization (`printf '%s' ... | tr -d '\n\r'`). The `description` variable is derived from `${formatted_output}` → `${trimmed_upgrade_output}` → `${upgrade_output}`, which is the output of the trunk upgrade command invoked with the caller-controlled `${UPGRADE_ARGUMENTS}` (from `inputs.arguments`). A malicious caller could craft arguments that cause trunk to emit newlines in its output, enabling injection of arbitrary key=value pairs into `$GITHUB_ENV`. Similarly, `PR_TITLE=${title_message}` is written to `$GITHUB_ENV` (line 53) without sanitization; `title_message` may incorporate `new_cli_version` parsed from tool output that could be influenced by the caller.

Locations:

- `upgrade.sh:47`
- `upgrade.sh:53`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed three findings in action.yaml and upgrade.sh:
1. action.yaml script-injection: Replaced all four `${{ github.action_path }}` expressions in run: blocks (Locate trunk, Detect setup strategy, Run upgrade, Cleanup temporary files) with the `$GITHUB_ACTION_PATH` environment variable, which is set by GitHub Actions and is safe to use in shell scripts.
2. upgrade.sh script-injection: Replaced the unquoted `${UPGRADE_ARGUMENTS}` expansion (which allowed word-splitting and glob expansion) with xargs-based tokenization into a bash array `upgrade_args`, then expanded safely as `"${upgrade_args[@]}"`.
3. upgrade.sh github-env-injection: Added sanitization of `description` (via `tr -d '\r'` to preserve newlines for the heredoc body) and `title_message` (via `tr -d '\n\r'`) before writing to `$GITHUB_ENV`, preventing injection of arbitrary key=value pairs.

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed the heredoc injection vulnerability in upgrade.sh (line 47). The fixed 'EOF' delimiter was replaced with a randomly generated unique delimiter: `_env_delim="EOF_$(dd if=/dev/urandom bs=15 count=1 2>/dev/null | base64 | tr -dc 'A-Za-z0-9' | head -c 20)"`. This makes it cryptographically infeasible for user-controlled trunk upgrade output (influenced by `inputs.arguments`) to contain a line matching the delimiter, preventing premature heredoc termination and injection of additional key=value pairs into $GITHUB_ENV. The `safe_description` variable already strips carriage returns; the random delimiter approach is the standard GitHub-recommended fix for multiline value injection in $GITHUB_ENV.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two instances of unquoted `${TRUNK_PATH}` in hardened/action/upgrade.sh:
1. Line 11: `upgrade_output=$(${TRUNK_PATH} upgrade ...)` → `upgrade_output=$("${TRUNK_PATH}" upgrade ...)`
2. Line 32: `${TRUNK_PATH} daemon shutdown` → `"${TRUNK_PATH}" daemon shutdown`

The `TRUNK_PATH` variable originates from the caller-controlled `inputs.trunk-path` input. Without quoting, shell metacharacters in the value could enable command injection. Wrapping in double quotes ensures the value is treated as a single word by the shell.

