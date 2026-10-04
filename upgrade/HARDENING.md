<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.2.2** was hardened automatically. 3 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Four run: blocks in action.yaml directly interpolate ${{ github.action_path }} into shell command strings. Although github.action_path is not attacker-controlled, any ${{ ... }} expression interpolated directly inside a run: block is a script-injection finding per the check rules. The affected steps are: 'Locate trunk' (${{ github.action_path }}/../setup/locate_trunk.sh), 'Detect setup strategy' (ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci), 'Run upgrade' (${{ github.action_path }}/upgrade.sh), and 'Cleanup temporary files' (${{ github.action_path }}/../cleanup.sh). These should be replaced with the $GITHUB_ACTION_PATH environment variable instead.

Locations:

- `action.yaml:86`
- `action.yaml:100`
- `action.yaml:111`
- `action.yaml:121`

### unpinned-uses (severity: high)

The step 'Create Pull Request' uses peter-evans/create-pull-request@v6, which is a mutable tag reference rather than a pinned 40-character commit SHA. A supply-chain attacker could push a new commit to the v6 tag and inject malicious code. It should be pinned to a full SHA, e.g. peter-evans/create-pull-request@<40-char-sha> # v6.

Locations:

- `action.yaml:125`

### github-env-injection (severity: high)

In upgrade.sh, two values derived from untrusted input are written to $GITHUB_ENV without the required sanitization step (printf '%s' ... | tr -d '\n\r'). (1) PR_TITLE is set from title_message, which is constructed from trimmed_upgrade_output — the output of running trunk with ${UPGRADE_ARGUMENTS} (an env var set from inputs.arguments, an untrusted caller-controlled input). (2) PR_DESCRIPTION is set from description, which is also derived from the same upgrade output. An attacker who can influence the trunk upgrade output (e.g. via crafted inputs.arguments) could inject newlines to set arbitrary environment variables in subsequent steps. Neither write is preceded by sanitization.

Locations:

- `upgrade.sh:48`
- `upgrade.sh:52`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, github-env-injection

**Notes:**

1. script-injection (action.yaml lines 86, 100, 111, 121): Replaced all four occurrences of ${{ github.action_path }} in run: blocks with $GITHUB_ACTION_PATH environment variable. The paths are now properly quoted with double quotes.
2. unpinned-uses (action.yaml line 125): Pinned peter-evans/create-pull-request@v6 to full commit SHA c5a7806660adbe173f04e3e038b0ccdcd758773c with # v6 comment for readability.
3. github-env-injection (upgrade.sh lines 48, 52): Added sanitization before writing to $GITHUB_ENV. PR_TITLE uses 'printf | tr -d \n\r' to strip all newlines. PR_DESCRIPTION uses 'printf | tr -d \r' to strip carriage returns while preserving intentional newlines needed for the multiline heredoc format.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in upgrade.sh line 7: replaced unquoted `${UPGRADE_ARGUMENTS}` expansion with a proper xargs-based tokenization approach. The fix initializes an empty bash array, guards against empty input, uses `printf '%s' "${UPGRADE_ARGUMENTS}" | xargs printf '%s\0'` with a null-delimited read loop to safely tokenize the argument list (honoring quotes without evaluating shell metacharacters), and expands `"${upgrade_args[@]}"` in the trunk upgrade command. The `trunk-ignore(shellcheck/SC2086)` comment was also removed since it's no longer needed.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed two unquoted ${TRUNK_PATH} expansions in hardened/action/upgrade.sh. Added double quotes around ${TRUNK_PATH} on line 11 (in the upgrade_output command substitution) and line 35 (daemon shutdown call). This prevents shell word-splitting and glob expansion on the TRUNK_PATH value, which could be exploited if the variable contains metacharacters.

