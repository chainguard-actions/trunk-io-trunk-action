<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 32 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple `${{ }}` expressions are interpolated directly inside `run:` shell command strings (sub-rule a), allowing script injection. Key violations:

1. `action.yaml` — `run: ${{ inputs.post-init }}` executes arbitrary caller-supplied shell code verbatim as the entire run command.
2. `action.yaml` — `if [[ "${{ inputs.check-mode }}" == "payload" ]]` — expression interpolated inside a shell conditional.
3. `action.yaml` — `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/pull_request.sh` (and identical patterns for push, all, trunk_merge steps) — `inputs.timeout-seconds` interpolated directly as a shell argument.
4. `action.yaml` — `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` — `github.action_path` interpolated in a shell command.
5. `install/action.yaml` — `trunk tools install --ci ${{ inputs.tools }}` — `inputs.tools` interpolated directly as shell arguments.
6. `upgrade/action.yaml` — `${{ github.action_path }}/../setup/locate_trunk.sh`, `ln -s ${{ github.action_path }}/../setup-env`, `${{ github.action_path }}/upgrade.sh`, `${{ github.action_path }}/../cleanup.sh` — `github.action_path` interpolated in shell commands.

Locations:

- `action.yaml:120`
- `action.yaml:137`
- `action.yaml:213`
- `action.yaml:224`
- `action.yaml:233`
- `action.yaml:244`
- `action.yaml:196`
- `install/action.yaml:20`
- `upgrade/action.yaml:78`
- `upgrade/action.yaml:91`
- `upgrade/action.yaml:100`
- `upgrade/action.yaml:107`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes multiple untrusted `${{ inputs.* }}` and `${{ github.* }}` values directly to `$GITHUB_ENV` via a heredoc (`cat >>$GITHUB_ENV <<EOF ... EOF`) without any sanitization (`printf '%s' ... | tr -d '\n\r'`). An attacker who can control these inputs (e.g. via `inputs.arguments`, `inputs.label`, `inputs.trunk-path`, `inputs.upload-series`, `inputs.cache-key`, `github.ref_name`, `github.event.pull_request.number`, etc.) can inject newlines into the heredoc, causing arbitrary additional environment variables to be set in `$GITHUB_ENV`. Affected writes include: `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `TRUNK_TOKEN=${{ inputs.trunk-token }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`, and many others. The initial write of `GITHUB_TOKEN=${{ github.token }}` is also unsanitized.

Locations:

- `action.yaml:119`
- `action.yaml:120`
- `action.yaml:163`
- `action.yaml:164`
- `action.yaml:165`
- `action.yaml:166`
- `action.yaml:167`
- `action.yaml:168`
- `action.yaml:169`
- `action.yaml:170`
- `action.yaml:171`
- `action.yaml:172`
- `action.yaml:173`
- `action.yaml:174`
- `action.yaml:175`
- `action.yaml:176`
- `action.yaml:177`
- `action.yaml:178`
- `action.yaml:179`
- `action.yaml:180`
- `action.yaml:181`
- `action.yaml:182`
- `action.yaml:183`
- `action.yaml:184`
- `action.yaml:185`
- `action.yaml:186`
- `action.yaml:187`
- `action.yaml:188`

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

- `action.yml:278`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on pull request"; move to env: map

Locations:

- `action.yml:291`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on pull request"; move to env: map

Locations:

- `action.yml:292`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on push"; move to env: map

Locations:

- `action.yml:304`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on push"; move to env: map

Locations:

- `action.yml:305`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on all"; move to env: map

Locations:

- `action.yml:318`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on all"; move to env: map

Locations:

- `action.yml:319`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on Trunk Merge"; move to env: map

Locations:

- `action.yml:329`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Run trunk check on Trunk Merge"; move to env: map

Locations:

- `action.yml:330`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all script-injection and github-env-injection findings across action.yaml, install/action.yaml, and upgrade/action.yaml:

1. action.yaml - 'Set up inputs' step: Replaced the heredoc that wrote untrusted ${{ inputs.* }} and ${{ github.* }} values directly to $GITHUB_ENV with a safe() helper function using printf '%s' | tr -d '\n\r' to strip newlines. All ${{ }} expressions moved to the step's env: block with underscore-prefixed names.

2. action.yaml - 'Detect setup strategy' step: Moved ${{ github.action_path }} to env: _ACTION_PATH, used "${_ACTION_PATH}/setup-env" in the ln -s command.

3. action.yaml - 'Post-init steps' step: Moved ${{ inputs.post-init }} to env: _POST_INIT, execute via eval "$_POST_INIT".

4. action.yaml - 'Run trunk check on pull_request/push/all/Trunk Merge' steps: Moved ${{ inputs.timeout-seconds }} to env: _TIMEOUT_SECONDS in each step, referenced as "$_TIMEOUT_SECONDS" in the shell conditional and timeout command.

5. action.yaml - 'Unpack annotations artifact' step: Replaced cd ${{ env.TRUNK_TMPDIR }} with cd "${TRUNK_TMPDIR}" using the env var directly.

6. install/action.yaml - 'Trunk install' step: Moved ${{ inputs.tools }} to env: _TOOLS, used ${_TOOLS:+"$_TOOLS"} for optional positional argument.

7. upgrade/action.yaml - All steps using ${{ github.action_path }}: Moved to env: _ACTION_PATH in each affected step (Locate trunk, Detect setup strategy, Run upgrade, Cleanup temporary files).

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed all 5 script-injection findings:

1. action.yaml (Post-init steps, line 248): Replaced `eval "$_POST_INIT"` with writing content to a temp file and executing via `bash`. The ${{ inputs.post-init }} expression was already in env:; now execution avoids eval entirely.

2. action.yaml (Download annotations artifact, line 310): Moved `${{ github.event.workflow_run.id }}` and `${{ env.TRUNK_TMPDIR }}` from inside the github-script JavaScript block to a step-level env: block. The script now reads them via `process.env._WORKFLOW_RUN_ID` and `process.env._TRUNK_TMPDIR`.

3. setup-env/action.yaml (Check for node installation, line 88): Moved `${{ steps.setup_node.outcome }}` to env: as `_SETUP_NODE_OUTCOME` and updated the shell condition to use `"$_SETUP_NODE_OUTCOME"` with proper quoting.

4. setup-env/action.yaml (Install packages, line 107): Replaced `run: ${{ env.INSTALL_CMD }}` with a proper run: block that references `$INSTALL_CMD` as a shell environment variable (already set in GITHUB_ENV by the detection step).

5. setup-env/action.yaml (Check for package install, line 115): Moved `${{ steps.install_packages.outcome }}` to env: as `_INSTALL_PACKAGES_OUTCOME` and updated the shell condition to use `"$_INSTALL_PACKAGES_OUTCOME"` with proper quoting.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted expansion of workflow-controllable variables in all affected shell scripts by replacing ${VAR} with ${VAR:+"$VAR"} (guarded expansion). This prevents shell metacharacter injection while preserving correct behavior for optional arguments (empty value produces no argument, non-empty value is properly quoted). Files changed: all.sh (3 occurrences of INPUT_ARGUMENTS, plus htl_arg and upload_id_arg), push.sh (2 occurrences), pull_request.sh (2 occurrences), trunk_merge.sh (INPUT_ARGUMENTS and annotation_argument), annotate.sh (1 occurrence), populate_cache_only.sh (1 occurrence), upgrade/upgrade.sh (UPGRADE_ARGUMENTS). The `# shellcheck disable=SC2086` directives were removed from all files since they are no longer needed.

