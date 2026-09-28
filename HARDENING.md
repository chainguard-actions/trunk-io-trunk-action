<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v2.0.0** was hardened automatically. 31 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): Multiple ${{ }} expressions are directly interpolated inside run: shell command strings in the 'Set up inputs' step. This includes: `echo "INPUT_TIMEOUT_SECONDS=${{ inputs.timeout-seconds }}"`, `if [[ "${{ inputs.check-mode }}" == "payload" ]]`, `INPUT_GITHUB_TOKEN=${{ github.token }}`, and a heredoc that writes many `${{ inputs.* }}` and `${{ github.* }}` values (e.g. `GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, etc.) directly to $GITHUB_ENV. Any of these values can contain shell metacharacters that are interpreted before the shell ever sees them, enabling command injection.

Locations:

- `action.yaml:130`
- `action.yaml:132`
- `action.yaml:138`
- `action.yaml:143`
- `action.yaml:165`

### script-injection (severity: high)

Sub-rule (a): The 'Detect setup strategy' step in action.yaml directly interpolates `${{ github.action_path }}` inside a run: shell command: `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`. Although github.action_path is GitHub-controlled, any ${{ }} expression inside a run: block is a script-injection risk because the value is substituted into the shell script before the shell parses it.

Locations:

- `action.yaml:220`

### script-injection (severity: high)

Sub-rule (a): The 'Trunk install' step in install/action.yaml directly interpolates `${{ inputs.tools }}` inside a run: shell command: `run: trunk tools install --ci ${{ inputs.tools }}`. The inputs.tools value is caller-controlled and is substituted into the shell command string before the shell parses it, enabling command injection.

Locations:

- `install/action.yaml:22`

### script-injection (severity: high)

Sub-rule (a): In setup-env/action.yaml, two run: blocks directly interpolate ${{ }} expressions: (1) The 'Check for node installation' step uses `if [ ${{ steps.setup_node.outcome }} == "success" ]` — a steps.*.outputs context expression directly in the shell. (2) The 'Install packages' step uses `run: ${{ env.INSTALL_CMD }}` — the entire run: command is an expression. (3) The 'Check for package install' step uses `if [ ${{ steps.install_packages.outcome }} == "success" ]`. All of these substitute values into the shell script before parsing.

Locations:

- `setup-env/action.yaml:80`
- `setup-env/action.yaml:100`
- `setup-env/action.yaml:110`

### script-injection (severity: high)

Sub-rule (a): In upgrade/action.yaml, multiple run: blocks directly interpolate `${{ github.action_path }}` in shell commands: (1) 'Locate trunk' step: `${{ github.action_path }}/../setup/locate_trunk.sh`; (2) 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`; (3) 'Run upgrade' step: `${{ github.action_path }}/upgrade.sh`; (4) 'Cleanup temporary files' step: `${{ github.action_path }}/../cleanup.sh`. Any ${{ }} expression directly inside a run: block is a script-injection finding.

Locations:

- `upgrade/action.yaml:60`
- `upgrade/action.yaml:75`
- `upgrade/action.yaml:85`
- `upgrade/action.yaml:93`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes multiple untrusted input values directly to $GITHUB_ENV via a heredoc without the required sanitization step (`printf '%s' ... | tr -d '\n\r'`). Specifically, values from `inputs.github-token`, `inputs.trunk-token`, `inputs.arguments`, `inputs.cache-key`, `inputs.check-mode`, `inputs.label`, `inputs.setup-deps`, `inputs.trunk-path`, `inputs.upload-series`, `inputs.lfs-checkout`, `github.event.pull_request.base.sha`, `github.event.pull_request.head.sha`, `github.event.pull_request.number`, `github.ref_name`, and others are written directly to $GITHUB_ENV. A newline in any of these values allows an attacker to inject arbitrary environment variables. The `# zizmor: ignore[github-env]` comment suppresses tooling warnings but does not fix the vulnerability.

Locations:

- `action.yaml:130`
- `action.yaml:165`

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

1. action.yaml (Set up inputs): Moved all 24+ ${{ }} expressions to the step's env: block. Replaced heredoc-to-GITHUB_ENV with printf calls using a safe() sanitizer (tr -d '\n\r') to prevent newline injection. Replaced inline ${{ inputs.check-mode }} comparison and ${{ github.token }} fallback with env var references.

2. action.yaml (Detect setup strategy): Moved ${{ github.action_path }} to env: block as ACTION_PATH; used "${ACTION_PATH}/setup-env" in run block.

3. install/action.yaml (Trunk install): Moved ${{ inputs.tools }} to env: block as INPUT_TOOLS; used xargs-based array tokenization to safely split the list input before passing to trunk tools install --ci.

4. setup-env/action.yaml: (a) Check for node installation: moved ${{ steps.setup_node.outcome }} to env: block as SETUP_NODE_OUTCOME. (b) Install packages: replaced run: ${{ env.INSTALL_CMD }} with a case statement on ${PACKAGE_MANAGER}. (c) Check for package install: moved ${{ steps.install_packages.outcome }} to env: block as INSTALL_PACKAGES_OUTCOME.

5. upgrade/action.yaml: Moved ${{ github.action_path }} to env: blocks as ACTION_PATH in all four affected steps (Locate trunk, Detect setup strategy, Run upgrade, Cleanup temporary files).

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed three security findings:

1. **script-injection (action.yaml - Post-init steps)**: Replaced `bash -c "$POST_INIT"` with writing POST_INIT to a temp file and executing the file. This prevents the ${{ inputs.post-init }} expression from being directly interpolated into a shell command string.

2. **github-env-injection (action.yaml - Set up inputs)**: Replaced the heredoc that wrote `$(payload ...)` values directly to $GITHUB_ENV with individual `printf` calls that pipe each value through `tr -d '\n\r'` to strip newlines before writing. This prevents newline injection via malicious event JSON values.

3. **script-injection (upgrade/upgrade.sh)**: Replaced the unquoted `${UPGRADE_ARGUMENTS}` expansion with an xargs-based tokenization approach that splits the arguments into a bash array (with proper quoting preservation), then expands the array safely with `"${upgrade_args[@]}"`.

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed the GITHUB_ENV injection vulnerability in setup/locate_trunk.sh (line 26). The trunk_path variable, which can be initialized from the caller-controlled INPUT_TRUNK_PATH env var (set from inputs.trunk-path in both setup/action.yaml and upgrade/action.yaml), was written directly to GITHUB_ENV without sanitization. Added sanitization by computing `safe_trunk_path="$(printf '%s' "${trunk_path}" | tr -d '\n\r')"` and using that sanitized value in the `echo "TRUNK_PATH=..." >> "${GITHUB_ENV}"` line. This matches the sanitization pattern already used in the main action.yaml's `safe()` function and prevents newline injection attacks that could add arbitrary key=value pairs to the runner's environment.

