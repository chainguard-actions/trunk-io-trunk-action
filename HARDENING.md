<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.2.4** was hardened automatically. 33 finding(s) were identified and resolved across 2 iteration(s).

## Findings Fixed

### unpinned-uses (severity: high)

Multiple `uses:` references across action files are pinned to mutable version tags instead of immutable 40-character SHA digests, making the action vulnerable to supply-chain attacks if those tags are moved.

Failing references:
- action.yaml: `actions/checkout@v4`, `peter-evans/find-comment@v3`, `peter-evans/create-or-update-comment@v4`, `actions/cache@v4`, `actions/github-script@v7`, `actions/upload-artifact@v4` (×2)
- setup-env/action.yaml: `pnpm/action-setup@v2`, `actions/setup-node@v4` (×2), `actions/cache@v3`
- upgrade/action.yaml: `peter-evans/create-pull-request@v7`

Locations:

- `action.yaml:197`
- `action.yaml:224`
- `action.yaml:234`
- `action.yaml:263`
- `action.yaml:320`
- `action.yaml:337`
- `action.yaml:381`
- `setup-env/action.yaml:57`
- `setup-env/action.yaml:63`
- `setup-env/action.yaml:80`
- `setup-env/action.yaml:85`
- `upgrade/action.yaml:107`

### script-injection (severity: high)

Multiple `run:` blocks interpolate GitHub Actions expressions (`${{ ... }}`) directly into shell commands, allowing an attacker who controls those values to inject arbitrary shell commands.

(a) `run: ${{ inputs.post-init }}` — the entire run command is the user-supplied `post-init` input, giving any caller full arbitrary code execution.

(b) `if [[ "${{ inputs.check-mode }}" == "payload" ]]` — `inputs.check-mode` is interpolated directly into the shell conditional in the 'Set up inputs' run block.

(c) `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/pull_request.sh` (and identical patterns for push.sh, all.sh, trunk_merge.sh) — `inputs.timeout-seconds` is interpolated directly as a shell argument.

(d) `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` — `github.action_path` is interpolated directly into a shell command in the 'Detect setup strategy' run block.

(e) install/action.yaml: `trunk tools install --ci ${{ inputs.tools }}` — `inputs.tools` is interpolated directly into the shell command.

(f) upgrade/action.yaml: `${{ github.action_path }}/upgrade.sh`, `${{ github.action_path }}/../setup/locate_trunk.sh`, `${{ github.action_path }}/../setup-env`, `${{ github.action_path }}/../cleanup.sh` — `github.action_path` is interpolated directly into shell commands across multiple run blocks.

Locations:

- `action.yaml:270`
- `action.yaml:107`
- `action.yaml:108`
- `action.yaml:278`
- `action.yaml:289`
- `action.yaml:300`
- `action.yaml:311`
- `action.yaml:222`
- `install/action.yaml:19`
- `upgrade/action.yaml:79`
- `upgrade/action.yaml:91`
- `upgrade/action.yaml:99`
- `upgrade/action.yaml:106`

### github-env-injection (severity: high)

The 'Set up inputs' run block in action.yaml writes numerous `inputs.*` and `github.*` values directly to `$GITHUB_ENV` via a heredoc without any sanitization (`printf '%s' ... | tr -d '\n\r'`). An attacker who controls these values (e.g. via a malicious `inputs.arguments`, `inputs.trunk-token`, `inputs.github-token`, `inputs.label`, `inputs.upload-series`, `inputs.cache-key`, `inputs.trunk-path`, `inputs.check-mode`, `inputs.check-run-id`, `inputs.timeout-seconds`, `inputs.lfs-checkout`, `github.event.pull_request.base.sha`, `github.event.pull_request.head.sha`, `github.event.pull_request.number`, `github.ref_name`) can inject newlines into the heredoc to set arbitrary environment variables for subsequent steps, enabling environment variable hijacking.

