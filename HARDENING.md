<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.2.2** was hardened automatically. 33 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks directly interpolate ${{ ... }} expressions into shell commands, enabling script injection. (a) `run: ${{ inputs.post-init }}` executes arbitrary caller-supplied shell code verbatim. (b) `timeout ${{ inputs.timeout-seconds }} ...` interpolates the user-controlled input directly into the shell command in four separate steps (pull_request, push, all, trunk_merge). (c) `if [[ "${{ inputs.check-mode }}" == "payload" ]]` interpolates user input into a shell conditional. (d) `ln -s ${{ github.action_path }}/setup-env` interpolates a GitHub context expression directly in a run block. (e) `trunk tools install --ci ${{ inputs.tools }}` in install/action.yaml interpolates user input directly into a shell command. (f) `if [ ${{ steps.setup_node.outcome }} == "success" ]` and `if [ ${{ steps.install_packages.outcome }} == "success" ]` in setup-env/action.yaml interpolate step-output expressions directly in shell. (g) Multiple `${{ github.action_path }}/...` path constructions in upgrade/action.yaml run blocks.

Locations:

- `action.yaml:196`
- `action.yaml:214`
- `action.yaml:222`
- `action.yaml:231`
- `action.yaml:239`
- `action.yaml:175`
- `action.yaml:113`
- `install/action.yaml:18`
- `setup-env/action.yaml:72`
- `setup-env/action.yaml:96`
- `upgrade/action.yaml:60`
- `upgrade/action.yaml:72`
- `upgrade/action.yaml:80`
- `upgrade/action.yaml:88`

### github-env-injection (severity: high)

The 'Set up inputs' step in action.yaml writes numerous untrusted values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). This includes attacker-controllable inputs such as: `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `TRUNK_TOKEN=${{ inputs.trunk-token }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CHECK_MODE=${{ inputs.check-mode }}`, `INPUT_LABEL=${{ inputs.label }}`, `INPUT_UPLOAD_SERIES=${{ inputs.upload-series }}`, and github event values like `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`, `GITHUB_EVENT_PULL_REQUEST_HEAD_SHA=${{ github.event.pull_request.head.sha }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`. A newline injected into any of these values can define arbitrary additional environment variables, enabling environment variable injection attacks.

Locations:

- `action.yaml:113`

### unpinned-uses (severity: high)

All `uses:` references across action.yaml, setup-env/action.yaml, and upgrade/action.yaml use mutable version tags instead of immutable 40-character SHA digests, making the action vulnerable to supply-chain attacks if any of these upstream actions are compromised or their tags are moved. Failing references include: `actions/checkout@v4`, `peter-evans/find-comment@v3`, `peter-evans/create-or-update-comment@v4`, `actions/cache@v4`, `actions/upload-artifact@v4` (×2), `actions/github-script@v7`, `pnpm/action-setup@v2`, `actions/setup-node@v4` (×2), `actions/cache@v3`, and `peter-evans/create-pull-request@v6`.

Locations:

- `action.yaml:155`
- `action.yaml:178`
- `action.yaml:188`
- `action.yaml:200`
- `action.yaml:248`
- `action.yaml:256`
- `action.yaml:271`
- `setup-env/action.yaml:60`
- `setup-env/action.yaml:66`
- `setup-env/action.yaml:80`
- `setup-env/action.yaml:86`
- `upgrade/action.yaml:100`

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

1. **action.yaml - Set up inputs step**: Moved all ${{ inputs.* }} and ${{ github.* }} expressions to the step's env: block. Sanitized each value with `printf '%s' "$VAR" | tr -d '\n\r'` before writing to GITHUB_ENV. Replaced heredoc-based GITHUB_ENV writes with individual `printf 'KEY=%s\n' "${safe_val}"` calls to prevent newline injection.

2. **action.yaml - Post-init steps**: Moved `${{ inputs.post-init }}` to env: block as POST_INIT_CMD, then executed via temp file with `bash -eo pipefail` to preserve errexit semantics.

3. **action.yaml - Timeout steps (4x)**: Moved `${{ inputs.timeout-seconds }}` to env: TIMEOUT_SECONDS in each of the pull_request, push, all, and trunk_merge steps.

4. **action.yaml - Detect setup strategy**: Replaced `ln -s ${{ github.action_path }}/setup-env` with `ln -s "${GITHUB_ACTION_PATH}/setup-env"`.

5. **action.yaml - Unpinned uses**: Pinned all 7 uses references to full commit SHAs.

6. **install/action.yaml**: Moved `${{ inputs.tools }}` to env: INPUT_TOOLS and used xargs-based tokenization to safely pass the list to `trunk tools install --ci`.

7. **setup-env/action.yaml**: Moved `${{ steps.setup_node.outcome }}` and `${{ steps.install_packages.outcome }}` to env: blocks. Pinned pnpm/action-setup@v2, actions/setup-node@v4 (×2), and actions/cache@v3.

8. **upgrade/action.yaml**: Replaced all 4 `${{ github.action_path }}` references in run blocks with `"${GITHUB_ACTION_PATH}"`. Pinned peter-evans/create-pull-request@v6 to its SHA.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed four findings across two files:

1. action.yaml (findings 1 & 2 - script-injection + github-env-injection at line 148): Added INPUT_GITHUB_TOKEN_BUILTIN env var to capture github.token, then replaced the heredoc `cat >>$GITHUB_ENV <<EOF\nGITHUB_TOKEN=${{ github.token }}\n...EOF` with sanitized printf: `safe_github_token_builtin=$(printf '%s' "$INPUT_GITHUB_TOKEN_BUILTIN" | tr -d '\n\r')` followed by `printf 'GITHUB_TOKEN=%s\n' "${safe_github_token_builtin}" >>$GITHUB_ENV`.

2. action.yaml (finding 3 - script-injection at line 449): Moved `${{ env.TRUNK_TMPDIR }}` out of the run: block into an env: block as TRUNK_TMPDIR_PATH, then used `cd "$TRUNK_TMPDIR_PATH"` in the shell script.

3. setup-env/action.yaml (finding 4 - script-injection at line 115): Moved `${{ env.INSTALL_CMD }}` from the run: field into an env: block, then wrote the command to a temp script and executed it with `bash -eo pipefail` to preserve errexit semantics.

### Iteration 3

**Fixes applied:** github-env-injection, script-injection

**Notes:**

Fixed two high-severity findings:

1. github-env-injection (action.yaml): Replaced the unsafe heredoc (`cat >>$GITHUB_ENV <<EOF`) that wrote `$(payload ...)` values directly to $GITHUB_ENV with individual `printf` statements. Each payload value is captured into `_raw`, then sanitized with `printf '%s' "${_raw}" | tr -d '\n\r'` before being written to $GITHUB_ENV. This covers all 28 variables written in the payload branch.

2. script-injection (7 shell scripts): Replaced all unquoted `${INPUT_ARGUMENTS}` and `${UPGRADE_ARGUMENTS}` expansions with xargs-based bash array tokenization. Each script now tokenizes the arguments list into `_input_arguments[]` (or `_upgrade_arguments[]`) using `printf '%s' "$VAR" | xargs printf '%s\0'` with a NUL-delimited read loop, then expands as `"${_input_arguments[@]}"`. This preserves multi-argument support while preventing shell metacharacter injection. Removed the `# shellcheck disable=SC2086` comments that were suppressing the warnings about the unsafe unquoted expansions.

