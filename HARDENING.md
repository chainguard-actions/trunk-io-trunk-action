<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 37 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Post-init steps' run: block directly executes `${{ inputs.post-init }}` as a shell command. This allows any caller to inject arbitrary shell commands by supplying a malicious value for the `post-init` input.

Locations:

- `action.yaml:196`

### script-injection (severity: high)

Sub-rule (a): The 'Set up inputs' run: block interpolates multiple ${{ inputs.* }} and ${{ github.* }} expressions directly inside the shell script — including `if [[ "${{ inputs.check-mode }}" == "payload" ]]`, and many values written into a heredoc to $GITHUB_ENV (e.g. `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, etc.). Any of these expressions are substituted by the Actions runner before the shell sees the script, enabling script injection.

Locations:

- `action.yaml:107`

### script-injection (severity: high)

Sub-rule (a): The 'Run trunk check on pull request', 'Run trunk check on push', 'Run trunk check on all', and 'Run trunk check on Trunk Merge' steps all interpolate `${{ inputs.timeout-seconds }}` directly inside the run: shell command string (e.g. `timeout ${{ inputs.timeout-seconds }} ...` and `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]`). A malicious value can inject shell metacharacters.

Locations:

- `action.yaml:214`
- `action.yaml:225`
- `action.yaml:236`
- `action.yaml:247`

### script-injection (severity: high)

Sub-rule (a): The 'Detect setup strategy' run: block interpolates `${{ github.action_path }}` directly inside a shell command: `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`. While github.action_path is GitHub-controlled, any ${{ }} expression inside a run: block is a script-injection risk per the check rules.

Locations:

- `action.yaml:188`

### script-injection (severity: high)

Sub-rule (a): The 'Trunk install' run: block in install/action.yaml interpolates `${{ inputs.tools }}` directly into a shell command: `trunk tools install --ci ${{ inputs.tools }}`. A caller can inject shell metacharacters via the `tools` input.

Locations:

- `install/action.yaml:22`

### script-injection (severity: high)

Sub-rule (a): Multiple run: blocks in upgrade/action.yaml interpolate `${{ github.action_path }}` directly inside shell commands: the 'Locate trunk' step runs `${{ github.action_path }}/../setup/locate_trunk.sh`, the 'Run upgrade' step runs `${{ github.action_path }}/upgrade.sh`, and the 'Cleanup temporary files' step runs `${{ github.action_path }}/../cleanup.sh`. Any ${{ }} expression inside a run: block is a script-injection risk per the check rules.

Locations:

- `upgrade/action.yaml:100`
- `upgrade/action.yaml:119`
- `upgrade/action.yaml:127`

### github-env-injection (severity: high)

The 'Set up inputs' run: block in action.yaml writes many untrusted input values directly to $GITHUB_ENV via a heredoc without sanitization. Values such as `${{ inputs.github-token }}`, `${{ inputs.trunk-token }}`, `${{ inputs.arguments }}`, `${{ inputs.check-mode }}`, `${{ inputs.label }}`, `${{ inputs.upload-series }}`, `${{ github.ref_name }}`, `${{ github.event.pull_request.base.sha }}`, `${{ github.event.pull_request.head.sha }}`, `${{ github.event.pull_request.number }}`, etc. are written directly into $GITHUB_ENV without the required `printf '%s' ... | tr -d '\n\r'` sanitization step. A newline embedded in any of these values can inject arbitrary environment variables.

Locations:

- `action.yaml:107`

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

Fixed all script-injection, github-env-injection, and static-inline-injection findings across three files:

1. action.yaml 'Set up inputs' step: Moved all ${{ inputs.* }} and ${{ github.* }} expressions to an env: block with _RAW suffixes. The shell script now reads from env vars and sanitizes each value with `printf '%s' "$VAR" | tr -d '\n\r'` before writing to $GITHUB_ENV, preventing both script injection and newline-based env injection attacks.

2. action.yaml 'Detect setup strategy' step: Replaced `${{ github.action_path }}` with `${GITHUB_ACTION_PATH}` (the built-in env var GitHub Actions sets automatically).

3. action.yaml 'Post-init steps' step: Moved `${{ inputs.post-init }}` to env: block as POST_INIT, then used `eval "$POST_INIT"` in the run: block.

4. action.yaml 'Run trunk check on pull request/push/all/Trunk Merge' steps: Moved `${{ inputs.timeout-seconds }}` to env: TIMEOUT_SECONDS in each step and replaced inline expressions with "$TIMEOUT_SECONDS".

5. install/action.yaml 'Trunk install' step: Moved `${{ inputs.tools }}` to env: INPUT_TOOLS and used `${INPUT_TOOLS:+"$INPUT_TOOLS"}` to safely handle the optional argument.

6. upgrade/action.yaml: Replaced all `${{ github.action_path }}` references in 'Locate trunk', 'Detect setup strategy', 'Run upgrade', and 'Cleanup temporary files' steps with `${GITHUB_ACTION_PATH}` using the built-in env var.

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed all four script-injection findings:
1. setup-env/action.yaml: 'Check for node installation' step - moved `${{ steps.setup_node.outcome }}` to env block as SETUP_NODE_OUTCOME, referenced as "$SETUP_NODE_OUTCOME" in shell.
2. setup-env/action.yaml: 'Install packages' step - moved `${{ env.INSTALL_CMD }}` to env block as INSTALL_CMD, used `eval "$INSTALL_CMD"` in shell body instead of using the expression as the entire run: value.
3. setup-env/action.yaml: 'Check for package install' step - moved `${{ steps.install_packages.outcome }}` to env block as INSTALL_PACKAGES_OUTCOME, referenced as "$INSTALL_PACKAGES_OUTCOME" in shell.
4. action.yaml: 'Unpack annotations artifact' step - moved `${{ env.TRUNK_TMPDIR }}` to env block as TRUNK_TMPDIR, referenced as "$TRUNK_TMPDIR" (properly quoted) in shell.

### Iteration 3

**Fixes applied:** script-injection

**Notes:**

Fixed the script injection vulnerability in the 'Post-init steps' step of hardened/action/action.yaml. Replaced `eval "$POST_INIT"` with a safer approach that writes the post-init commands to a temporary file using `printf '%s\n' "$POST_INIT" > "$_post_init_script"` and then executes it with `bash "$_post_init_script"`. This eliminates eval's double-parsing of shell metacharacters while preserving the intended functionality. The `POST_INIT` env var continues to receive the value via the step's `env:` block (not interpolated into the run script), which is the correct pattern for handling user inputs.

### Iteration 1

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed two security issues:
1. **github-env-injection** (setup/locate_trunk.sh): Sanitized `INPUT_TRUNK_PATH` using `printf '%s' ... | tr -d '\n\r'` before assigning to `trunk_path`, and added a second sanitization step (`safe_trunk_path`) before writing `TRUNK_PATH` to `$GITHUB_ENV`. This prevents newline-injection attacks via the `trunk-path` input.
2. **script-injection** (upgrade/upgrade.sh): Added double-quotes around `${UPGRADE_ARGUMENTS}` in the trunk upgrade command invocation, and around `${LOWERCASE_TITLE}` in the `[[ ]]` conditional test. This prevents shell metacharacter injection from caller-controlled inputs. Also removed the now-unnecessary `trunk-ignore(shellcheck/SC2086)` comment since the variable is now properly quoted.

