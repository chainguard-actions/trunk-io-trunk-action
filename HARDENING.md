<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.2.4** was hardened automatically. 33 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are interpolated directly inside run: shell command strings across several action files, violating sub-rule (a). This allows an attacker to inject arbitrary shell commands.

1. action.yaml — `run: ${{ inputs.post-init }}` directly executes user-controlled input as a shell command.
2. action.yaml — `if [[ "${{ inputs.check-mode }}" == "payload" ]]` interpolates inputs directly in shell.
3. action.yaml — `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/pull_request.sh` (and identical patterns for push.sh, all.sh, trunk_merge.sh) — inputs.timeout-seconds interpolated directly in shell command.
4. action.yaml — `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` — github context interpolated in shell.
5. install/action.yaml — `run: trunk tools install --ci ${{ inputs.tools }}` — inputs.tools interpolated directly in shell command.
6. setup-env/action.yaml — `run: ${{ env.INSTALL_CMD }}` — env context used as the entire shell command.
7. upgrade/action.yaml — `${{ github.action_path }}/../setup/locate_trunk.sh`, `${{ github.action_path }}/upgrade.sh`, `ln -s ${{ github.action_path }}/../setup-env`, `${{ github.action_path }}/../cleanup.sh` — github.action_path interpolated directly in shell run blocks.

Locations:

