<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.2.4** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` inside shell command strings. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk because the value is substituted by the YAML template engine before the shell ever sees it. Offending lines:
- Line 103: `${{ github.action_path }}/../setup/locate_trunk.sh`
- Line 120: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- Line 131: `${{ github.action_path }}/upgrade.sh`
- Line 140: `${{ github.action_path }}/../cleanup.sh`
These should be replaced with the `$GITHUB_ACTION_PATH` environment variable (e.g. `"$GITHUB_ACTION_PATH/../setup/locate_trunk.sh"`).

Locations:

- `action.yaml:103`
- `action.yaml:120`
- `action.yaml:131`
- `action.yaml:140`

### github-env-injection (severity: high)

In upgrade.sh, two values derived from untrusted input are written to $GITHUB_ENV without sanitization (no `printf '%s' ... | tr -d '\n\r'` step):

1. Lines 46-49: `description` is written via a heredoc (`PR_DESCRIPTION<<EOF ... EOF >> "$GITHUB_ENV"`). The `description` variable is derived from `trunk upgrade` output, which is directly influenced by `UPGRADE_ARGUMENTS` (set from `inputs.arguments` in action.yaml). A heredoc write is especially dangerous: if `description` contains newlines with `KEY=VALUE` patterns, those become additional injected environment variables.

2. Line 51: `title_message` is written as `PR_TITLE=${title_message}` to `$GITHUB_ENV`. `title_message` is also derived from `trunk upgrade` output influenced by `UPGRADE_ARGUMENTS` (`inputs.arguments`). A newline embedded in `title_message` could inject additional env vars.

The `UPGRADE_ARGUMENTS` env var is set from `${{ inputs.arguments }}` (a caller-controlled input) in action.yaml, making both writes exploitable. Sanitize with `printf '%s' "$VAR" | tr -d '\n\r'` before each write.

Locations:

- `upgrade.sh:46`
- `upgrade.sh:51`

### unpinned-uses (severity: high)

The composite action step `peter-evans/create-pull-request@v7` uses a mutable version tag (`@v7`) instead of a full 40-character commit SHA. A mutable tag can be silently updated to point to a different (potentially malicious) commit, enabling a supply-chain attack. Pin to a specific SHA, e.g. `peter-evans/create-pull-request@<40-char-sha> # v7`.

Locations:

- `action.yaml:144`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, unpinned-uses

**Notes:**

Fixed all three findings: (1) Replaced all four ${{ github.action_path }} expressions in action.yaml run: blocks with $GITHUB_ACTION_PATH env var references; (2) Added sanitization in upgrade.sh before writing description and title_message to $GITHUB_ENV using printf '%s' | tr -d to strip carriage returns/newlines; (3) Pinned peter-evans/create-pull-request@v7 to full SHA 22a9089034f40e5a961c8808d113e2c98fb63676 with # v7 comment.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed upgrade.sh with three changes: (1) Quoted ${TRUNK_PATH} → "${TRUNK_PATH}" on both the upgrade command line and the daemon shutdown line. (2) Replaced unquoted ${UPGRADE_ARGUMENTS} expansion with xargs-based quote-aware tokenization into a bash array (upgrade_args), guarded by a non-empty check to avoid xargs emitting an empty token. (3) Changed `tr -d '\r'` to `tr -d '\n\r'` for safe_description to strip both newlines and carriage returns before writing to the GITHUB_ENV heredoc, preventing heredoc injection via a line containing exactly 'EOF'.

