<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.2.4** was hardened automatically. 2 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Three `run:` blocks in action.yaml directly interpolate `${{ }}` expressions into shell command strings (sub-rule a), which causes YAML template substitution to inject the value before the shell ever sees it, enabling command injection.

1. Line 93 — `if [ ${{ steps.setup_node.outcome }} == "success" ]; then` — `steps.*.outputs.*` context interpolated directly in shell.
2. Line 112 — `run: ${{ env.INSTALL_CMD }}` — the entire run command is a `${{ env.* }}` expression; `env.INSTALL_CMD` is set from repository-controlled lock-file detection but still flows through YAML template substitution unsafely.
3. Line 119 — `if [ ${{ steps.install_packages.outcome }} == "success" ]; then` — `steps.*.outputs.*` context interpolated directly in shell.

Fix: use environment variables instead, e.g. `if [ "$OUTCOME" == "success" ]` with `env: OUTCOME: ${{ steps.setup_node.outcome }}`.

Locations:

- `action.yaml:93`
- `action.yaml:112`
- `action.yaml:119`

### unpinned-uses (severity: high)

Four `uses:` references in action.yaml pin to mutable version tags rather than immutable 40-character commit SHAs. A tag can be moved to point to a different (potentially malicious) commit at any time, enabling supply-chain attacks.

Failing references:
- Line 82: `uses: pnpm/action-setup@v2`
- Line 87: `uses: actions/setup-node@v4`
- Line 104: `uses: actions/setup-node@v4`
- Line 107: `uses: actions/cache@v3`

Fix: pin each to a full SHA, e.g. `uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `action.yaml:82`
- `action.yaml:87`
- `action.yaml:104`
- `action.yaml:107`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection

**Notes:**

Fixed all 4 unpinned `uses:` references by pinning to full commit SHAs: pnpm/action-setup@v2 → eae0cfeb286e66ffb5155f1a79b90583a127a68b, actions/setup-node@v4 → 49933ea5288caeca8642d1e84afbd3f7d6820020 (both occurrences), actions/cache@v3 → 6f8efc29b200d32929f49075959781ed54ec270c. Fixed all 3 script-injection issues: (1) `${{ steps.setup_node.outcome }}` moved to env var SETUP_NODE_OUTCOME; (2) `run: ${{ env.INSTALL_CMD }}` moved to env var INSTALL_CMD and referenced as `$INSTALL_CMD`; (3) `${{ steps.install_packages.outcome }}` moved to env var INSTALL_PACKAGES_OUTCOME. All shell comparisons updated to properly quote the env var references.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed two security findings in hardened/action/action.yaml:
1. script-injection (line 131): Quoted `$INSTALL_CMD` in the run command (`run: "$INSTALL_CMD"`) to prevent shell metacharacter injection via unquoted variable expansion.
2. github-env-injection (line 82): Added newline sanitization for PNPM_VERSION before writing to GITHUB_ENV. Captured the raw value first, then used `safe_pnpm_version=$(printf '%s' "${PNPM_VERSION}" | tr -d '\n\r')` and wrote the sanitized value to prevent newline injection attacks via a maliciously crafted package.json.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted ${TRUNK_PATH} expansion in the 'Check for package install' run block in action.yaml. Changed `${TRUNK_PATH} check disable eslint stylelint` to `"${TRUNK_PATH}" check disable eslint stylelint` to prevent shell metacharacters in the TRUNK_PATH value from being interpreted as shell commands.

