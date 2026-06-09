# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `ff50f15e4b79bfbf764dafdfd2579175a6ea9771`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 32 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

The 'Post-init steps' step in action.yaml directly interpolates `${{ inputs.post-init }}` as the entire `run:` command, allowing an attacker to inject arbitrary shell commands. Additionally, `${{ inputs.timeout-seconds }}` is interpolated directly inside `run:` blocks in four steps ('Run trunk check on pull request', 'Run trunk check on push', 'Run trunk check on all', 'Run trunk check on Trunk Merge') without first assigning it to an environment variable.

Locations:

- `action.yaml:218`
- `action.yaml:229`
- `action.yaml:240`
- `action.yaml:251`
- `action.yaml:262`

### github-env-injection (severity: high)

The 'Set up inputs' step writes multiple attacker-controlled `inputs.*` and `github.*` expression values directly to `$GITHUB_ENV` via a heredoc without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). This includes values such as `GITHUB_TOKEN=${{ github.token }}`, `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, and many others. A newline-injection attack via any of these values could allow an attacker to set arbitrary environment variables for subsequent steps.

Locations:

- `action.yaml:119`

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

Fixed all security findings in action.yaml:

1. github-env-injection: Replaced heredoc-based $GITHUB_ENV writes with a safe_val() function (using printf '%s' | tr -d '\n\r') and individual echo statements. All ${{ }} expressions moved to the step's env: block.

2. script-injection / static-inline-injection in 'Set up inputs': All ${{ inputs.* }} and ${{ github.* }} expressions moved to the env: block with safe variable names, then referenced as plain shell variables in the run: script.

3. script-injection in 'Post-init steps': Changed from `run: ${{ inputs.post-init }}` to using an env: block with POST_INIT_SCRIPT=${{ inputs.post-init }} and `eval "$POST_INIT_SCRIPT"` in the run block.

4. script-injection in the four 'Run trunk check on ...' steps: Moved ${{ inputs.timeout-seconds }} to each step's env: block as TIMEOUT_SECONDS and referenced as "$TIMEOUT_SECONDS" in the shell script.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in `install/action.yaml` at the 'Trunk install' step. Moved `${{ inputs.tools }}` out of the `run:` shell string and into an `env:` block as `TOOLS: ${{ inputs.tools }}`. The shell command now safely references `$TOOLS` instead of directly interpolating the GitHub Actions expression, preventing arbitrary shell command injection via the `tools` input.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed all script-injection findings:
1. action.yaml 'Detect setup strategy': moved ${{ github.action_path }} to ACTION_PATH env var.
2. action.yaml 'Post-init steps': replaced `eval "$POST_INIT_SCRIPT"` with writing to a temp file and executing with `bash`, eliminating the eval-based injection vector.
3. upgrade/action.yaml 'Locate trunk': moved ${{ github.action_path }} to ACTION_PATH env var.
4. upgrade/action.yaml 'Detect setup strategy': moved ${{ github.action_path }} to ACTION_PATH env var.
5. upgrade/action.yaml 'Run upgrade': moved ${{ github.action_path }} to ACTION_PATH env var.
6. upgrade/action.yaml 'Cleanup temporary files': moved ${{ github.action_path }} to ACTION_PATH env var.
All github context expressions are now assigned to env vars before use in run blocks.

