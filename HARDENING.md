<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 32 finding(s) were identified and resolved across 5 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ }} expressions are interpolated directly inside run: shell command strings, allowing script injection.

1. `action.yaml` — `run: ${{ inputs.post-init }}` directly executes the caller-controlled `inputs.post-init` value as a shell command. Any workflow calling this action can inject arbitrary shell commands.

2. `action.yaml` — `if [[ "${{ inputs.check-mode }}" == "payload" ]]` interpolates `inputs.check-mode` directly into the shell.

3. `action.yaml` — `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]; then timeout ${{ inputs.timeout-seconds }} ...` interpolates `inputs.timeout-seconds` directly into shell commands (4 occurrences across pull_request, push, all, and trunk_merge steps).

4. `action.yaml` — `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` interpolates `github.action_path` directly into a shell command.

5. `action.yaml` — `cd ${{ env.TRUNK_TMPDIR }} && unzip annotations.zip` interpolates `env.TRUNK_TMPDIR` directly into a shell command.

6. `install/action.yaml` — `trunk tools install --ci ${{ inputs.tools }}` interpolates `inputs.tools` directly into a shell command, allowing argument injection.

7. `upgrade/action.yaml` — `${{ github.action_path }}/../setup/locate_trunk.sh`, `${{ github.action_path }}/upgrade.sh`, and `${{ github.action_path }}/../cleanup.sh` interpolate `github.action_path` directly into run: shell commands (3 occurrences).

8. `setup-env/action.yaml` — `if [ ${{ steps.setup_node.outcome }} == "success" ]` and `if [ ${{ steps.install_packages.outcome }} == "success" ]` interpolate steps context directly into shell commands.

Locations:

- `action.yaml:113`
- `action.yaml:120`
- `action.yaml:196`
- `action.yaml:209`
- `action.yaml:222`
- `action.yaml:233`
- `action.yaml:246`
- `action.yaml:257`
- `action.yaml:270`
- `action.yaml:281`
- `action.yaml:300`
- `action.yaml:316`
- `install/action.yaml:21`
- `upgrade/action.yaml:84`
- `upgrade/action.yaml:103`
- `upgrade/action.yaml:110`
- `setup-env/action.yaml:89`
- `setup-env/action.yaml:130`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes multiple untrusted inputs.* and github.* values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). This allows a caller to inject arbitrary environment variable definitions by embedding newlines in input values.

Affected writes include:
- `GITHUB_TOKEN=${{ github.token }}`
- `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`
- `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`
- `GITHUB_EVENT_PULL_REQUEST_HEAD_SHA=${{ github.event.pull_request.head.sha }}`
- `GITHUB_REF_NAME=${{ github.ref_name }}`
- `INPUT_ARGUMENTS=${{ inputs.arguments }}`
- `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-${{ runner.os }}-...`
- `INPUT_CHECK_MODE=${{ inputs.check-mode }}`
- `INPUT_LABEL=${{ inputs.label }}`
- `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`
- `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`
- `INPUT_LFS_CHECKOUT=${{ inputs.lfs-checkout }}`

All of these are written to $GITHUB_ENV inside a heredoc with no newline sanitization, allowing newline injection to set arbitrary environment variables.

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

Fixed all script-injection and github-env-injection findings across action.yaml, install/action.yaml, upgrade/action.yaml, and setup-env/action.yaml:

1. action.yaml 'Set up inputs': Moved all ${{ inputs.* }} and ${{ github.* }} expressions to env: block; replaced heredoc GITHUB_ENV writes with sanitized echo statements using _s() helper (printf '%s' | tr -d '\n\r'); fixed if [[ "${{ inputs.check-mode }}" ]] to use env var.

2. action.yaml 'Detect setup strategy': Replaced ${{ github.action_path }} with ${GITHUB_ACTION_PATH}.

3. action.yaml 'Post-init steps': Moved ${{ inputs.post-init }} to env: POST_INIT_CMD; runs via bash -eo pipefail to preserve errexit semantics.

