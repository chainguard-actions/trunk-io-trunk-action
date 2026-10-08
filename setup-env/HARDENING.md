<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.3.1** was hardened automatically. 1 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Three `run:` blocks in action.yaml directly interpolate `${{ }}` expressions into shell commands, which is a script-injection risk regardless of the context used.

1. `run: ${{ env.INSTALL_CMD }}` — the entire shell command is a `${{ env.INSTALL_CMD }}` expression. If `INSTALL_CMD` is influenced by a calling workflow, an attacker can inject arbitrary shell commands.

2. `if [ ${{ steps.setup_node.outcome }} == "success" ]` — the step outcome expression is interpolated directly into the shell conditional without quoting.

3. `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as above for the install_packages step outcome.

All three should use environment variables instead: set the value in an `env:` block and reference it as a quoted `"$VAR"` in the shell script.

Locations:

- `action.yaml:97`
- `action.yaml:108`
- `action.yaml:120`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all three script injection issues in action.yaml:
1. `run: ${{ env.INSTALL_CMD }}` (line 97): Moved INSTALL_CMD into the step's `env:` block, then wrote it to a temp file and executed with `bash -eo pipefail` to preserve errexit behavior.
2. `if [ ${{ steps.setup_node.outcome }} == "success" ]` (line 108): Moved the step outcome into `env: SETUP_NODE_OUTCOME: ${{ steps.setup_node.outcome }}` and referenced it as `"$SETUP_NODE_OUTCOME"` in the shell script.
3. `if [ ${{ steps.install_packages.outcome }} == "success" ]` (line 120): Moved the step outcome into `env: INSTALL_PACKAGES_OUTCOME: ${{ steps.install_packages.outcome }}` and referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell script.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted `${TRUNK_PATH}` expansion in the 'Check for package install' step of action.yaml (line 157). Changed `${TRUNK_PATH} check disable eslint stylelint` to `"${TRUNK_PATH}" check disable eslint stylelint` to prevent shell metacharacters in the TRUNK_PATH value from being interpreted as shell commands.

