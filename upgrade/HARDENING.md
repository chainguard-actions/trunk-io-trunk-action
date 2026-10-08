<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.2.2** was hardened automatically. 2 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Four `run:` blocks in action.yaml directly interpolate `${{ github.action_path }}` inside shell command strings. Any `${{ ... }}` expression inside a `run:` block is a script-injection risk regardless of context. Offending lines: (1) `${{ github.action_path }}/../setup/locate_trunk.sh` in the 'Locate trunk' step; (2) `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci` in the 'Detect setup strategy' step; (3) `${{ github.action_path }}/upgrade.sh` in the 'Run upgrade' step; (4) `${{ github.action_path }}/../cleanup.sh` in the 'Cleanup temporary files' step. Rule (b): In upgrade.sh line 7, the env var `${UPGRADE_ARGUMENTS}` (sourced from `${{ inputs.arguments }}`, an attacker-controllable input) is expanded unquoted in a shell command: `${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS}`. A shellcheck suppression comment acknowledges this. Unquoted expansion allows shell metacharacter injection.

Locations:

- `action.yaml:90`
- `action.yaml:107`
- `action.yaml:121`
- `action.yaml:130`
- `upgrade.sh:7`

### unpinned-uses (severity: high)

The step 'Create Pull Request' references `peter-evans/create-pull-request@v6`, which uses a mutable version tag instead of a pinned 40-character commit SHA. A tag can be moved to point to a different (potentially malicious) commit, enabling supply-chain attacks. It should be pinned to a full SHA, e.g. `peter-evans/create-pull-request@<40-char-sha> # v6`.

Locations:

- `action.yaml:134`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses

**Notes:**

Fixed all 4 occurrences of ${{ github.action_path }} in action.yaml run: blocks by replacing them with $GITHUB_ACTION_PATH (the standard environment variable). Fixed unquoted ${UPGRADE_ARGUMENTS} expansion in upgrade.sh by using xargs-based tokenization into a bash array (with proper guard for empty value). Pinned peter-evans/create-pull-request@v6 to full SHA c5a7806660adbe173f04e3e038b0ccdcd758773c with the tag preserved as a comment.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed both github-env-injection findings in upgrade.sh:
1. PR_DESCRIPTION (line ~49): Replaced the fixed 'EOF' heredoc terminator with a randomly generated unique marker using `openssl rand -hex 16`, preventing an attacker-controlled 'EOF' line in `description` from terminating the heredoc early and injecting additional GITHUB_ENV entries.
2. PR_TITLE (line ~55): Added sanitization of `title_message` via `printf '%s' "${title_message}" | tr -d '\n\r'` before writing to GITHUB_ENV, preventing embedded newlines from injecting additional key=value pairs into the environment.

