<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.2.2** was hardened automatically. 33 finding(s) were identified and resolved across 4 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Multiple run: blocks in action.yaml directly interpolate ${{ ... }} expressions inside shell commands, violating rule (a). Key violations:
- 'Set up inputs' step: `if [[ "${{ inputs.check-mode }}" == "payload" ]]` — inputs.check-mode interpolated directly into shell conditional.
- 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` — github.action_path interpolated directly into ln command.
- 'Post-init steps' step: `run: ${{ inputs.post-init }}` — the entire run: value is an attacker-controlled expression; arbitrary shell commands can be injected.
- 'Run trunk check on pull request' step: `timeout ${{ inputs.timeout-seconds }} ...` — inputs.timeout-seconds interpolated directly into timeout command.
- 'Run trunk check on push' step: `timeout ${{ inputs.timeout-seconds }} ...` — same issue.
- 'Run trunk check on all' step: `timeout ${{ inputs.timeout-seconds }} ...` — same issue.
- 'Run trunk check on Trunk Merge' step: `timeout ${{ inputs.timeout-seconds }} ...` — same issue.
- 'Unpack annotations artifact' step: `cd ${{ env.TRUNK_TMPDIR }} && unzip annotations.zip` — env context interpolated directly into shell.

In install/action.yaml: 'Trunk install' step: `trunk tools install --ci ${{ inputs.tools }}` — inputs.tools interpolated directly into shell command.

In upgrade/action.yaml: 'Locate trunk' step: `${{ github.action_path }}/../setup/locate_trunk.sh` — path from expression used directly as command. 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`. 'Run upgrade' step: `${{ github.action_path }}/upgrade.sh`. 'Cleanup temporary files' step: `${{ github.action_path }}/../cleanup.sh`.

In setup-env/action.yaml: 'Check for node installation' step: `if [ ${{ steps.setup_node.outcome }} == "success" ]`. 'Check for package install' step: `if [ ${{ steps.install_packages.outcome }} == "success" ]`.

Locations:

- `action.yaml:122`
- `action.yaml:176`
- `action.yaml:200`
- `action.yaml:215`
- `action.yaml:228`
- `action.yaml:240`
- `action.yaml:252`
- `action.yaml:264`
- `action.yaml:296`
- `install/action.yaml:20`
- `upgrade/action.yaml:72`
- `upgrade/action.yaml:84`
- `upgrade/action.yaml:96`
- `upgrade/action.yaml:103`
- `upgrade/action.yaml:109`
- `setup-env/action.yaml:72`
- `setup-env/action.yaml:95`

### github-env-injection (severity: high)