4. action.yaml 'Run trunk check on *' (4 steps): Moved ${{ inputs.timeout-seconds }} to env: INPUT_TIMEOUT_SECONDS in each step.

5. action.yaml 'Unpack annotations artifact': Replaced ${{ env.TRUNK_TMPDIR }} with ${TRUNK_TMPDIR}.

6. install/action.yaml 'Trunk install': Moved ${{ inputs.tools }} to env: INPUT_TOOLS; used xargs-based NUL-delimited tokenization into bash array for safe argument passing.

7. upgrade/action.yaml: Replaced all three ${{ github.action_path }} occurrences with ${GITHUB_ACTION_PATH} in Locate trunk, Detect setup strategy, Run upgrade, and Cleanup steps.

8. setup-env/action.yaml: Moved ${{ steps.setup_node.outcome }} and ${{ steps.install_packages.outcome }} to env: blocks (SETUP_NODE_OUTCOME and INSTALL_PACKAGES_OUTCOME respectively).

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

1. setup-env/action.yaml (line 141): Fixed script-injection by moving `${{ env.INSTALL_CMD }}` out of the `run:` command string into the step's `env:` block, then executing via `bash -eo pipefail -c "$INSTALL_CMD"` to preserve errexit semantics.
2. action.yaml (line 163): Fixed github-env-injection by replacing the heredoc that wrote unsanitized `$(payload ...)` values directly to $GITHUB_ENV with individual sanitized writes. Each payload value is captured into `_raw` first, then passed through the existing `_s()` function (which strips newlines/carriage returns via `tr -d '\n\r'`) before being written to $GITHUB_ENV.

### Iteration 3

**Fixes applied:** github-env-injection

**Notes:**

Fixed github-env-injection in hardened/action/setup/locate_trunk.sh (line 26). The `trunk_path` variable (which originates from user-controlled `inputs.trunk-path` via `INPUT_TRUNK_PATH`) was written directly to `$GITHUB_ENV` without sanitization. Fixed by adding `safe_trunk_path="$(printf '%s' "${trunk_path}" | tr -d '\n\r')"` before the echo, and writing `safe_trunk_path` to `$GITHUB_ENV` instead. This prevents newline injection attacks that could overwrite sensitive environment variables in subsequent steps. The fix covers both setup/action.yaml (line 21) and upgrade/action.yaml (~line 40) since both call the same locate_trunk.sh script.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted ${INPUT_ARGUMENTS} and ${UPGRADE_ARGUMENTS} expansions in all 7 affected shell scripts: all.sh, annotate.sh, populate_cache_only.sh, pull_request.sh, push.sh, trunk_merge.sh, and upgrade/upgrade.sh. Each script now tokenizes the arguments variable into a bash array using the xargs-based pattern (with empty-value guard, NUL-delimited read loop, and printf '%s' to handle leading dashes), then expands the array with "${input_args[@]}" / "${upgrade_args[@]}". This prevents shell metacharacter injection while preserving the intended word-splitting behavior for the arguments list input. The # shellcheck disable=SC2086 suppression comments were removed as they are no longer needed. Also fixed the upload_id_arg in all.sh to use separate flag and value variables (avoiding the single-word flag+value trap), and fixed annotation_argument in trunk_merge.sh to use ${annotation_argument:+"${annotation_argument}"} to avoid passing an empty argument.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the 'Download annotations artifact' step in action.yaml. Moved both ${{ github.event.workflow_run.id }} and ${{ env.TRUNK_TMPDIR }} out of the actions/github-script `script:` block and into the step's `env:` block as WORKFLOW_RUN_ID and TRUNK_TMPDIR_ENV. The JavaScript code now references these values via process.env.WORKFLOW_RUN_ID (parsed as integer with parseInt) and process.env.TRUNK_TMPDIR_ENV respectively, eliminating direct expression interpolation into JavaScript source code.

