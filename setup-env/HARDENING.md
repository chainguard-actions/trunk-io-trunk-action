<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.2.2** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Three `run:` blocks in action.yaml directly interpolate `${{ }}` expressions inside shell commands (sub-rule a), which causes YAML template substitution to occur before the shell parses the command, enabling script injection.

1. (line ~103) `if [ ${{ steps.setup_node.outcome }} == "success" ]; then` — `steps.setup_node.outcome` is interpolated directly into the shell `if` test without quoting or env-var indirection.

2. (line ~126) `run: ${{ env.INSTALL_CMD }}` — the entire run command is a `${{ env.INSTALL_CMD }}` expression; `env.INSTALL_CMD` is a workflow-controllable context value injected directly as a shell command string.

3. (line ~132) `if [ ${{ steps.install_packages.outcome }} == "success" ]; then` — same pattern as finding 1, using `steps.install_packages.outcome`.

All three must be replaced with env-var indirection (move the value into an `env:` block and reference it as a quoted `"$VAR"` in the shell script).

Locations:

- `action.yaml:103`
- `action.yaml:126`
- `action.yaml:132`

### unpinned-uses (severity: high)

Four `uses:` references in action.yaml pin to mutable version tags instead of immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the upstream tag is moved or the repository is compromised:

- `pnpm/action-setup@v2` (line ~87)
- `actions/setup-node@v4` (line ~94, first occurrence)
- `actions/setup-node@v4` (line ~113, second occurrence)
- `actions/cache@v3` (line ~118)

Each should be pinned to a full SHA, e.g. `actions/setup-node@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `action.yaml:87`
- `action.yaml:94`
- `action.yaml:113`
- `action.yaml:118`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

Fixed all 4 unpinned action references by pinning to full commit SHAs (pnpm/action-setup@eae0cfeb..., actions/setup-node@49933ea5..., actions/cache@6f8efc29...). Fixed all 3 script injection issues: moved steps.setup_node.outcome and steps.install_packages.outcome into env: blocks and referenced as quoted shell variables; moved env.INSTALL_CMD into an env: block and executed it safely via a temp file with 'bash -eo pipefail' to preserve errexit behavior.

### Iteration 2

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed two security issues in hardened/action/action.yaml:
1. github-env-injection (line 76): Added sanitization of PNPM_VERSION before writing to $GITHUB_ENV. The jq-derived value is now passed through `printf '%s' ... | tr -d '\n\r'` into a `safe_pnpm_version` variable, which is then written to $GITHUB_ENV instead of the raw value.
2. script-injection (line 163): Quoted `${TRUNK_PATH}` as `"${TRUNK_PATH}"` so it is treated as a single shell word, preventing shell metacharacter injection from an attacker-controlled TRUNK_PATH environment variable.

