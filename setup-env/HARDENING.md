<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.2.2** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Three `run:` blocks directly interpolate `${{ }}` expressions into shell command strings, enabling script injection. (1) Line 105: `if [ ${{ steps.setup_node.outcome }} == "success" ]` — the `steps.*` context value is substituted into the shell before quoting. (2) Line 132: `run: ${{ env.INSTALL_CMD }}` — the entire run command is an `env.*` expression, meaning a workflow-controlled env var is executed as a shell command verbatim. (3) Line 139: `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as (1). All three must be replaced with env-var indirection and proper quoting (e.g., `if [ "$STEP_OUTCOME" == "success" ]` with the value passed via `env:`).

Locations:

- `action.yaml:105`
- `action.yaml:132`
- `action.yaml:139`

### github-env-injection (severity: high)

The 'Determine pnpm version' step reads `PNPM_VERSION` from `package.json` via `jq` (a repository file that is attacker-controllable in pull-request scenarios) and writes it unsanitized to `$GITHUB_ENV` with `echo "PNPM_VERSION=${PNPM_VERSION}" >>$GITHUB_ENV`. A malicious `package.json` could inject newlines into `$GITHUB_ENV` to set arbitrary environment variables for subsequent steps. The value must be sanitized before the write: `safe=$(printf '%s' "$PNPM_VERSION" | tr -d '\n\r')` followed by `echo "PNPM_VERSION=$safe" >>"$GITHUB_ENV"`.

Locations:

- `action.yaml:85`

### unpinned-uses (severity: high)

Four `uses:` references in action.yaml pin to mutable version tags instead of immutable 40-character commit SHA digests, making the action vulnerable to supply-chain attacks if the upstream tag is moved or compromised: (1) `pnpm/action-setup@v2` (line 89); (2) `actions/setup-node@v4` (line 96); (3) `actions/setup-node@v4` (line 115); (4) `actions/cache@v3` (line 121). Each should be replaced with the full SHA, e.g. `actions/setup-node@11bd71901bbe5b1630ceea73d27597364c9af683 # v4`.

Locations:

- `action.yaml:89`
- `action.yaml:96`
- `action.yaml:115`
- `action.yaml:121`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, unpinned-uses, script-injection

**Notes:**

Fixed all three findings in action.yaml: (1) github-env-injection: sanitized PNPM_VERSION with tr -d '\n\r' before writing to GITHUB_ENV; (2) unpinned-uses: pinned pnpm/action-setup@v2, actions/setup-node@v4 (×2), and actions/cache@v3 to full commit SHAs using lookup_action_sha; (3) script-injection: moved steps.setup_node.outcome (line 105) and steps.install_packages.outcome (line 139) into env: blocks with proper quoting, and moved env.INSTALL_CMD (line 132) into an env: block executed via eval "$INSTALL_CMD".