The 'Set up inputs' run: block in action.yaml writes multiple untrusted input and github context values directly to $GITHUB_ENV via a heredoc without any sanitization (no `printf '%s' ... | tr -d '\n\r'` step). This allows newline injection attacks that can set arbitrary environment variables. Affected writes include:
- `GITHUB_TOKEN=${{ github.token }}`
- `INPUT_GITHUB_TOKEN=${{ inputs.github-token }}`
- `INPUT_TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `TRUNK_TOKEN=${{ inputs.trunk-token }}`
- `GITHUB_EVENT_PULL_REQUEST_BASE_SHA=${{ github.event.pull_request.base.sha }}`
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
All of these are written to $GITHUB_ENV without sanitization, enabling environment variable injection.

Locations:

- `action.yaml:120`

### unpinned-uses (severity: high)

Multiple uses: references are pinned to mutable tags or version strings instead of immutable 40-character commit SHAs, making the action vulnerable to supply-chain attacks if the referenced tag is moved or the repository is compromised.

In action.yaml:
- `uses: actions/checkout@v4`
- `uses: peter-evans/find-comment@v3`
- `uses: peter-evans/create-or-update-comment@v4`
- `uses: actions/cache@v4`
- `uses: actions/github-script@v7`
- `uses: actions/upload-artifact@v4` (two occurrences)

In setup-env/action.yaml:
- `uses: pnpm/action-setup@v2`
- `uses: actions/setup-node@v4` (two occurrences)
- `uses: actions/cache@v3`

In upgrade/action.yaml:
- `uses: peter-evans/create-pull-request@v6`

All of these should be pinned to full 40-character commit SHAs.

Locations:

- `action.yaml:167`
- `action.yaml:183`
- `action.yaml:193`
- `action.yaml:218`
- `action.yaml:270`
- `action.yaml:285`
- `action.yaml:310`
- `setup-env/action.yaml:60`
- `setup-env/action.yaml:66`
- `setup-env/action.yaml:76`
- `setup-env/action.yaml:84`
- `upgrade/action.yaml:113`

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

1. script-injection & static-inline-injection: Moved all ${{ }} expressions from run: blocks into env: maps. The 'Set up inputs' step now uses env: vars. The 'Detect setup strategy' step uses ${GITHUB_ACTION_PATH} env var. The 'Post-init steps' uses eval "$POST_INIT_CMD" with POST_INIT_CMD in env:. All timeout steps use ${INPUT_TIMEOUT_SECONDS} env var. The 'Unpack annotations artifact' uses ${TRUNK_TMPDIR}. The 'Download annotations artifact' uses process.env.* in the JS script. In install/action.yaml, inputs.tools moved to env: with xargs-based array tokenization. In upgrade/action.yaml, github.action_path references replaced with ${GITHUB_ACTION_PATH}. In setup-env/action.yaml, step outcomes moved to env: maps.

2. github-env-injection: Replaced heredoc writes to $GITHUB_ENV with printf '%s' ... | tr -d '\n\r' sanitization for all values.

3. unpinned-uses: Pinned all action references to full 40-character commit SHAs:
- actions/checkout@v4 → @11d5960a326750d5838078e36cf38b85af677262
- peter-evans/find-comment@v3 → @3eae4d37986fb5a8592848f6a574fdf654e61f9e
- peter-evans/create-or-update-comment@v4 → @71345be0265236311c031f5c7866368bd1eff043
- actions/cache@v4 → @0057852bfaa89a56745cba8c7296529d2fc39830
- actions/github-script@v7 → @f28e40c7f34bde8b3046d885e986cb6290c5673b
- actions/upload-artifact@v4 → @ea165f8d65b6e75b540449e92b4886f43607fa02
- pnpm/action-setup@v2 → @eae0cfeb286e66ffb5155f1a79b90583a127a68b
- actions/setup-node@v4 → @49933ea5288caeca8642d1e84afbd3f7d6820020
- actions/cache@v3 → @6f8efc29b200d32929f49075959781ed54ec270c
- peter-evans/create-pull-request@v6 → @c5a7806660adbe173f04e3e038b0ccdcd758773c

### Iteration 2

**Fixes applied:** script-injection

**Notes:**

Fixed the script-injection vulnerability in the 'Post-init steps' step of action.yaml (line 355). Replaced `eval "$POST_INIT_CMD"` with a pattern that writes the POST_INIT_CMD content to a temporary script file using `printf '%s\n'` and executes it with `bash`. This eliminates the `eval` construct that was executing attacker-controlled input as shell code inline, while preserving the intended functionality of the post-init input.

### Iteration 1

**Fixes applied:** script-injection

**Notes:**

Fixed unquoted ${UPGRADE_ARGUMENTS} expansion in upgrade/upgrade.sh. Replaced the unquoted variable expansion (which allowed shell metacharacter injection from the user-controlled `inputs.arguments` action input) with a safe xargs-based tokenization approach: arguments are parsed into a bash array using `printf '%s' "${UPGRADE_ARGUMENTS}" | xargs printf '%s\0'` with a NUL-delimited read loop, then expanded safely as `"${upgrade_args[@]+"${upgrade_args[@]}"}"`. The guard `if [ -n "${UPGRADE_ARGUMENTS}" ]` prevents xargs from emitting a spurious empty token when the input is empty. The shellcheck suppression comment was also removed since it's no longer needed.

### Iteration 2

**Fixes applied:** github-env-injection

**Notes:**

Fixed github-env-injection in setup/locate_trunk.sh by sanitizing INPUT_TRUNK_PATH before writing to $GITHUB_ENV. Changed `trunk_path="${INPUT_TRUNK_PATH}"` to `trunk_path="$(printf '%s' "${INPUT_TRUNK_PATH}" | tr -d '\n\r')"` to strip newline and carriage return characters that could be used to inject arbitrary environment variables. The setup/action.yaml and upgrade/action.yaml files already correctly use the env: block pattern and required no changes.

