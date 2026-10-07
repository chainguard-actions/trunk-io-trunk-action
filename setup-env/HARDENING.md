<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Check for node installation' run: block directly interpolates a ${{ }} expression inside a shell command string: `if [ ${{ steps.setup_node.outcome }} == "success" ]; then`. Any ${{ ... }} expression inside a run: block is a script-injection risk because YAML template substitution occurs before the shell ever sees the value, bypassing shell quoting.

Locations:

- `action.yaml:118`

### script-injection (severity: high)

Sub-rule (a): The 'Install packages' step uses `run: ${{ env.INSTALL_CMD }}` — the entire shell command is a ${{ }} expression. `env.INSTALL_CMD` is set from $GITHUB_ENV which is workflow-controllable, and the value is substituted by the YAML template engine before the shell executes it, allowing injection of arbitrary shell commands.

Locations:

- `action.yaml:131`

### script-injection (severity: high)

Sub-rule (a): The 'Check for package install' run: block directly interpolates a ${{ }} expression inside a shell command string: `if [ ${{ steps.install_packages.outcome }} == "success" ]; then`. Any ${{ ... }} expression inside a run: block is a script-injection risk because YAML template substitution occurs before the shell ever sees the value, bypassing shell quoting.

Locations:

- `action.yaml:138`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all three script-injection findings in hardened/action/action.yaml:
1. Line 118 ('Check for node installation'): Moved `${{ steps.setup_node.outcome }}` into an `env:` block as `SETUP_NODE_OUTCOME` and referenced it as `"$SETUP_NODE_OUTCOME"` in the shell.
2. Line 131 ('Install packages'): Replaced `run: ${{ env.INSTALL_CMD }}` with `run: eval "$INSTALL_CMD"` — INSTALL_CMD is already available as a shell environment variable (set via GITHUB_ENV), so eval executes it correctly without any template expression in the run block.
3. Line 138 ('Check for package install'): Moved `${{ steps.install_packages.outcome }}` into an `env:` block as `INSTALL_PACKAGES_OUTCOME` and referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell.

### Iteration 2

**Fixes applied:** suspicious-run-content, script-injection

**Notes:**

1. suspicious-run-content (line 148): Replaced `eval "$INSTALL_CMD"` with a `case "$PACKAGE_MANAGER"` statement that directly executes the appropriate package manager command (npm ci / yarn install --immutable / pnpm install --frozen-lockfile). This eliminates the eval-dynamic pattern while preserving identical behavior — INSTALL_CMD was always one of these three literal values anyway. 2. script-injection (line 163): Quoted `${TRUNK_PATH}` as `"${TRUNK_PATH}"` to prevent shell metacharacter injection if TRUNK_PATH contains spaces, semicolons, pipes, or other special characters.

