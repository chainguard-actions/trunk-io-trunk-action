<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) violation: Three `run:` blocks in action.yaml directly interpolate `${{ }}` expressions into shell commands, enabling script injection.

1. Step 'Check for node installation' (line ~120): `if [ ${{ steps.setup_node.outcome }} == "success" ]` — the `steps.*` context is interpolated directly into the shell command string before the shell ever sees it.

2. Step 'Install packages' (line ~147): `run: ${{ env.INSTALL_CMD }}` — the entire shell command is an `env.*` expression interpolated directly. A calling workflow that sets `INSTALL_CMD` to a malicious value (e.g., containing shell metacharacters) would achieve arbitrary command execution.

3. Step 'Check for package install' (line ~154): `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as finding 1, `steps.*` context interpolated directly into the shell.

Locations:

- `action.yaml:120`
- `action.yaml:147`
- `action.yaml:154`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed three script injection vulnerabilities in action.yaml:
1. 'Check for node installation' step (~line 120): Moved `${{ steps.setup_node.outcome }}` into an `env:` block as `SETUP_NODE_OUTCOME` and referenced it as `"$SETUP_NODE_OUTCOME"` in the shell script.
2. 'Install packages' step (~line 147): Replaced `run: ${{ env.INSTALL_CMD }}` with `run: $INSTALL_CMD` — INSTALL_CMD is already available as a shell environment variable (written to $GITHUB_ENV in the first step), so no `${{ }}` expression interpolation is needed.
3. 'Check for package install' step (~line 154): Moved `${{ steps.install_packages.outcome }}` into an `env:` block as `INSTALL_PACKAGES_OUTCOME` and referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell script.

