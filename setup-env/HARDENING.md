<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.2.4** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Three `run:` blocks in action.yaml directly interpolate `${{ ... }}` expressions (sub-rule a), allowing template substitution before the shell parses the command:

1. Line 105 (`Check for node installation` step): `if [ ${{ steps.setup_node.outcome }} == "success" ]; then` — `steps.*` context is interpolated directly into the shell command.

2. Line 134 (`Install packages` step): `run: ${{ env.INSTALL_CMD }}` — the entire run command is a `${{ env.* }}` expression; `env.INSTALL_CMD` holds values like `npm ci` or `pnpm install --frozen-lockfile` set earlier, but routing through `env.*` context and interpolating it directly into `run:` is still a script-injection violation.

3. Line 141 (`Check for package install` step): `if [ ${{ steps.install_packages.outcome }} == "success" ]; then` — `steps.*` context is interpolated directly into the shell command.

All three should use environment variables instead of direct `${{ }}` interpolation in `run:` blocks.

Locations:

- `action.yaml:105`
- `action.yaml:134`
- `action.yaml:141`

### unpinned-uses (severity: high)

Four `uses:` references in action.yaml use mutable version tags instead of pinned 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag is moved or overwritten:

- Line 89: `uses: pnpm/action-setup@v2`
- Line 96: `uses: actions/setup-node@v4`
- Line 117: `uses: actions/setup-node@v4`
- Line 123: `uses: actions/cache@v3`

Each should be pinned to a full SHA, e.g. `uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `action.yaml:89`
- `action.yaml:96`
- `action.yaml:117`
- `action.yaml:123`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

Fixed all 4 unpinned `uses:` references by pinning to full commit SHAs (pnpm/action-setup@eae0cfeb..., actions/setup-node@49933ea5... x2, actions/cache@6f8efc29...). Fixed all 3 script-injection findings: (1) `steps.setup_node.outcome` moved to env var SETUP_NODE_OUTCOME; (2) `env.INSTALL_CMD` moved to env var INSTALL_CMD and executed via a temp file with `bash -eo pipefail` to preserve errexit semantics; (3) `steps.install_packages.outcome` moved to env var INSTALL_PACKAGES_OUTCOME.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in action.yaml:
1. (line 140) Replaced the pattern of writing `${{ env.INSTALL_CMD }}` to a temp file and executing it with `bash -eo pipefail` with a safe `case` statement that directly invokes the appropriate package manager command (npm ci / yarn install --immutable / pnpm install --frozen-lockfile) based on the $PACKAGE_MANAGER env var. This eliminates execution of arbitrary workflow-controlled content.
2. (line 161) Quoted `${TRUNK_PATH}` as `"${TRUNK_PATH}"` to prevent word splitting and glob expansion when used as a command, mitigating command injection via shell metacharacters in the path.

