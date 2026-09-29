<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v2.0.0** was hardened automatically. 34 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): Multiple ${{ }} expressions are interpolated directly inside run: shell command strings in the 'Set up inputs' step. This includes attacker-controllable values such as ${{ inputs.check-mode }}, ${{ inputs.github-token }}, ${{ inputs.trunk-token }}, ${{ inputs.timeout-seconds }}, ${{ inputs.arguments }}, ${{ inputs.cache-key }}, ${{ inputs.label }}, ${{ inputs.trunk-path }}, ${{ inputs.upload-series }}, ${{ inputs.lfs-checkout }}, ${{ github.event.pull_request.base.sha }}, ${{ github.event.pull_request.head.sha }}, ${{ github.event.pull_request.number }}, ${{ github.ref_name }}, and others — all interpolated directly into the shell heredoc before the shell ever sees them. Any of these values containing shell metacharacters (newlines, semicolons, backticks, etc.) can break out of the heredoc context or inject arbitrary commands.

Locations:

- `action.yaml:113`
- `action.yaml:115`

### script-injection (severity: high)

Rule (a): ${{ github.action_path }} is interpolated directly inside a run: shell command string in the 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`. Although github.action_path is GitHub-controlled, any ${{ ... }} expression inside a run: block is a script-injection finding per the check rules.

Locations:

- `action.yaml:175`

### script-injection (severity: high)

Rule (a): ${{ inputs.tools }} is interpolated directly inside a run: shell command string: `trunk tools install --ci ${{ inputs.tools }}`. An attacker-controlled value for inputs.tools can inject arbitrary shell commands.

Locations:

- `install/action.yaml:18`

### script-injection (severity: high)

Rule (a): ${{ steps.setup_node.outcome }} is interpolated directly inside a run: shell command string in the 'Check for node installation' step: `if [ ${{ steps.setup_node.outcome }} == "success" ]; then`. Any ${{ steps.*.outputs.* }} or ${{ steps.*.outcome }} expression inside a run: block is a script-injection finding.

Locations:

- `setup-env/action.yaml:79`

### script-injection (severity: high)

Rule (a): ${{ env.INSTALL_CMD }} is interpolated directly inside a run: shell command string in the 'Install packages' step: `run: ${{ env.INSTALL_CMD }}`. The env.INSTALL_CMD value flows from workflow-controllable context and is used as the entire shell command, enabling arbitrary command injection.

Locations:

- `setup-env/action.yaml:103`

### script-injection (severity: high)

Rule (a): ${{ steps.install_packages.outcome }} is interpolated directly inside a run: shell command string in the 'Check for package install' step: `if [ ${{ steps.install_packages.outcome }} == "success" ]; then`.

Locations:

- `setup-env/action.yaml:110`

### script-injection (severity: high)

Rule (a): ${{ github.action_path }} is interpolated directly inside run: shell command strings in multiple steps of upgrade/action.yaml: the 'Locate trunk' step (`${{ github.action_path }}/../setup/locate_trunk.sh`), the 'Detect setup strategy' step (`ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`), the 'Run upgrade' step (`${{ github.action_path }}/upgrade.sh`), and the 'Cleanup temporary files' step (`${{ github.action_path }}/../cleanup.sh`).

Locations:

- `upgrade/action.yaml:76`
- `upgrade/action.yaml:90`
- `upgrade/action.yaml:99`
- `upgrade/action.yaml:107`

### script-injection (severity: high)

Rule (b): The 'Post-init steps' step sets env var POST_INIT from ${{ inputs.post-init }} and then executes it as a shell command: `bash --noprofile --norc -eo pipefail -c "$POST_INIT"`. While POST_INIT is double-quoted in the -c argument, the entire value is passed as a shell script string to bash -c, meaning any shell code in inputs.post-init is executed verbatim. This is an intentional escape hatch per the comment, but it is an unrestricted arbitrary code execution vector for any caller of this composite action.

Locations:

- `action.yaml:183`

### github-env-injection (severity: high)

The 'Set up inputs' step writes many untrusted input and github context values directly into $GITHUB_ENV via a shell heredoc without sanitization (no `printf '%s' ... | tr -d '\n\r'` applied before the write). Affected values include ${{ inputs.github-token }}, ${{ inputs.trunk-token }}, ${{ inputs.arguments }}, ${{ inputs.cache-key }}, ${{ inputs.label }}, ${{ inputs.trunk-path }}, ${{ inputs.upload-series }}, ${{ inputs.lfs-checkout }}, ${{ inputs.check-mode }}, ${{ inputs.debug }}, ${{ inputs.setup-deps }}, ${{ github.event.pull_request.base.sha }}, ${{ github.event.pull_request.head.sha }}, ${{ github.event.pull_request.number }}, ${{ github.ref_name }}, and ${{ inputs.timeout-seconds }}. A newline embedded in any of these values can inject arbitrary environment variable assignments into $GITHUB_ENV, potentially overwriting security-sensitive variables for subsequent steps.

Locations:

- `action.yaml:113`

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

Fixed all script-injection, github-env-injection, and static-inline-injection findings across four files:

1. **hardened/action/action.yaml**: Moved all ${{ }} expressions in the 'Set up inputs' step to the step's env: block with _RAW suffixes. Added a sanitize() helper that strips newlines/carriage-returns before writing to $GITHUB_ENV. Replaced the heredoc write with individual echo statements using sanitized values. Fixed the 'Detect setup strategy' step to use ${GITHUB_ACTION_PATH} instead of ${{ github.action_path }}.

2. **hardened/action/install/action.yaml**: Moved ${{ inputs.tools }} to env: INPUT_TOOLS and used xargs-based bash array tokenization to properly handle the list input without injection.

3. **hardened/action/setup-env/action.yaml**: Fixed three issues: (a) moved ${{ steps.setup_node.outcome }} to env: SETUP_NODE_OUTCOME; (b) replaced ${{ env.INSTALL_CMD }} with plain $INSTALL_CMD; (c) moved ${{ steps.install_packages.outcome }} to env: INSTALL_PACKAGES_OUTCOME.

4. **hardened/action/upgrade/action.yaml**: Replaced all four ${{ github.action_path }} references with ${GITHUB_ACTION_PATH} in the 'Locate trunk', 'Detect setup strategy', 'Run upgrade', and 'Cleanup temporary files' steps.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed three security findings:

1. script-injection (action.yaml): Post-init steps now writes the caller-supplied `inputs.post-init` value to a temp file and executes it as a script file (`bash --noprofile --norc -eo pipefail "$_post_init_script"`), instead of passing it as a `-c` argument. This prevents shell metacharacters in the input from being interpreted as command separators.

2. github-env-injection (action.yaml, payload branch): Replaced the heredoc that wrote unsanitized `$(payload ...)` values directly to `$GITHUB_ENV` with individual sanitized writes using the existing `sanitize()` function (which strips newlines/carriage-returns). Each of the ~28 payload values is now sanitized before being written.

3. github-env-injection (upgrade/upgrade.sh): Fixed two issues: (a) replaced the fixed `EOF` heredoc delimiter with a random `EOF_<16-char-random>` delimiter to prevent premature termination if `${description}` contains `EOF` on its own line; (b) sanitized `${description}` with `printf '%s' | tr -d '\r'` and `${title_message}` with `printf '%s' | tr -d '\n\r'` before writing to `$GITHUB_ENV`.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed script injection in 7 shell scripts by replacing unquoted ${INPUT_ARGUMENTS} and ${UPGRADE_ARGUMENTS} expansions with safe bash array tokenization using xargs. Each affected script now uses a guarded xargs-based tokenization loop (with NUL delimiters and printf '%s' to handle leading dashes) to split the args-style input into a bash array, which is then expanded as "${input_arguments[@]}" or "${upgrade_arguments[@]}". Removed all # shellcheck disable=SC2086 directives that were acknowledging the unsafe pattern. In all.sh, also refactored the htl_arg/upload_id_arg handling to keep flag and value as separate properly-quoted arguments rather than packing them into a single variable.

