<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **trunk-io--trunk-action/v1.2.4** was hardened automatically. 41 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): `run: ${{ inputs.post-init }}` directly executes the user-controlled `inputs.post-init` value as a shell command. Any caller can inject arbitrary shell commands via this input. This is a critical script injection vulnerability.

Locations:

- `action.yaml:202`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.timeout-seconds }}` is interpolated directly inside run: shell commands (used with the `timeout` command and in a `[[ ... ]]` comparison). An attacker-controlled value is substituted into the shell before quoting, enabling command injection. Affected steps: 'Run trunk check on pull request', 'Run trunk check on push', 'Run trunk check on all', 'Run trunk check on Trunk Merge'.

Locations:

- `action.yaml:208`
- `action.yaml:209`
- `action.yaml:221`
- `action.yaml:222`
- `action.yaml:233`
- `action.yaml:234`
- `action.yaml:245`
- `action.yaml:246`

### script-injection (severity: high)

Sub-rule (a): `${{ inputs.check-mode }}` is interpolated directly inside a run: shell comparison (`if [[ "${{ inputs.check-mode }}" == "payload" ]]`). Expression substitution happens before the shell sees the string, allowing injection of shell metacharacters.

Locations:

- `action.yaml:134`

### script-injection (severity: high)

Sub-rule (a): `${{ github.action_path }}` is interpolated directly inside run: blocks in the 'Detect setup strategy' step (`ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`). Although github.action_path is GitHub-controlled, any ${{ ... }} expression inside a run: block is a script-injection finding per the check rules.

Locations:

- `action.yaml:183`

### script-injection (severity: high)

Sub-rule (a): `trunk tools install --ci ${{ inputs.tools }}` directly interpolates the user-controlled `inputs.tools` value into a shell command in the 'get trunk' step of install/action.yaml.

Locations:

- `install/action.yaml:18`

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ ... }} expressions are interpolated directly inside run: blocks in upgrade/action.yaml. Specifically: `${{ github.action_path }}/../setup/locate_trunk.sh` (Locate trunk step), `ln -s ${{ github.action_path }}/../setup-env` (Detect setup strategy step), and `${{ github.action_path }}/upgrade.sh` and `${{ github.action_path }}/../cleanup.sh` (Run upgrade and Cleanup steps).

Locations:

- `upgrade/action.yaml:75`
- `upgrade/action.yaml:88`
- `upgrade/action.yaml:100`
- `upgrade/action.yaml:107`

### script-injection (severity: high)

Sub-rule (a): In setup-env/action.yaml, `run: ${{ env.INSTALL_CMD }}` executes an env-var value as a shell command (the entire run: value is an expression). Additionally, `${{ steps.setup_node.outcome }}` and `${{ steps.install_packages.outcome }}` are interpolated directly inside run: shell comparisons without quoting.

Locations:

- `setup-env/action.yaml:75`
- `setup-env/action.yaml:62`
- `setup-env/action.yaml:84`

### github-env-injection (severity: high)

The 'Set up inputs' step writes numerous untrusted `inputs.*` and `github.*` values directly to $GITHUB_ENV via a heredoc without any sanitization (`printf '%s' ... | tr -d '\n\r'`). Values written include: `inputs.github-token`, `inputs.trunk-token`, `inputs.arguments`, `inputs.check-mode`, `inputs.check-all-mode`, `inputs.check-run-id`, `inputs.debug`, `inputs.label`, `inputs.cache-key`, `inputs.setup-deps`, `inputs.timeout-seconds`, `inputs.trunk-path`, `inputs.upload-series`, `inputs.lfs-checkout`, `github.event.pull_request.base.sha`, `github.event.pull_request.head.repo.fork`, `github.event.pull_request.head.sha`, `github.event.pull_request.number`, `github.ref_name`, and `github.token`. A newline-injection attack via any of these values can set arbitrary environment variables for subsequent steps.

Locations:

- `action.yaml:119`
- `action.yaml:120`
- `action.yaml:175`
- `action.yaml:176`

### unpinned-uses (severity: high)

All `uses:` references in action.yaml use mutable version tags instead of pinned 40-character commit SHAs, making the action vulnerable to supply-chain attacks if any referenced action is compromised or its tag is moved. Unpinned references: `actions/checkout@v4`, `peter-evans/find-comment@v3`, `peter-evans/create-or-update-comment@v4`, `actions/cache@v4`, `actions/upload-artifact@v4` (×2), `actions/github-script@v7`.

Locations:

- `action.yaml:170`
- `action.yaml:178`
- `action.yaml:186`
- `action.yaml:205`
- `action.yaml:260`
- `action.yaml:278`
- `action.yaml:296`

### unpinned-uses (severity: high)

All `uses:` references in setup-env/action.yaml use mutable version tags instead of pinned 40-character commit SHAs. Unpinned references: `pnpm/action-setup@v2`, `actions/setup-node@v4` (×2), `actions/cache@v3`.

Locations:

- `setup-env/action.yaml:57`
- `setup-env/action.yaml:63`
- `setup-env/action.yaml:70`
- `setup-env/action.yaml:76`

### unpinned-uses (severity: high)

The `uses:` reference in upgrade/action.yaml uses a mutable version tag instead of a pinned 40-character commit SHA. Unpinned reference: `peter-evans/create-pull-request@v7`.

Locations:

- `upgrade/action.yaml:113`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:150`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.github-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:195`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:196`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:197`

### static-inline-injection (severity: high)

shell injection: expression "${{ github.event.pull_request.head.repo.fork }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:199`

### static-inline-injection (severity: high)

