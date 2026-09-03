<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Three `run:` blocks in action.yaml directly interpolate `${{ ... }}` expressions inside shell commands. YAML template substitution occurs before the shell processes the string, enabling injection.

1. "Check for node installation" step: `if [ ${{ steps.setup_node.outcome }} == "success" ]` — the expression is interpolated directly into a shell `if` test without quoting or env-var indirection.

2. "Install packages" step: `run: ${{ env.INSTALL_CMD }}` — the entire `run:` value is a single expression. `INSTALL_CMD` was set from workspace file content (presence of package-lock.json / yarn.lock / pnpm-lock.yaml), making it attacker-influenced via a malicious PR.

3. "Check for package install" step: `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as finding 1.

Locations:

- `action.yaml:108`
- `action.yaml:132`
- `action.yaml:138`

### github-env-injection (severity: high)

The "Determine pnpm version" step reads PNPM_VERSION from `package.json` content (via `jq -r '.packageManager'`) and writes it to $GITHUB_ENV without sanitization: `echo "PNPM_VERSION=${PNPM_VERSION}" >>$GITHUB_ENV`. In a composite action, the calling workflow controls the workspace, so `package.json` content is untrusted and can contain newlines that inject additional environment variables. The required sanitization step (`printf '%s' "$PNPM_VERSION" | tr -d '\n\r'`) is absent before the write.

Locations:

- `action.yaml:91`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all four issues in hardened/action/action.yaml:

1. github-env-injection (line 91): Added sanitization of PNPM_VERSION before writing to $GITHUB_ENV using `safe_pnpm_version=$(printf '%s' "${PNPM_VERSION}" | tr -d '\n\r')` to strip newlines that could inject additional env vars from attacker-controlled package.json.

2. script-injection (line 108): Moved `${{ steps.setup_node.outcome }}` out of the shell `if` test into an `env:` block as `SETUP_NODE_OUTCOME`, referenced as `"${SETUP_NODE_OUTCOME}"` in the script.

3. script-injection (line 132): Moved `${{ env.INSTALL_CMD }}` (set from workspace lockfile detection, attacker-controlled) into an `env:` block as `INSTALL_CMD`, then safely tokenized it with xargs into a bash array before executing.

4. script-injection (line 138): Moved `${{ steps.install_packages.outcome }}` out of the shell `if` test into an `env:` block as `INSTALL_PACKAGES_OUTCOME`, referenced as `"${INSTALL_PACKAGES_OUTCOME}"` in the script.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted `${TRUNK_PATH}` expansion in the 'Check for package install' step of action.yaml (line 168). Changed `${TRUNK_PATH} check disable eslint stylelint` to `"${TRUNK_PATH}" check disable eslint stylelint` to prevent shell metacharacters in the inherited environment variable from being interpreted as shell commands.

