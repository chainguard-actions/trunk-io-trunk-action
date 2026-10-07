<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.2.4** was hardened automatically. 33 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple `uses:` references across action files are pinned to mutable version tags rather than immutable 40-character commit SHAs. This exposes the action to supply-chain attacks if any upstream action is compromised or its tag is moved. Failing references include: action.yaml: actions/checkout@v4, peter-evans/find-comment@v3, peter-evans/create-or-update-comment@v4, actions/cache@v4, actions/github-script@v7, actions/upload-artifact@v4 (×2); setup-env/action.yaml: pnpm/action-setup@v2, actions/setup-node@v4 (×2), actions/cache@v3; upgrade/action.yaml: peter-evans/create-pull-request@v7.

Locations:

- `action.yaml:1`
- `setup-env/action.yaml:1`
- `upgrade/action.yaml:1`

### script-injection (severity: high)

Sub-rule (a): `${{ ... }}` expressions are interpolated directly inside `run:` shell command strings in multiple steps.

1. action.yaml — "Post-init steps" step: `run: ${{ inputs.post-init }}` directly executes arbitrary caller-supplied shell code as a command, allowing full remote code execution.

2. action.yaml — "Set up inputs" step: `if [[ "${{ inputs.check-mode }}" == "payload" ]]` interpolates an input directly into a shell conditional; also `${{ github.token }}` is interpolated into a heredoc shell command.

3. action.yaml — "Run trunk check on pull request/push/all/trunk_merge" steps: `timeout ${{ inputs.timeout-seconds }} ...` interpolates an input directly into a shell command (four occurrences).

4. action.yaml — "Detect setup strategy" step: `ln -s ${{ github.action_path }}/setup-env ...` interpolates a context value directly into a shell command.

5. install/action.yaml — "Trunk install" step: `trunk tools install --ci ${{ inputs.tools }}` interpolates an unquoted input directly into a shell command.

6. setup-env/action.yaml — "Check for node installation" step: `if [ ${{ steps.setup_node.outcome }} == "success" ]` interpolates a steps context value directly into a shell conditional.

7. setup-env/action.yaml — "Check for package install" step: `if [ ${{ steps.install_packages.outcome }} == "success" ]` interpolates a steps context value directly into a shell conditional.

8. setup-env/action.yaml — "Install packages" step: `run: ${{ env.INSTALL_CMD }}` executes an env-derived value directly as a shell command.

9. upgrade/action.yaml — "Locate trunk", "Detect setup strategy", "Run upgrade", "Cleanup" steps: `${{ github.action_path }}` interpolated directly into shell commands (four occurrences).

Locations:

- `action.yaml:120`
- `action.yaml:113`
- `action.yaml:148`
- `action.yaml:160`
- `action.yaml:172`
- `action.yaml:183`
- `action.yaml:130`
- `install/action.yaml:22`
- `setup-env/action.yaml:75`
- `setup-env/action.yaml:100`
- `setup-env/action.yaml:88`
- `upgrade/action.yaml:80`
- `upgrade/action.yaml:95`
- `upgrade/action.yaml:108`
- `upgrade/action.yaml:116`

### github-env-injection (severity: high)

