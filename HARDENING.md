<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v2.0.0** was hardened automatically. 27 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ ... }} expressions are directly interpolated inside run: shell command strings (sub-rule a), allowing script injection. In action.yaml's 'Set up inputs' step, ${{ inputs.timeout-seconds }} is echoed directly into the shell, ${{ inputs.check-mode }} is used in an if-condition, and ${{ github.token }}, ${{ inputs.github-token }}, ${{ inputs.trunk-token }} appear unquoted in the shell body. In the 'Detect setup strategy' step, ${{ github.action_path }} is used directly in a run: block. In install/action.yaml, ${{ inputs.tools }} is appended directly to a shell command. In upgrade/action.yaml, ${{ github.action_path }} appears in four separate run: blocks. In setup-env/action.yaml, ${{ steps.setup_node.outcome }} and ${{ steps.install_packages.outcome }} are interpolated directly into shell if-conditions.

Locations:

- `action.yaml:117`
- `action.yaml:127`
- `action.yaml:133`
- `action.yaml:230`
- `install/action.yaml:28`
- `upgrade/action.yaml:106`
- `upgrade/action.yaml:127`
- `upgrade/action.yaml:138`
- `upgrade/action.yaml:147`
- `setup-env/action.yaml:112`
- `setup-env/action.yaml:152`

### github-env-injection (severity: high)

Multiple untrusted input and github context values are written directly to $GITHUB_ENV without the required sanitization step (printf '%s' ... | tr -d '\n\r'). In action.yaml's 'Set up inputs' step: (1) echo "INPUT_TIMEOUT_SECONDS=${{ inputs.timeout-seconds }}" >> "${GITHUB_ENV}" writes inputs.timeout-seconds unsanitized; (2) a heredoc block writes ${{ inputs.github-token }}, ${{ inputs.trunk-token }}, ${{ github.event.pull_request.base.sha }}, ${{ github.event.pull_request.head.sha }}, ${{ github.event.pull_request.number }}, ${{ github.ref_name }}, ${{ inputs.arguments }}, ${{ inputs.cache }}, ${{ inputs.cache-key }}, ${{ inputs.check-all-mode }}, ${{ inputs.check-mode }}, ${{ inputs.debug }}, ${{ inputs.label }}, ${{ inputs.setup-deps }}, ${{ inputs.trunk-path }}, ${{ inputs.upload-series }}, and ${{ inputs.lfs-checkout }} all directly to $GITHUB_ENV. A newline embedded in any of these values could inject arbitrary environment variables into subsequent steps.

Locations:

- `action.yaml:117`
- `action.yaml:170`
- `action.yaml:171`
- `action.yaml:172`
- `action.yaml:173`
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

Fixed all script-injection and github-env-injection findings across action.yaml, install/action.yaml, upgrade/action.yaml, and setup-env/action.yaml:

1. action.yaml 'Set up inputs': Moved all ${{ }} expressions (inputs.timeout-seconds, inputs.check-mode, github.token, inputs.github-token, inputs.trunk-token, and all other inputs/github context values) to env: block. Added sanitization with `printf '%s' | tr -d '\n\r'` for all values written to $GITHUB_ENV.

2. action.yaml 'Detect setup strategy': Replaced ${{ github.action_path }} with $GITHUB_ACTION_PATH.

3. install/action.yaml 'Trunk install': Moved ${{ inputs.tools }} to env: block as INPUT_TOOLS, then tokenized with xargs into a bash array before passing to trunk tools install.

4. upgrade/action.yaml: Replaced all four ${{ github.action_path }} occurrences with $GITHUB_ACTION_PATH in 'Locate trunk', 'Detect setup strategy', 'Run upgrade', and 'Cleanup temporary files' steps.

5. setup-env/action.yaml: Moved ${{ steps.setup_node.outcome }} to env: block as SETUP_NODE_OUTCOME, and ${{ steps.install_packages.outcome }} to env: block as INSTALL_PACKAGES_OUTCOME.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all four security findings:

1. setup-env/action.yaml: Replaced `run: ${{ env.INSTALL_CMD }}` with a safe case statement that whitelists the three known-safe install commands (npm ci, yarn install --immutable, pnpm install --frozen-lockfile), moving INSTALL_CMD into the step's env block.

2. action.yaml (payload mode): Replaced the heredoc that called $(payload ...) directly inside the heredoc body with individual sanitized writes. Each payload value is captured into a raw variable, sanitized with `printf '%s' ... | tr -d '\n\r'`, and only the sanitized value is written to GITHUB_ENV.

3. pull_request.sh, push.sh, all.sh, trunk_merge.sh, annotate.sh, populate_cache_only.sh: Replaced all unquoted ${INPUT_ARGUMENTS} expansions with a bash array populated via xargs-based quote-aware tokenization (`printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0'`), then expanded as `"${input_args[@]}"` in trunk invocations.

4. upgrade/upgrade.sh: Replaced unquoted ${UPGRADE_ARGUMENTS} with a bash array `upgrade_args=()` using the same xargs-based tokenization pattern, expanded as `"${upgrade_args[@]}"` in the trunk upgrade invocation.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in the 'Post-init steps' step of action.yaml. The original code used `bash --noprofile --norc -eo pipefail -c "$POST_INIT"` where POST_INIT was set from `${{ inputs.post-init }}`, allowing any caller to inject arbitrary shell commands. The fix writes the POST_INIT value to a temporary file using `printf '%s\n' "$POST_INIT" > "$_post_init_script"` and then executes that file directly with `bash --noprofile --norc -eo pipefail "$_post_init_script"`. This eliminates the bash -c injection vector while preserving the intended functionality of running user-provided post-init scripts.

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed github-env-injection in hardened/action/setup/locate_trunk.sh by sanitizing the trunk_path value before writing to $GITHUB_ENV. Added `safe_trunk_path="$(printf '%s' "${trunk_path}" | tr -d '\n\r')"` and changed the echo to use `safe_trunk_path` instead of `trunk_path`. This covers both setup/action.yaml and upgrade/action.yaml since both call the same locate_trunk.sh script with the user-controlled INPUT_TRUNK_PATH env var.