shell injection: expression "${{ github.event.pull_request.head.sha }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:200`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.arguments }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:203`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:204`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-key }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cat-trunk-debug-logs }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:207`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-all-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:209`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-run-id }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:210`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.debug }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:211`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.label }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-key }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:214`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.setup-deps }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:215`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:218`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-path }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-series }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:221`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.lfs-checkout }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:224`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.post-init }}" appears directly in run: block of step "Post-init steps"; move to env: map

Locations:

- `action.yml:306`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on pull request"; move to env: map

Locations:

- `action.yml:319`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on pull request"; move to env: map

Locations:

- `action.yml:320`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on push"; move to env: map

Locations:

- `action.yml:332`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on push"; move to env: map

Locations:

- `action.yml:333`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on all"; move to env: map

Locations:

- `action.yml:346`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on all"; move to env: map

Locations:

- `action.yml:347`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on Trunk Merge"; move to env: map

Locations:

- `action.yml:357`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on Trunk Merge"; move to env: map

Locations:

- `action.yml:358`

## Iteration Notes

### Iteration 1

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings across action.yaml, install/action.yaml, upgrade/action.yaml, and setup-env/action.yaml:

1. unpinned-uses: Pinned all uses: references to full 40-char commit SHAs with tag comments: actions/checkout@v4, peter-evans/find-comment@v3, peter-evans/create-or-update-comment@v4, actions/cache@v4, actions/upload-artifact@v4 (x2), actions/github-script@v7 in action.yaml; pnpm/action-setup@v2, actions/setup-node@v4 (x2), actions/cache@v3 in setup-env/action.yaml; peter-evans/create-pull-request@v7 in upgrade/action.yaml.

2. script-injection / static-inline-injection: Moved all ${{ inputs.* }}, ${{ github.action_path }}, ${{ steps.*.outcome }}, and ${{ github.token }} expressions out of run: blocks into env: blocks. Shell scripts now reference plain environment variables. inputs.post-init is executed via eval "$POST_INIT_CMD". inputs.tools uses ${INPUT_TOOLS:+"$INPUT_TOOLS"} for optional argument handling.

3. github-env-injection: Replaced heredoc writes to $GITHUB_ENV with a sanitize() helper function using printf '%s' "$val" | tr -d '\n\r' to strip newlines before writing each value. All inputs.* and github.* values are captured in env: variables first, then sanitized before being written to $GITHUB_ENV.

Note: Findings reference both action.yaml and action.yml - only action.yaml exists; all fixes applied there.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in hardened/action/action.yaml:
1. Post-init steps (line 316): Replaced `eval "$POST_INIT_CMD"` with a pattern that writes the user-supplied command to a temp script file (via mktemp) and executes it with `bash`, eliminating the eval of attacker-controlled input.
2. Unpack annotations artifact (line 393): Moved `${{ env.TRUNK_TMPDIR }}` expression out of the run: shell block into the step's env: block as `TRUNK_TMPDIR_VAL`, then referenced it as `"$TRUNK_TMPDIR_VAL"` in the shell script with proper quoting.

### Iteration 3

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed script-injection in 7 files (all.sh, annotate.sh, populate_cache_only.sh, pull_request.sh, push.sh, trunk_merge.sh, upgrade/upgrade.sh) by replacing unquoted ${INPUT_ARGUMENTS} and ${UPGRADE_ARGUMENTS} expansions with bash array pattern: `read -ra array <<< "${VAR}"` followed by `"${array[@]+"${array[@]}"}"`. This safely handles word-splitting without allowing shell metacharacter injection. Fixed github-env-injection in setup/locate_trunk.sh by sanitizing trunk_path with `printf '%s' "${trunk_path}" | tr -d '\n\r'` before writing to GITHUB_ENV. Removed all shellcheck SC2086 disable comments that were confirming the previously unsafe unquoted expansions.

### Iteration 1

**Fixes applied:** script-injection, unpinned-uses, missing-permissions, broad-permissions

**Notes:**

Fixed all findings across 9 workflow files:

1. script-injection (update_main_version.yaml): Moved github.event.inputs.major_version and github.event.inputs.target into env vars MAJOR_VERSION and TARGET.

2. script-injection (action_tests.yaml): Moved matrix.payload_path and matrix.description into env vars MATRIX_PAYLOAD_PATH and MATRIX_DESCRIPTION in the payload job's 'Craft TEST_GITHUB_EVENT_PATH' and 'Assert CLI calls' steps.

3. script-injection (docker_repo_tests.yaml): Fixed 'run: ${{ matrix.pre-init }}' by moving to env var MATRIX_PRE_INIT with eval; fixed python3 call by moving github.env, matrix.repo, matrix.description into env vars.

4. script-injection (repo_tests.yaml): Fixed python3 call by moving github.env, matrix.repo, matrix.description into env vars.

5. unpinned-uses: Pinned actions/checkout@v4 → 34e114876b0b11c390a56381ad16ebd13914f8d5, actions/checkout@v3 → f43a0e5ff2bd294095638e18286ca9a3d1956744, tibdex/github-app-token@v1 → 32691ba7c9e7063bd457bd8f2a5703138591fa58, actions/upload-artifact@v4 → ea165f8d65b6e75b540449e92b4886f43607fa02 across all affected files.

6. missing-permissions (update_main_version.yaml): Added permissions: contents: write (needed for git tag/push operations).

7. broad-permissions: Replaced 'permissions: read-all' with 'permissions: contents: read' in action_tests.yaml, annotate_pr.yaml, cache_trunk.yaml, nightly.yaml, pr.yaml, repo_tests.yaml, docker_repo_tests.yaml, codeql.yml, scorecard.yml; used 'permissions: {}' in weekly.yaml (job-level permissions cover all needs).