The "Set up inputs" step in action.yaml writes many untrusted `inputs.*` and `github.*` values directly into `$GITHUB_ENV` via a heredoc (`cat >>$GITHUB_ENV <<EOF ... EOF`) without any sanitization (`printf '%s' ... | tr -d '\n\r'`). An attacker who controls any of these inputs can inject newlines to set arbitrary environment variables for subsequent steps. Affected writes include: `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `TRUNK_TOKEN=${{ inputs.trunk-token }}`, `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`, `GITHUB_EVENT_PULL_REQUEST_HEAD_SHA=${{ github.event.pull_request.head.sha }}`, `GITHUB_EVENT_PULL_REQUEST_NUMBER=${{ github.event.pull_request.number }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-...`, `INPUT_CHECK_MODE=${{ inputs.check-mode }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`, `INPUT_LFS_CHECKOUT=${{ inputs.lfs-checkout }}`, and others — all without newline sanitization.

Locations:

- `action.yaml:113`

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

Fixed all findings across action.yaml, setup-env/action.yaml, upgrade/action.yaml, and install/action.yaml:

1. **unpinned-uses**: Pinned all 10 action references to full SHA commits: actions/checkout@v4→11d5960a, peter-evans/find-comment@v3→3eae4d3, peter-evans/create-or-update-comment@v4→71345be, actions/cache@v4→0057852, actions/github-script@v7→f28e40c, actions/upload-artifact@v4→ea165f8 (×2), pnpm/action-setup@v2→eae0cfe, actions/setup-node@v4→49933ea (×2), actions/cache@v3→6f8efc2, peter-evans/create-pull-request@v7→22a9089.

2. **script-injection**: Moved all ${{ }} expressions from run: blocks to env: blocks. Key changes: inputs.post-init→POST_INIT_CMD (used with eval), inputs.timeout-seconds→INPUT_TIMEOUT_SECONDS (×4 steps), github.action_path→ACTION_PATH (upgrade.yaml ×4, action.yaml ×1), inputs.tools→INPUT_TOOLS with xargs tokenization, steps.setup_node.outcome→SETUP_NODE_OUTCOME, steps.install_packages.outcome→INSTALL_PACKAGES_OUTCOME, env.INSTALL_CMD→$INSTALL_CMD (direct env var reference), all inputs in 'Set up inputs' step moved to env: block.

3. **github-env-injection**: Replaced heredoc writes to $GITHUB_ENV with individual printf statements using a safe() function (printf '%s' "$val" | tr -d '\n\r') to strip newlines before writing, preventing newline injection. All ${{ }} expressions in the 'Set up inputs' step moved to env: block first.

4. **static-inline-injection**: All specific inline injection findings resolved as part of the script-injection fixes.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in hardened/action/action.yaml:
1. 'Unpack annotations artifact' step: Moved `${{ env.TRUNK_TMPDIR }}` from the `run:` block into an `env:` block as `TRUNK_TMPDIR_PATH`, and updated the shell command to use `"$TRUNK_TMPDIR_PATH"` (properly quoted).
2. 'Post-init steps' step: Replaced `eval "$POST_INIT_CMD"` with a safer pattern that writes the command to a temp file via `printf '%s\n' "$POST_INIT_CMD" > "$_post_init_script"` and executes it with `bash "$_post_init_script"`, avoiding the use of `eval` with caller-controlled input. The `${{ inputs.post-init }}` expression remains in the `env:` block.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in the 'Download annotations artifact' step of action.yaml. Two ${{ }} expressions were directly interpolated into the JavaScript `script:` block of the `actions/github-script` step: (1) `run_id: ${{ github.event.workflow_run.id }}` and (2) `fs.writeFileSync('${{ env.TRUNK_TMPDIR }}/annotations.zip', ...)`. Both were moved to an `env:` block on the step (`WORKFLOW_RUN_ID` and `TRUNK_TMPDIR_PATH`), and the JavaScript code was updated to reference them via `process.env.WORKFLOW_RUN_ID` (wrapped in `parseInt(..., 10)` for type safety) and `process.env.TRUNK_TMPDIR_PATH + '/annotations.zip'` respectively.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted expansion of INPUT_ARGUMENTS and UPGRADE_ARGUMENTS in all 7 affected shell scripts (all.sh, annotate.sh, populate_cache_only.sh, pull_request.sh, push.sh, trunk_merge.sh, upgrade/upgrade.sh). Each script now tokenizes the arguments string into a bash array using xargs (quote-aware tokenization) with a guard for empty values, then expands the array safely. Also converted htl_arg/upload_id_arg in all.sh and annotation_argument in trunk_merge.sh from unquoted string variables to proper arrays. Removed all # shellcheck disable=SC2086 comments that were acknowledging the intentional unquoted expansions.