- `action.yaml:113`
- `action.yaml:121`
- `action.yaml:148`
- `action.yaml:168`
- `action.yaml:178`
- `action.yaml:188`
- `action.yaml:198`
- `install/action.yaml:22`
- `setup-env/action.yaml:72`
- `upgrade/action.yaml:75`
- `upgrade/action.yaml:87`
- `upgrade/action.yaml:93`
- `upgrade/action.yaml:100`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes numerous untrusted input and github context values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). An attacker can inject newlines into any of these values to set arbitrary environment variables. Affected writes include: `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `TRUNK_TOKEN=${{ inputs.trunk-token }}`, `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-...`, `INPUT_CHECK_MODE=${{ inputs.check-mode }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`, `INPUT_LFS_CHECKOUT=${{ inputs.lfs-checkout }}`, and many more — all written to $GITHUB_ENV without sanitization.

Locations:

- `action.yaml:113`

### unpinned-uses (severity: high)

All uses: references across the action files use mutable version tags instead of full 40-character SHA digests, making the action vulnerable to supply-chain attacks if any referenced action is compromised or its tag is moved.

Failing references:
- action.yaml: `uses: actions/checkout@v4`
- action.yaml: `uses: peter-evans/find-comment@v3`
- action.yaml: `uses: peter-evans/create-or-update-comment@v4`
- action.yaml: `uses: actions/cache@v4`
- action.yaml: `uses: actions/upload-artifact@v4`
- action.yaml: `uses: actions/github-script@v7`
- action.yaml: `uses: actions/upload-artifact@v4` (landing state)
- setup-env/action.yaml: `uses: pnpm/action-setup@v2`
- setup-env/action.yaml: `uses: actions/setup-node@v4` (two occurrences)
- setup-env/action.yaml: `uses: actions/cache@v3`
- upgrade/action.yaml: `uses: peter-evans/create-pull-request@v7`

Locations:

- `action.yaml:160`
- `action.yaml:175`
- `action.yaml:185`
- `action.yaml:205`
- `action.yaml:230`
- `action.yaml:235`
- `action.yaml:260`
- `setup-env/action.yaml:47`
- `setup-env/action.yaml:53`
- `setup-env/action.yaml:63`
- `setup-env/action.yaml:68`
- `upgrade/action.yaml:107`

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

**Fixes applied:** script-injection, github-env-injection, unpinned-uses, static-inline-injection

**Notes:**

Fixed all findings across action.yaml, install/action.yaml, setup-env/action.yaml, and upgrade/action.yaml:

1. script-injection + static-inline-injection: Moved all ${{ inputs.* }}, ${{ github.action_path }}, and ${{ github.* }} expressions from run: shell strings into env: blocks. The post-init command is written to a temp file and executed with 'bash -eo pipefail' to preserve errexit semantics. The inputs.tools in install/action.yaml uses xargs-based tokenization for proper list handling.

2. github-env-injection: All values written to $GITHUB_ENV in the 'Set up inputs' step are now sanitized with 'printf "%s" "$VAR" | tr -d "\n\r"' before being written via heredoc. All ${{ inputs.* }} and ${{ github.* }} expressions are first captured into env: variables, then sanitized into local shell variables before being written to GITHUB_ENV.

3. unpinned-uses: All 10 uses: references pinned to full 40-character SHA digests with tag comments for readability: actions/checkout@11d5960..., peter-evans/find-comment@3eae4d3..., peter-evans/create-or-update-comment@71345be..., actions/cache@0057852... (v4) and @6f8efc2... (v3), actions/upload-artifact@ea165f8..., actions/github-script@f28e40c..., pnpm/action-setup@eae0cfe..., actions/setup-node@49933ea..., peter-evans/create-pull-request@22a9089...

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all 6 findings across 3 files:

1. action.yaml (findings 1 & 2): Moved `${{ github.token }}` from the heredoc in the 'Set up inputs' run: block into the step's env: block as `GITHUB_TOKEN_RAW`. Added sanitization with `printf '%s' "${GITHUB_TOKEN_RAW}" | tr -d '\n\r'` before writing to $GITHUB_ENV, fixing both the script-injection and github-env-injection findings.

2. action.yaml (finding 3): Moved `${{ env.TRUNK_TMPDIR }}` in the 'Unpack annotations artifact' step into the step's env: block as `TRUNK_TMPDIR_VAL`, then referenced it as `"$TRUNK_TMPDIR_VAL"` in the shell command.

3. setup-env/action.yaml (finding 4): Moved `${{ steps.setup_node.outcome }}` in the 'Check for node installation' step into the step's env: block as `SETUP_NODE_OUTCOME`, then referenced it as `"$SETUP_NODE_OUTCOME"` in the shell script.

4. setup-env/action.yaml (finding 5): Moved `${{ steps.install_packages.outcome }}` in the 'Check for package install' step into the step's env: block as `INSTALL_PACKAGES_OUTCOME`, then referenced it as `"$INSTALL_PACKAGES_OUTCOME"` in the shell script.

5. upgrade/upgrade.sh (finding 6): Replaced the unquoted `${UPGRADE_ARGUMENTS}` expansion with a guarded xargs-based tokenization into a bash array (`upgrade_args`), preventing shell metacharacter injection while preserving proper argument splitting for the list-style input.

### Iteration 3

**Fixes applied:** github-env-injection

**Notes:**

Fixed the payload branch in the 'Set up inputs' step of action.yaml. All values obtained from the payload() function (which reads attacker-controlled content from $GITHUB_EVENT_PATH via jq) are now sanitized with `| tr -d '\n\r'` before being written to $GITHUB_ENV. Each of the 30 payload-derived values is captured into a local sanitized variable (e.g., `_p_trunk_api_address`, `_p_arguments`, `_p_label`, etc.) and then those sanitized variables are used in the heredoc. This prevents newline injection attacks where an attacker could embed newlines in PR titles, branch names, or commit messages to inject additional environment variable definitions into $GITHUB_ENV.

### Iteration 4

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in the 'Download annotations artifact' step of action.yaml. Both ${{ }} expressions were moved out of the actions/github-script `script:` block and into a new `env:` block on the step: (1) `github.event.workflow_run.id` → env var `WORKFLOW_RUN_ID`, accessed as `parseInt(process.env.WORKFLOW_RUN_ID, 10)` in JS; (2) `env.TRUNK_TMPDIR` → env var `TRUNK_TMPDIR_SCRIPT`, accessed as `process.env.TRUNK_TMPDIR_SCRIPT + '/annotations.zip'` in JS.

