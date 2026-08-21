<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v2.0.0** was hardened automatically. 31 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands. In install/action.yaml, `${{ inputs.tools }}` is interpolated directly into the shell command `trunk tools install --ci ${{ inputs.tools }}`. A caller can supply shell metacharacters via the `tools` input to achieve command injection.

Locations:

- `install/action.yaml:28`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in the 'Set up inputs' step. Multiple caller-controlled inputs are interpolated directly into shell command strings: `echo "INPUT_TIMEOUT_SECONDS=${{ inputs.timeout-seconds }}" >> "${GITHUB_ENV}"`, `if [[ "${{ inputs.check-mode }}" == "payload" ]]`, `INPUT_GITHUB_TOKEN=${{ github.token }}`, and a heredoc writing `GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-${{ runner.os }}-...`, and many more — all without quoting or sanitization.

Locations:

- `action.yaml:112`
- `action.yaml:120`
- `action.yaml:124`
- `action.yaml:131`
- `action.yaml:132`
- `action.yaml:133`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside a run: shell command in the 'Detect setup strategy' step. `${{ github.action_path }}` is interpolated directly into `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`. While github.action_path is GitHub-controlled, any ${{ ... }} inside a run: block is a script-injection risk as it flows through YAML template substitution before the shell sees it.

Locations:

- `action.yaml:175`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in setup-env/action.yaml. Two steps use `${{ steps.*.outcome }}` directly in shell conditionals: (1) 'Check for node installation' step: `if [ ${{ steps.setup_node.outcome }} == "success" ]`; (2) 'Check for package install' step: `if [ ${{ steps.install_packages.outcome }} == "success" ]`. Additionally, the 'Install packages' step uses `run: ${{ env.INSTALL_CMD }}` — the entire run command is a ${{ }} expression.

Locations:

- `setup-env/action.yaml:88`
- `setup-env/action.yaml:107`
- `setup-env/action.yaml:103`

### script-injection (severity: high)

Rule (a): Direct ${{ }} expression interpolation inside run: shell commands in upgrade/action.yaml. Multiple run: blocks use `${{ github.action_path }}` directly in shell commands: (1) 'Locate trunk' step: `${{ github.action_path }}/../setup/locate_trunk.sh`; (2) 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`; (3) 'Run upgrade' step: `${{ github.action_path }}/upgrade.sh`; (4) 'Cleanup temporary files' step: `${{ github.action_path }}/../cleanup.sh`.

Locations:

- `upgrade/action.yaml:72`
- `upgrade/action.yaml:84`
- `upgrade/action.yaml:93`
- `upgrade/action.yaml:101`

### github-env-injection (severity: high)

The 'Set up inputs' run: block in action.yaml writes multiple caller-controlled input values directly to $GITHUB_ENV via a heredoc without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). The heredoc writes values such as `GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-...`, `INPUT_CHECK_MODE=${{ inputs.check-mode }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`, `INPUT_LFS_CHECKOUT=${{ inputs.lfs-checkout }}`, and several `${{ github.event.pull_request.* }}` values — all unsanitized. A newline in any of these values can inject arbitrary environment variables. The `# zizmor: ignore[github-env]` comment suppresses tooling warnings but does not constitute sanitization.

Locations:

- `action.yaml:111`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.timeout-seconds }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:133`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:152`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.github-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:205`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.github-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:206`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:208`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:209`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.github-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:213`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.github-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:214`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:215`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-token }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:216`

### static-inline-injection (severity: high)

shell injection: expression "${{ github.event.pull_request.head.repo.fork }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:218`

### static-inline-injection (severity: high)

shell injection: expression "${{ github.event.pull_request.head.sha }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:219`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.arguments }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:222`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:223`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-key }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:224`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cat-trunk-debug-logs }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:226`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-all-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:227`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.check-mode }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:228`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.debug }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:229`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.label }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:231`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.cache-key }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:232`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.setup-deps }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:233`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.trunk-path }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:236`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.upload-series }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:238`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.lfs-checkout }}" appears directly in run: block of step "Set up inputs"; move to env: map

Locations:

- `action.yml:241`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all script-injection and github-env-injection findings across four files:

1. install/action.yaml: Moved `inputs.tools` to env block, tokenized with xargs into bash array for safe argument passing.

2. action.yaml 'Set up inputs' step: Moved all 20+ ${{ }} expressions to the step's env: block. Replaced heredoc GITHUB_ENV writes with printf+sanitize() (tr -d '\n\r') to prevent newline injection. Also fixed 'Detect setup strategy' step by moving github.action_path to env: ACTION_PATH.

3. setup-env/action.yaml: Moved steps.setup_node.outcome and steps.install_packages.outcome to env: blocks. Replaced `run: ${{ env.INSTALL_CMD }}` with `eval "$INSTALL_CMD"` (INSTALL_CMD is set to known-safe values by the action itself).

4. upgrade/action.yaml: Moved all four github.action_path references from run: blocks to env: ACTION_PATH blocks, using quoted "$ACTION_PATH/..." in shell commands.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in the 'Post-init steps' step of action.yaml. The original code used `bash -c "$POST_INIT"` which executes the POST_INIT env var content as shell code, allowing arbitrary command injection via the `post-init` input. The fix writes the content to a temporary file using `printf '%s\n' "$POST_INIT"` and executes that file with `bash --noprofile --norc -eo pipefail "$_post_init_script"`. This treats the input as a script file rather than as a shell command string, preventing injection while preserving the intended functionality of running user-provided shell commands.

### Iteration 1

**Fixes applied:** script-injection, missing-permissions

**Notes:**

Fixed all 5 findings across 4 workflow files:

1. update_main_version.yaml: Added `permissions: contents: write` (minimum needed to push tags). Fixed script injection on lines 30 and 32 by moving `${{ github.event.inputs.major_version }}` and `${{ github.event.inputs.target }}` into step-level `env:` blocks, referencing them as `$MAJOR_VERSION` and `$TARGET` in the shell commands. Removed the trunk-ignore comments that acknowledged the injection risk.

2. repo_tests.yaml: Fixed `run: ${{ matrix.pre-init }}` (line 148) by writing the script content to a temp file via env var `PRE_INIT` and executing with bash. Fixed the 'Check for task failures' step (line 158) by moving `${{ github.env }}`, `${{ matrix.repo }}`, and `${{ matrix.description }}` to env vars.

3. docker_repo_tests.yaml: Applied the same fixes as repo_tests.yaml for the identical patterns at lines 100 and 113.

4. action_tests.yaml: Fixed 'Craft TEST_GITHUB_EVENT_PATH' step (line 338) by moving `${{ matrix.payload_path }}` and `${{ matrix.description }}` to env vars. Fixed 'Assert CLI calls' step (line 349) by moving `${{matrix.description}}` to an env var and quoting it properly as `"$MATRIX_DESCRIPTION"`.

