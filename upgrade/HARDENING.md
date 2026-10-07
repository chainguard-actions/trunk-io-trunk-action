<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.2.4** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` inside shell command strings. Per the script-injection check, ANY `${{ ... }}` expression inside a `run:` block is a finding, regardless of which context it reads from. The affected steps are:
- "Locate trunk" step: `${{ github.action_path }}/../setup/locate_trunk.sh`
- "Detect setup strategy" step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`
- "Run upgrade" step: `${{ github.action_path }}/upgrade.sh`
- "Cleanup temporary files" step: `${{ github.action_path }}/../cleanup.sh`
Fix: use the `$GITHUB_ACTION_PATH` environment variable instead (e.g. `"$GITHUB_ACTION_PATH"/../setup/locate_trunk.sh`).

Locations:

- `action.yaml:103`
- `action.yaml:121`
- `action.yaml:131`
- `action.yaml:141`

### unpinned-uses (severity: high)

The step `peter-evans/create-pull-request@v7` uses a mutable tag reference (`@v7`) instead of a full 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit, enabling a supply-chain attack. Pin to a specific SHA, e.g. `peter-evans/create-pull-request@<40-char-sha> # v7`.

Locations:

- `action.yaml:146`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

Fixed four script-injection instances by replacing `${{ github.action_path }}` with `"$GITHUB_ACTION_PATH"` in the run: blocks of: 'Locate trunk', 'Detect setup strategy', 'Run upgrade', and 'Cleanup temporary files' steps. Pinned `peter-evans/create-pull-request@v7` to full SHA `22a9089034f40e5a961c8808d113e2c98fb63676` with the tag preserved as a comment.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed both findings in hardened/action/upgrade.sh:

1. script-injection: Replaced unquoted `${UPGRADE_ARGUMENTS}` expansion with xargs-based array tokenization. Added an empty-guard (`if [ -n "${UPGRADE_ARGUMENTS}" ]`) and used `while IFS= read -r -d '' t; do upgrade_args+=("$t"); done < <(printf '%s' "${UPGRADE_ARGUMENTS}" | xargs printf '%s\0')` to safely tokenize the user-controlled arguments list into a bash array. The array is then expanded as `"${upgrade_args[@]}"` — preventing shell metacharacter injection.

2. github-env-injection: (a) `title_message` is now sanitized with `printf '%s' "${title_message}" | tr -d '\n\r'` before being written as `PR_TITLE=...` to GITHUB_ENV. (b) The `description` heredoc now uses a unique random delimiter `TRUNK_UPGRADE_EOF_$$_${RANDOM}` instead of the static `EOF` to prevent early heredoc termination via injected lines, and strips carriage returns with `tr -d '\r'`.

