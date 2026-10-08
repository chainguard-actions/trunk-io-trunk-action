<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.3.1** was hardened automatically. 3 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): ${{ github.action_path }} is interpolated directly inside run: shell command strings in multiple steps of action.yaml. Any ${{ ... }} expression inside a run: block is a script-injection risk because YAML template substitution occurs before the shell ever sees the string. Affected lines include the 'Locate trunk' step (`${{ github.action_path }}/../setup/locate_trunk.sh`), the 'Detect setup strategy' step (`ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`), the 'Run upgrade' step (`${{ github.action_path }}/upgrade.sh`), and the 'Cleanup temporary files' step (`${{ github.action_path }}/../cleanup.sh`). These should be replaced with the $GITHUB_ACTION_PATH environment variable instead.

Locations:

- `action.yaml:108`
- `action.yaml:120`
- `action.yaml:131`
- `action.yaml:138`

### script-injection (severity: high)

Rule (b): In upgrade.sh, the env var ${UPGRADE_ARGUMENTS} (sourced from inputs.arguments via the UPGRADE_ARGUMENTS env var set in action.yaml) is used unquoted in the shell command: `${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS}`. An unquoted expansion allows shell metacharacters (`;`, `|`, `&`, `$(...)`, etc.) embedded in the input to be interpreted by the shell, enabling command injection. It should be quoted: `"${UPGRADE_ARGUMENTS}"` or handled via an array.

Locations:

- `upgrade.sh:7`

### github-env-injection (severity: high)

In upgrade.sh, two values derived from untrusted/external sources are written to $GITHUB_ENV without the required sanitization step (printf '%s' ... | tr -d '\n\r'): (1) `PR_TITLE=${title_message}` — title_message is built from trunk tool output and from ${LOWERCASE_TITLE} (which comes from inputs.lowercase-title set by the calling workflow); (2) `PR_DESCRIPTION<<EOF ... ${description} ... EOF` — description is derived from trunk tool output that incorporates ${UPGRADE_ARGUMENTS} (from inputs.arguments). A newline injected into either value could add arbitrary key=value pairs to the runner's environment, allowing environment variable hijacking.

Locations:

- `upgrade.sh:48`
- `upgrade.sh:52`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed three findings across two files: (1) In action.yaml, replaced all four `${{ github.action_path }}` interpolations in run: blocks with `$GITHUB_ACTION_PATH` environment variable references (Locate trunk, Detect setup strategy, Run upgrade, Cleanup temporary files steps). (2) In upgrade.sh, replaced the unquoted `${UPGRADE_ARGUMENTS}` expansion with xargs-based tokenization into a bash array to safely handle list-style arguments. (3) In upgrade.sh, sanitized PR_TITLE with `printf '%s' ... | tr -d '\n\r'` and PR_DESCRIPTION with `tr -d '\r'` before writing to $GITHUB_ENV to prevent newline injection attacks.

### Iteration 1

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed two security issues in upgrade.sh: (1) Quoted both unquoted ${TRUNK_PATH} expansions (lines 11 and 33) as "${TRUNK_PATH}" to prevent shell metacharacter injection from a caller-controlled env var. (2) Replaced the unsafe heredoc write of PR_DESCRIPTION (vulnerable to premature EOF termination enabling GITHUB_ENV injection) with a sanitized single-line write using `printf '%s' "${description}" | tr -d '\n\r'` before echoing to $GITHUB_ENV.

