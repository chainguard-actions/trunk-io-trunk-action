<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` inside shell command strings. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted by the Actions template engine before the shell ever sees it, bypassing shell quoting. The safe alternative is to use the `$GITHUB_ACTION_PATH` environment variable instead.

- Line 113: `${{ github.action_path }}/../setup/locate_trunk.sh`
- Line 133: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- Line 146: `${{ github.action_path }}/upgrade.sh`
- Line 156: `${{ github.action_path }}/../cleanup.sh`

Locations:

- `action.yaml:113`
- `action.yaml:133`
- `action.yaml:146`
- `action.yaml:156`

### script-injection (severity: high)

Rule (b): In upgrade.sh line 7, the environment variable `${UPGRADE_ARGUMENTS}` (sourced from `inputs.arguments` via the `env:` block in action.yaml) is expanded **unquoted** inside the shell command:

```
upgrade_output=$(${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS} | sed ...)
```

An unquoted shell expansion allows an attacker-controlled `inputs.arguments` value containing shell metacharacters (`;`, `|`, `&`, `$(...)`, whitespace, glob chars) to be interpreted by the shell, enabling command injection. The fix is to double-quote the expansion: `"${UPGRADE_ARGUMENTS}"`.

Locations:

- `upgrade.sh:7`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all 5 script injection issues:
1. action.yaml line 113: Replaced `${{ github.action_path }}/../setup/locate_trunk.sh` with `"$GITHUB_ACTION_PATH/../setup/locate_trunk.sh"`
2. action.yaml line 133: Replaced `ln -s ${{ github.action_path }}/../setup-env` with `ln -s "$GITHUB_ACTION_PATH/../setup-env"`
3. action.yaml line 146: Replaced `${{ github.action_path }}/upgrade.sh` with `"$GITHUB_ACTION_PATH/upgrade.sh"`
4. action.yaml line 156: Replaced `${{ github.action_path }}/../cleanup.sh` with `"$GITHUB_ACTION_PATH/../cleanup.sh"`
5. upgrade.sh line 7: Replaced unquoted `${UPGRADE_ARGUMENTS}` with a safe xargs-based tokenization into a bash array (`upgrade_args`), using the empty-array-safe expansion `"${upgrade_args[@]+"${upgrade_args[@]}"}"` to handle the case where no arguments are provided. The `if [ -n ... ]` guard prevents xargs from emitting an empty token when the variable is empty.

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all four findings in hardened/action/upgrade.sh:
1. Quoted '${TRUNK_PATH}' in both command positions (lines 11 and 31) → '"${TRUNK_PATH}"' to prevent shell metacharacter injection.
2. Quoted '${LOWERCASE_TITLE}' in the [[ ]] conditional (line 26) → '"${LOWERCASE_TITLE}"'.
3. Replaced the fixed 'EOF' heredoc delimiter for PR_DESCRIPTION with a cryptographically random delimiter ('EOF_$(openssl rand -hex 16)') so attacker-controlled content in the description can never match the delimiter and inject additional GITHUB_ENV entries.
4. Added newline sanitization for PR_TITLE: 'safe_title=$(printf '%s' "${title_message}" | tr -d '\n\r')' before writing to $GITHUB_ENV.

