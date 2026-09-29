<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 1 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Three `${{ }}` expressions are interpolated directly inside `run:` shell command strings, allowing template substitution before the shell ever sees the value:

1. Line 110: `if [ ${{ steps.setup_node.outcome }} == "success" ]` — `steps.*.outcome` is a workflow-controllable context value injected directly into a shell `if` test without quoting or env-var indirection.

2. Line 137: `run: ${{ env.INSTALL_CMD }}` — the entire shell command is the `env.INSTALL_CMD` expression. Although `INSTALL_CMD` is set to a literal string earlier in the same composite action, the `env.*` context is workflow-controllable (a calling workflow can override it), so this is a direct expression injection into the run command.

3. Line 144: `if [ ${{ steps.install_packages.outcome }} == "success" ]` — same pattern as finding #1 with `steps.install_packages.outcome`.

Sub-rule (b): Line ~155: `${TRUNK_PATH} check disable eslint stylelint` — `TRUNK_PATH` is an inherited process env var (set by the calling workflow, never assigned in this run block) and is used unquoted as the command prefix, allowing shell metacharacter injection if the calling workflow sets it to a malicious value.

Locations:

- `action.yaml:110`
- `action.yaml:137`
- `action.yaml:144`
- `action.yaml:155`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all four script-injection findings in action.yaml:
1. Line 110: Moved `${{ steps.setup_node.outcome }}` into an `env:` block as `SETUP_NODE_OUTCOME` and referenced it as `"$SETUP_NODE_OUTCOME"` in the shell `if` test.
2. Line 137: Replaced `run: ${{ env.INSTALL_CMD }}` with `run: $INSTALL_CMD` — INSTALL_CMD is already exported to GITHUB_ENV by the first step, so it's available as a process env var without template expression injection.
3. Line 144: Moved `${{ steps.install_packages.outcome }}` into an `env:` block as `INSTALL_PACKAGES_OUTCOME` and referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell `if` test.
4. Line ~155: Quoted `${TRUNK_PATH}` as `"$TRUNK_PATH"` to prevent shell metacharacter injection from a caller-controlled environment variable.

