<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Three `run:` blocks in action.yaml directly interpolate `${{ ... }}` expressions inside shell command strings.

1. "Check for node installation" step: `if [ ${{ steps.setup_node.outcome }} == "success" ]` — `steps.*.outcome` flows through YAML template substitution before the shell sees it.

2. "Install packages" step: `run: ${{ env.INSTALL_CMD }}` — the entire shell command is a `${{ env.INSTALL_CMD }}` expression; `env.*` is a workflow-controllable context and must not be interpolated directly into a `run:` block.

3. "Check for package install" step: `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as finding #1.

All three should be moved to `env:` variables and referenced as quoted shell variables (e.g. `"$STEPS_OUTCOME"`, `"$INSTALL_CMD"`).

Locations:

- `action.yaml:113`
- `action.yaml:131`
- `action.yaml:137`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all three script injection findings in action.yaml:
1. 'Check for node installation' step: Moved `${{ steps.setup_node.outcome }}` into an `env:` block as `SETUP_NODE_OUTCOME` and referenced it as `"$SETUP_NODE_OUTCOME"` in the shell script.
2. 'Install packages' step: Moved `${{ env.INSTALL_CMD }}` into an `env:` block as `INSTALL_CMD` and changed `run:` to use `$INSTALL_CMD` (unquoted to preserve word splitting for multi-word commands like `npm ci`, `yarn install --immutable`, `pnpm install --frozen-lockfile`).
3. 'Check for package install' step: Moved `${{ steps.install_packages.outcome }}` into an `env:` block as `INSTALL_PACKAGES_OUTCOME` and referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell script.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script injection vulnerabilities in hardened/action/action.yaml:
1. Line 147: Replaced `run: $INSTALL_CMD` (where INSTALL_CMD came from the workflow-controllable `${{ env.INSTALL_CMD }}`) with a safe `case` statement that dispatches on `$PACKAGE_MANAGER` to run the appropriate hardcoded install command (npm ci / yarn install --immutable / pnpm install --frozen-lockfile). This eliminates the arbitrary command execution vector.
2. Line 163: Quoted `${TRUNK_PATH}` as `"${TRUNK_PATH}"` to prevent word splitting and path injection when using it as a command prefix.

### Iteration 3

**Fixes applied:** github-env-injection

**Notes:**

Fixed the github-env-injection finding in the 'Determine pnpm version' step of hardened/action/action.yaml. The PNPM_VERSION variable (derived from the attacker-controlled package.json via jq) is now sanitized before being written to $GITHUB_ENV. Added `safe_pnpm_version=$(printf '%s' "${PNPM_VERSION}" | tr -d '\n\r')` and changed the echo to use the sanitized variable, preventing newline injection attacks that could add arbitrary key=value pairs to the runner's environment.

