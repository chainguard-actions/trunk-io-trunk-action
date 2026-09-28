<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 32 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ }} expressions are interpolated directly inside run: shell command strings across several action files.

1. action.yaml — `run: ${{ inputs.post-init }}` executes arbitrary shell commands supplied by the caller as the entire run: value. This is a direct arbitrary code execution vector.
2. action.yaml — `if [[ "${{ inputs.check-mode }}" == "payload" ]]` interpolates inputs.check-mode directly into a shell conditional.
3. action.yaml — `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/pull_request.sh` (and three similar blocks for push.sh, all.sh, trunk_merge.sh) interpolates inputs.timeout-seconds directly into shell commands.
4. action.yaml — `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` interpolates github.action_path directly into a shell command.
5. install/action.yaml — `run: trunk tools install --ci ${{ inputs.tools }}` interpolates inputs.tools directly into a shell command, allowing argument injection.
6. setup-env/action.yaml — `if [ ${{ steps.setup_node.outcome }} == "success" ]` and `if [ ${{ steps.install_packages.outcome }} == "success" ]` interpolate steps context directly into shell conditionals.
7. setup-env/action.yaml — `run: ${{ env.INSTALL_CMD }}` executes the entire env.INSTALL_CMD expression as the run: value.
8. upgrade/action.yaml — `${{ github.action_path }}/../setup/locate_trunk.sh`, `ln -s ${{ github.action_path }}/../setup-env`, `${{ github.action_path }}/upgrade.sh`, and `${{ github.action_path }}/../cleanup.sh` all interpolate github.action_path directly into shell commands.

Locations:

- `action.yaml:121`
- `action.yaml:113`
- `action.yaml:148`
- `action.yaml:155`
- `action.yaml:165`
- `action.yaml:172`
- `action.yaml:182`
- `action.yaml:189`
- `action.yaml:133`
- `install/action.yaml:20`
- `setup-env/action.yaml:80`
- `setup-env/action.yaml:113`
- `setup-env/action.yaml:107`
- `upgrade/action.yaml:68`
- `upgrade/action.yaml:80`
- `upgrade/action.yaml:90`
- `upgrade/action.yaml:97`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes numerous untrusted input values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). The following values from inputs.* and github.* contexts are written unsanitized:
- `GITHUB_TOKEN=${{ github.token }}`
- `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`
- `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`
- `GITHUB_EVENT_PULL_REQUEST_HEAD_REPO_FORK=${{ github.event.pull_request.head.repo.fork }}`
- `GITHUB_EVENT_PULL_REQUEST_HEAD_SHA=${{ github.event.pull_request.head.sha }}`
- `GITHUB_EVENT_PULL_REQUEST_NUMBER=${{ github.event.pull_request.number }}`
- `GITHUB_REF_NAME=${{ github.ref_name }}`
- `INPUT_ARGUMENTS=${{ inputs.arguments }}`
- `INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-...`
- `INPUT_CHECK_MODE=${{ inputs.check-mode }}`
- `INPUT_LABEL=${{ inputs.label }}`
- `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`
- `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`
- and many more.

An attacker-controlled value containing newlines can inject arbitrary environment variable assignments into $GITHUB_ENV, potentially overriding security-sensitive variables for subsequent steps.

Locations:

- `action.yaml:113`
- `action.yaml:114`
- `action.yaml:130`
- `action.yaml:131`
- `action.yaml:132`
- `action.yaml:133`
- `action.yaml:134`
- `action.yaml:135`
- `action.yaml:136`
- `action.yaml:137`
- `action.yaml:138`
- `action.yaml:139`
- `action.yaml:140`
- `action.yaml:141`
- `action.yaml:142`
- `action.yaml:143`
- `action.yaml:144`
- `action.yaml:145`
- `action.yaml:146`
- `action.yaml:147`
- `action.yaml:148`
- `action.yaml:149`

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

Fixed all script injection and github-env-injection findings across action.yaml, install/action.yaml, setup-env/action.yaml, and upgrade/action.yaml:

1. action.yaml - Set up inputs step: Moved all ${{ inputs.* }} and ${{ github.* }} expressions to env: block with EXPR_* prefix variables. Replaced heredoc GITHUB_ENV writes with individual echo statements using a safe() function (printf '%s' | tr -d '\n\r') to strip newlines and prevent env injection.

2. action.yaml - Detect setup strategy step: Replaced ${{ github.action_path }} with ${GITHUB_ACTION_PATH} built-in env var.

3. action.yaml - Post-init steps: Changed run: ${{ inputs.post-init }} to use env var POST_INIT with eval "$POST_INIT".

4. action.yaml - All 4 run trunk check steps: Replaced ${{ inputs.timeout-seconds }} with ${INPUT_TIMEOUT_SECONDS} (already set in GITHUB_ENV by Set up inputs step).

5. install/action.yaml - Trunk install step: Moved ${{ inputs.tools }} to env var INPUT_TOOLS and used xargs-based tokenization for the list input.

6. setup-env/action.yaml - Check for node installation: Moved ${{ steps.setup_node.outcome }} to env var SETUP_NODE_OUTCOME.

7. setup-env/action.yaml - Install packages step: Changed run: ${{ env.INSTALL_CMD }} to run: eval "$INSTALL_CMD".

8. setup-env/action.yaml - Check for package install: Moved ${{ steps.install_packages.outcome }} to env var INSTALL_PACKAGES_OUTCOME.

9. upgrade/action.yaml - All steps with ${{ github.action_path }}: Replaced with ${GITHUB_ACTION_PATH} built-in env var.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed two script-injection findings in hardened/action/action.yaml:

1. 'Unpack annotations artifact' step (line ~308): Moved `${{ env.TRUNK_TMPDIR }}` out of the `run:` shell string into an `env:` block as `TRUNK_TMPDIR_VAL`, then referenced it as `"$TRUNK_TMPDIR_VAL"` in the shell script.

2. 'Post-init steps' step (line ~230): Replaced `eval "$POST_INIT"` with writing the user-provided content to a temporary script file using `printf '%s\n' "$POST_INIT" > "$_post_init_script"` and executing it with `bash "$_post_init_script"`. This avoids eval-based code execution while preserving the intended functionality of running user-provided shell commands.

### Iteration 3

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed github-env-injection in setup/locate_trunk.sh by sanitizing trunk_path with `printf '%s' | tr -d '\n\r'` before writing to GITHUB_ENV. Fixed script-injection in all.sh, pull_request.sh, push.sh, trunk_merge.sh, annotate.sh, populate_cache_only.sh, and upgrade/upgrade.sh by replacing unquoted ${INPUT_ARGUMENTS}/${UPGRADE_ARGUMENTS} expansions with properly tokenized bash arrays using the xargs/null-delimiter pattern. Also fixed related unquoted variables (htl_arg, upload_id_arg, annotation_argument) in all.sh and trunk_merge.sh by converting them to arrays. Removed all # shellcheck disable=SC2086 comments that were masking the injection issues.

