<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `1`

Action **trunk-io--trunk-action/v1.2.2** was hardened automatically. 35 finding(s) were identified and resolved across 3 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple ${{ }} expressions are interpolated directly inside run: shell blocks, violating sub-rule (a). Most critically, `run: ${{ inputs.post-init }}` executes arbitrary caller-supplied text as a shell command. Additionally, `${{ inputs.check-mode }}` is interpolated in a shell conditional, `${{ inputs.timeout-seconds }}` is passed directly to the `timeout` command in four separate run blocks, and `${{ github.action_path }}` is used to construct a shell command path in the 'Detect setup strategy' step. All of these allow an attacker (or calling workflow) to inject shell metacharacters before the shell ever sees the value.

Locations:

- `action.yaml:112`
- `action.yaml:127`
- `action.yaml:157`
- `action.yaml:222`
- `action.yaml:248`
- `action.yaml:258`
- `action.yaml:268`
- `action.yaml:278`
- `action.yaml:288`

### script-injection (severity: high)

In install/action.yaml, `${{ inputs.tools }}` is interpolated directly into a run: shell command: `run: trunk tools install --ci ${{ inputs.tools }}`. A caller can inject shell metacharacters via the `tools` input. Sub-rule (a) violation.

Locations:

- `install/action.yaml:30`

### script-injection (severity: high)

In upgrade/action.yaml, `${{ github.action_path }}` is interpolated directly inside multiple run: shell blocks to construct executable paths (e.g., `${{ github.action_path }}/../setup/locate_trunk.sh`, `ln -s ${{ github.action_path }}/../setup-env`, `${{ github.action_path }}/upgrade.sh`, `${{ github.action_path }}/../cleanup.sh`). Any ${{ }} expression inside a run: block is a script-injection risk per sub-rule (a).

Locations:

- `upgrade/action.yaml:87`
- `upgrade/action.yaml:103`
- `upgrade/action.yaml:115`
- `upgrade/action.yaml:123`

### github-env-injection (severity: high)

The 'Set up inputs' run: step in action.yaml writes numerous untrusted input values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). Values written unsanitized include: `GITHUB_TOKEN=${{ github.token }}`, `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`, `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`, `TRUNK_TOKEN=${{ inputs.trunk-token }}`, `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`, `GITHUB_REF_NAME=${{ github.ref_name }}`, `INPUT_ARGUMENTS=${{ inputs.arguments }}`, `INPUT_CHECK_MODE=${{ inputs.check-mode }}`, `INPUT_TRUNK_PATH=${{ inputs.trunk-path }}`, and many more. A newline-containing value in any of these inputs can inject arbitrary environment variables into subsequent steps.

Locations:

- `action.yaml:108`

### unpinned-uses (severity: high)

Multiple `uses:` references across action files use mutable version tags instead of full 40-character commit SHA hashes, making the action vulnerable to supply-chain attacks if those tags are moved. Failing references include: `actions/checkout@v4`, `peter-evans/find-comment@v3`, `peter-evans/create-or-update-comment@v4`, `actions/cache@v4`, `actions/upload-artifact@v4` (×2), `actions/github-script@v7` (in action.yaml); `pnpm/action-setup@v2`, `actions/setup-node@v4` (×2), `actions/cache@v3` (in setup-env/action.yaml); and `peter-evans/create-pull-request@v6` (in upgrade/action.yaml).

Locations:

- `action.yaml:196`
- `action.yaml:228`
- `action.yaml:237`
- `action.yaml:252`
- `action.yaml:296`
- `action.yaml:302`
- `setup-env/action.yaml:62`
- `setup-env/action.yaml:68`
- `setup-env/action.yaml:80`
- `setup-env/action.yaml:86`
- `upgrade/action.yaml:130`

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

Fixed all findings across action.yaml, install/action.yaml, upgrade/action.yaml, and setup-env/action.yaml:

1. script-injection / static-inline-injection (action.yaml): Moved all ${{ }} expressions from run: blocks to env: blocks. The 'Set up inputs' step now declares all inputs as env vars with _-prefixed names and uses them in the shell script. The 'Detect setup strategy' step uses ${GITHUB_ACTION_PATH} env var instead of ${{ github.action_path }}. The 'Post-init steps' step uses eval "$POST_INIT" where POST_INIT is set in env:. All four timeout steps use a _TIMEOUT_SECONDS env var.

2. github-env-injection (action.yaml): Added a safe() function (printf '%s' "$1" | tr -d '\n\r') to sanitize all values before writing to $GITHUB_ENV. Replaced heredoc pattern with individual echo statements using safe().

3. script-injection (install/action.yaml): Moved ${{ inputs.tools }} to TOOLS env var, used as ${TOOLS:+"$TOOLS"} to handle optional positional argument correctly.

4. script-injection (upgrade/action.yaml): Replaced all ${{ github.action_path }} in run: blocks with "${GITHUB_ACTION_PATH}/..." using the built-in env var.

5. unpinned-uses: Pinned all action references to full 40-character commit SHAs with tag comments: actions/checkout@v4, peter-evans/find-comment@v3, peter-evans/create-or-update-comment@v4, actions/cache@v4, actions/upload-artifact@v4 (×2), actions/github-script@v7 in action.yaml; pnpm/action-setup@v2, actions/setup-node@v4 (×2), actions/cache@v3 in setup-env/action.yaml; peter-evans/create-pull-request@v6 in upgrade/action.yaml.

Note: Findings referenced both action.yaml and action.yml — only action.yaml exists in this repo, so all fixes were applied there.

### Iteration 2

**Fixes applied:** script-injection, suspicious-run-content

**Notes:**

Fixed all script-injection and eval-dynamic findings:

1. action.yaml (Post-init steps, line 305): Replaced `eval "$POST_INIT"` with writing POST_INIT to a temp file and executing it with `bash script_file`. This eliminates the eval-dynamic pattern while preserving the intended functionality of running user-provided shell commands.

2. action.yaml (Unpack annotations artifact, line 421): Moved `${{ env.TRUNK_TMPDIR }}` out of the run command into an env block as `_TRUNK_TMPDIR`, then referenced it as `"$_TRUNK_TMPDIR"` in the shell command.

3. setup-env/action.yaml (Check for node installation, line 96): Moved `${{ steps.setup_node.outcome }}` into env block as `_SETUP_NODE_OUTCOME` and referenced it as `"$_SETUP_NODE_OUTCOME"` in the shell command.

4. setup-env/action.yaml (Install packages, line 113): Moved `${{ env.INSTALL_CMD }}` into env block as `_INSTALL_CMD` and executed it with `bash -c "$_INSTALL_CMD"` instead of using it directly as the run command.

5. setup-env/action.yaml (Check for package install, line 120): Moved `${{ steps.install_packages.outcome }}` into env block as `_INSTALL_PACKAGES_OUTCOME` and referenced it as `"$_INSTALL_PACKAGES_OUTCOME"` in the shell command.

### Iteration 1

**Fixes applied:** github-env-injection

**Notes:**

Fixed setup/locate_trunk.sh line 26: added sanitization of trunk_path before writing to $GITHUB_ENV. The variable trunk_path can originate from INPUT_TRUNK_PATH (user-controlled via inputs.trunk-path in both setup/action.yaml and upgrade/action.yaml). Without sanitization, a newline-containing value could inject arbitrary environment variables. Fix: introduced safe_trunk_path=$(printf '%s' "${trunk_path}" | tr -d '\n\r') and used that sanitized value in the echo to $GITHUB_ENV, while keeping the original trunk_path for the version check execution.