Failing writes (all unsanitized, in the `else` branch of the 'Set up inputs' step):
```
INPUT_GITHUB_TOKEN=${{ inputs.github-token }}
INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}
TRUNK_TOKEN=${{ inputs.trunk-token }}
GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}
GITHUB_EVENT_PULL_REQUEST_HEAD_REPO_FORK=${{ github.event.pull_request.head.repo.fork }}
GITHUB_EVENT_PULL_REQUEST_HEAD_SHA=${{ github.event.pull_request.head.sha }}
GITHUB_EVENT_PULL_REQUEST_NUMBER=${{ github.event.pull_request.number }}
GITHUB_REF_NAME=${{ github.ref_name }}
INPUT_ARGUMENTS=${{ inputs.arguments }}
INPUT_CACHE=${{ inputs.cache }}
INPUT_CACHE_KEY=trunk-${{ inputs.cache-key }}-...
... (and many more)
```
Also: `GITHUB_TOKEN=${{ github.token }}` is written to `$GITHUB_ENV` at the top of the same step without sanitization.

Locations:

- `action.yaml:103`
- `action.yaml:155`
- `action.yaml:156`
- `action.yaml:157`
- `action.yaml:158`
- `action.yaml:159`
- `action.yaml:160`
- `action.yaml:161`
- `action.yaml:162`
- `action.yaml:163`
- `action.yaml:164`
- `action.yaml:165`

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

**Fixes applied:** unpinned-uses, script-injection, github-env-injection, static-inline-injection

**Notes:**

Fixed all findings across action.yaml, setup-env/action.yaml, upgrade/action.yaml, and install/action.yaml:

1. **unpinned-uses**: Pinned all 11 action references to immutable SHA digests with tag comments.

2. **script-injection / static-inline-injection**: Moved all ${{ }} expressions out of run: blocks into env: blocks:
   - action.yaml 'Set up inputs': All 20+ inputs.* and github.* expressions moved to env: block; run: block uses only shell variables
   - action.yaml 'Detect setup strategy': github.action_path → env: ACTION_PATH
   - action.yaml 'Post-init steps': inputs.post-init → env: POST_INIT, run uses `eval "$POST_INIT"`
   - action.yaml 'Run trunk check on pull/push/all/Trunk Merge': inputs.timeout-seconds → env: TIMEOUT_SECONDS
   - install/action.yaml 'Trunk install': inputs.tools → env: INPUT_TOOLS, uses ${INPUT_TOOLS:+"$INPUT_TOOLS"}
   - upgrade/action.yaml: github.action_path → env: ACTION_PATH in all 4 affected steps

3. **github-env-injection**: Added a `safe()` helper function (printf '%s' "$VAR" | tr -d '\n\r') in the 'Set up inputs' step. All values from the env: block are sanitized through safe() before being written to $GITHUB_ENV via heredoc, preventing newline injection attacks.

### Iteration 2

**Fixes applied:** script-injection, github-env-injection

**Notes:**

Fixed all security findings:

1. setup-env/action.yaml script injection (3 locations):
   - `run: ${{ env.INSTALL_CMD }}` → `run: $INSTALL_CMD` (plain env var, no template interpolation)
   - `if [ ${{ steps.setup_node.outcome }} == "success" ]` → moved expression to `env: SETUP_NODE_OUTCOME:` block, referenced as `"$SETUP_NODE_OUTCOME"` in shell
   - `if [ ${{ steps.install_packages.outcome }} == "success" ]` → moved expression to `env: INSTALL_PACKAGES_OUTCOME:` block, referenced as `"$INSTALL_PACKAGES_OUTCOME"` in shell

2. action.yaml script injection (2 locations):
   - `cd ${{ env.TRUNK_TMPDIR }} && unzip annotations.zip` → `cd "$TRUNK_TMPDIR" && unzip annotations.zip` (plain env var)
   - `eval "$POST_INIT"` → writes POST_INIT to a mktemp file and executes with `bash`, avoiding eval while preserving intended functionality

3. upgrade/upgrade.sh script injection:
   - Unquoted `${UPGRADE_ARGUMENTS}` → uses bash array populated via `read -ra upgrade_args <<< "${UPGRADE_ARGUMENTS}"` to safely pass arguments without shell metacharacter interpretation; removed the shellcheck suppression comment

4. action.yaml github-env-injection:
   - The payload() heredoc block that wrote unsanitized GitHub event JSON values to $GITHUB_ENV → each payload value is now individually sanitized with `safe()` (strips newlines via `tr -d '\n\r'`) before being written to the heredoc, preventing newline injection attacks

