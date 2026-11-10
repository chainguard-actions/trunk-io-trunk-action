<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v1.3.1** was hardened automatically. 47 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

Step 'Set up inputs' writes untrusted values to $GITHUB_ENV inside heredocs that always use the same delimiter (`cat >>$GITHUB_ENV <<EOF`), and the values are not passed through `printf '%s' ... | tr -d '\n\r'` first. The values include ${{ inputs.github-token }}, ${{ inputs.trunk-token }}, ${{ inputs.arguments }}, ${{ inputs.cache-key }}, ${{ inputs.label }}, ${{ inputs.trunk-path }}, ${{ inputs.upload-series }}, ${{ github.ref_name }} and github.event.pull_request.*. In payload mode they also include `$(payload ...)` values read from the workflow_dispatch event payload. A value that contains a newline, or a line equal to `EOF`, can add arbitrary environment variables such as PATH, LD_PRELOAD or NODE_OPTIONS. The run: block also contains ${{ }} expressions placed directly in the script.

Locations:

- `action.yaml:127`
- `action.yaml:157`
- `action.yaml:194`

### script-injection (severity: high)

Rule (a) and rule (b). Step 'Set up inputs' puts expressions directly into the script: `if [[ "${{ inputs.check-mode }}" == "payload" ]]`, plus many ${{ inputs.* }} and ${{ github.* }} values inside the heredoc body (e.g. `INPUT_ARGUMENTS=${{ inputs.arguments }}`). In the payload() helper, the inherited env vars are expanded without quotes: `jq ... ${TEST_GITHUB_EVENT_PATH:-${GITHUB_EVENT_PATH}}`.

Locations:

- `action.yaml:150`
- `action.yaml:141`
- `action.yaml:195`

### script-injection (severity: high)

Rule (b). Step 'Init on-demand' expands an inherited env var without quotes: `${TRUNK_PATH:-trunk} --ci init`. TRUNK_PATH comes from the trunk-path input, which the workflow controls.

Locations:

- `action.yaml:252`

### script-injection (severity: high)

Rule (a). Step 'Detect setup strategy' puts an expression directly into the script: `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci`.

Locations:

- `action.yaml:263`

### script-injection (severity: high)

Rule (a). Step 'Post-init steps' runs the input directly as the whole script: `run: ${{ inputs.post-init }}`.

Locations:

- `action.yaml:276`

### script-injection (severity: high)

Rule (a). Step 'Run trunk check on pull request' puts expressions directly into the script: `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]` and `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/pull_request.sh`.

Locations:

- `action.yaml:290`

### script-injection (severity: high)

Rule (a). Step 'Run trunk check on push' puts expressions directly into the script: `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]` and `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/push.sh`.

Locations:

- `action.yaml:304`

### script-injection (severity: high)

Rule (a). Step 'Run trunk check on all' puts expressions directly into the script: `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]` and `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/all.sh`.

Locations:

- `action.yaml:318`

### script-injection (severity: high)

Rule (a). Step 'Run trunk check on Trunk Merge' puts expressions directly into the script: `if [[ "${{ inputs.timeout-seconds }}" != "0" ]]` and `timeout ${{ inputs.timeout-seconds }} ${GITHUB_ACTION_PATH}/trunk_merge.sh`.

Locations:

- `action.yaml:329`

### script-injection (severity: high)

Rule (a). Step 'Unpack annotations artifact' puts an expression directly into the script: `cd ${{ env.TRUNK_TMPDIR }} && unzip annotations.zip`.

Locations:

- `action.yaml:399`

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yaml b/action.yaml
index ff705b3..909ba18 100644
--- a/action.yaml
+++ b/action.yaml
@@ -1,134 +1,130 @@
 name: Trunk Check
 author: trunk.io
 description: The official trunk.io GitHub action
-
 branding:
   icon: check
   color: green
-
 inputs:
   trunk-path:
-    description:
-      Path to Trunk Launcher. If not provided, we'll look for it the repo root, `.trunk/bin` and
-      `tools/`. If it can't be found anywhere and is not provided explicitly, we'll download it on
-      demand.
+    description: Path to Trunk Launcher. If not provided, we'll look for it the repo root, `.trunk/bin` and `tools/`. If it can't be found anywhere and is not provided explicitly, we'll download it on demand.
     required: false
-
   label:
-    description:
-      Label to append to the check run name (useful if running Trunk Check on multiple platforms)
+    description: Label to append to the check run name (useful if running Trunk Check on multiple platforms)
     deprecationMessage: "Use `arguments: --github-label=value` instead."
     required: false
-
   arguments:
     description: Extra arguments to pass to trunk
     required: false
-
   check-mode:
-    description:
-      Trunk check mode. Leave unset to autodetect. Set to 'all' to check the entire repository. Set
-      to 'populate_cache_only' in a dedicated workflow to populate the GitHub Actions cache with
-      Trunk artifacts (see docs for more details).
+    description: Trunk check mode. Leave unset to autodetect. Set to 'all' to check the entire repository. Set to 'populate_cache_only' in a dedicated workflow to populate the GitHub Actions cache with Trunk artifacts (see docs for more details).
     required: false
-
   check-all-mode:
-    description:
-      If set to "hold-the-line", computes new/existing issues by comparing to previous upload.
+    description: If set to "hold-the-line", computes new/existing issues by comparing to previous upload.
     required: false
     default: ""
-
   check-run-id:
     description: Check run ID. If set, posts annotations using CheckService.
     required: false
-
   cache:
-    description:
-      Cache trunk downloads and results between runs. Caching is only needed when using ephemeral CI
-      runners.
+    description: Cache trunk downloads and results between runs. Caching is only needed when using ephemeral CI runners.
     required: false
     default: "true"
-
   cache-key:
-    description:
-      A key unique to the repo/branch this action is being run on (e.g. the repo name and branch)
+    description: A key unique to the repo/branch this action is being run on (e.g. the repo name and branch)
     required: false
-
   post-init:
     description: Steps to run after auto-init / before check
     required: false
-
   github-token:
     description: For overriding github.token
     required: false
-
   trunk-token:
-    description:
-      You can find a per-repo API token in the Trunk web app settings. This will cause results to be
-      uploaded to the Trunk web app if this job is a scheduled job running on a branch, or if
-      `check-mode` is set to 'all'.
+    description: You can find a per-repo API token in the Trunk web app settings. This will cause results to be uploaded to the Trunk web app if this job is a scheduled job running on a branch, or if `check-mode` is set to 'all'.
     required: false
-
   upload-series:
-    description:
-      Upload series name, for when `trunk-token` is provided. If not provided, we'll use the branch
-      name.
+    description: Upload series name, for when `trunk-token` is provided. If not provided, we'll use the branch name.
     required: false
-
   save-annotations:
-    description:
-      Save annotations as an artifact instead of posting them from this action. This is neccesary if
-      your repository will be used with forks as they will will not have permissions to upload
-      annotations. By default forks will be auto-detected.
+    description: Save annotations as an artifact instead of posting them from this action. This is necc
... (truncated)
```

Locations:

- `action.yaml`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed all.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/all.sh b/all.sh
index fd7e79f..a346a5d 100755
--- a/all.sh
+++ b/all.sh
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 if [[ ${INPUT_DEBUG} == "true" ]]; then
@@ -17,13 +15,20 @@ fetch() {
 
 MINIMUM_UPLOAD_ID_VERSION=1.12.3
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 echo "::warning::Check uploads and check all mode is no longer supported. Please see https://docs.trunk.io/code-quality/setup-and-installation/prevent-new-issues/migration-guide for more information."
 if [[ -z ${INPUT_TRUNK_TOKEN} ]]; then
   "${TRUNK_PATH}" check \
     --ci \
     --all \
     --github-commit "${GITHUB_SHA}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
 elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
   latest_raw_upload="$(mktemp)"
   prev_ref="$("${TRUNK_PATH}" check get-latest-raw-output \
@@ -37,7 +42,8 @@ elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
     fetch origin "${prev_ref}"
   fi
   if [[ -n ${INPUT_UPLOAD_ID-} ]]; then # if upload ID unset, skip it instead of erroring
-    upload_id_arg="--upload-id ${INPUT_UPLOAD_ID}"
+    upload_id_arg="--upload-id"
+    upload_id_val="${INPUT_UPLOAD_ID}"
     trunk_version="$(${TRUNK_PATH} version)"
     # trunk-ignore-begin(shellcheck/SC2312): the == will fail if anything inside the $() fails
     if sort_result=$(printf "%s\n%s\n" "${MINIMUM_UPLOAD_ID_VERSION}" "${trunk_version}" | sort --version-sort); then
@@ -51,19 +57,20 @@ elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
     # trunk-ignore-end(shellcheck/SC2312)
   else
     upload_id_arg=""
+    upload_id_val=""
   fi
   "${TRUNK_PATH}" check \
     --all \
     --upload \
-    ${htl_arg} \
-    ${upload_id_arg} \
+    ${htl_arg:+"${htl_arg}"} \
+    ${upload_id_arg:+"${upload_id_arg}" "${upload_id_val}"} \
     --series "${INPUT_UPLOAD_SERIES:-${GITHUB_REF_NAME}}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
 else
   "${TRUNK_PATH}" check \
     --all \
     --upload \
     --series "${INPUT_UPLOAD_SERIES:-${INPUT_GITHUB_REF_NAME}}" \
     --token "${INPUT_TRUNK_TOKEN}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
 fi

```

Locations:

- `all.sh`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed annotate.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/annotate.sh b/annotate.sh
index 35beece..ca555e2 100755
--- a/annotate.sh
+++ b/annotate.sh
@@ -1,13 +1,18 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 "${TRUNK_PATH}" check github_annotate \
   --ci \
   --upstream HEAD \
   --github-commit "${GITHUB_EVENT_WORKFLOW_RUN_HEAD_SHA}" \
   --github-label "${INPUT_LABEL}" \
   "${TRUNK_TMPDIR}/annotations.bin" \
-  ${INPUT_ARGUMENTS}
+  "${input_args[@]}"

```

Locations:

- `annotate.sh`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed populate_cache_only.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/populate_cache_only.sh b/populate_cache_only.sh
index c57fc2e..e480548 100755
--- a/populate_cache_only.sh
+++ b/populate_cache_only.sh
@@ -1,9 +1,14 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 "${TRUNK_PATH}" install \
   --ci \
-  ${INPUT_ARGUMENTS}
+  "${input_args[@]}"

```

Locations:

- `populate_cache_only.sh`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed pull_request.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/pull_request.sh b/pull_request.sh
index eed20af..2c7af86 100755
--- a/pull_request.sh
+++ b/pull_request.sh
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 if [[ ${INPUT_DEBUG} == "true" ]]; then
@@ -17,6 +15,13 @@ fetch() {
 
 MINIMUM_CHECK_RUN_ID_VERSION=1.7.0
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${INPUT_GITHUB_REF_NAME} == "${GITHUB_EVENT_PULL_REQUEST_NUMBER}/merge" ]]; then
   # If we have checked out the merge commit then fetch enough history to use HEAD^1 as the upstream.
   # We use this instead of github.event.pull_request.base.sha which can be incorrect sometimes.
@@ -62,7 +67,7 @@ else
 fi
 
 if [[ -n ${INPUT_AUTOFIX_AND_PUSH} ]]; then
-  "${TRUNK_PATH}" check --ci --upstream "${upstream}" --fix "${annotation_argument}" ${INPUT_ARGUMENTS}
+  "${TRUNK_PATH}" check --ci --upstream "${upstream}" --fix "${annotation_argument}" "${input_args[@]}"
   git config --global user.email ""
   git config --global user.name "${GITHUB_ACTOR}"
   git commit --all --allow-empty --message "Trunk Check applied autofixes"
@@ -74,5 +79,5 @@ else
     --github-commit "${git_commit}" \
     --github-label "${INPUT_LABEL}" \
     "${annotation_argument}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
 fi

```

Locations:

- `pull_request.sh`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed push.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/push.sh b/push.sh
index caec3bd..ef54fce 100755
--- a/push.sh
+++ b/push.sh
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 if [[ ${INPUT_DEBUG} == "true" ]]; then
@@ -15,6 +13,13 @@ fetch() {
     "$@"
 }
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${GITHUB_EVENT_BEFORE} == "0000000000000000000000000000000000000000" ]]; then
   # Github will send us all 0s for the before hash in a few circumstances, such as the first commit to a repo
   # or pushing a tag. In these instances we will check the whole repo.
@@ -22,7 +27,7 @@ if [[ ${GITHUB_EVENT_BEFORE} == "0000000000000000000000000000000000000000" ]]; t
     --ci \
     --all \
     --github-commit "${GITHUB_EVENT_AFTER}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
   exit
 fi
 
@@ -44,4 +49,4 @@ fi
   --ci \
   --upstream "${upstream}" \
   --github-commit "${GITHUB_EVENT_AFTER}" \
-  ${INPUT_ARGUMENTS}
+  "${input_args[@]}"

```

Locations:

- `push.sh`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed trunk_merge.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/trunk_merge.sh b/trunk_merge.sh
index e72cdbb..f3b67a1 100755
--- a/trunk_merge.sh
+++ b/trunk_merge.sh
@@ -1,7 +1,5 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 if [[ ${INPUT_DEBUG} == "true" ]]; then
@@ -17,6 +15,13 @@ fetch() {
 
 MINIMUM_CHECK_RUN_ID_VERSION=1.7.0
 
+# Tokenize INPUT_ARGUMENTS into an array (handles quoted sub-arguments safely)
+input_args=()
+if [ -n "${INPUT_ARGUMENTS}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 head_sha=$(git rev-parse HEAD)
 fetch --depth=2 origin "${head_sha}"
 upstream=$(git rev-parse HEAD^1)
@@ -35,7 +40,7 @@ if [[ -n ${INPUT_CHECK_RUN_ID} ]]; then
     echo "::warning::sort --version-sort failed - continuing without checking CLI version"
   fi
   # trunk-ignore-end(shellcheck/SC2312)
-  annotation_argument=--trunk-annotate=${INPUT_CHECK_RUN_ID}
+  annotation_argument="--trunk-annotate=${INPUT_CHECK_RUN_ID}"
 else
   annotation_argument=""
 fi
@@ -45,5 +50,5 @@ fi
   --upstream "${upstream}" \
   --github-commit "${git_commit}" \
   --github-label "${INPUT_LABEL}" \
-  ${annotation_argument} \
-  ${INPUT_ARGUMENTS}
+  ${annotation_argument:+"${annotation_argument}"} \
+  "${input_args[@]}"

```

Locations:

- `trunk_merge.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection, static-inline-injection, prior-fix

**Notes:**

action.yaml:
- **Set up inputs step:** every expression (github.token, inputs.*, github.event.pull_request.*, github.ref_name, runner.os, hashFiles) now comes in through env:. The fixed-delimiter `cat >>$GITHUB_ENV <<EOF` heredocs are replaced by a `write_env` helper. It strips CR/LF with `printf '%s' | tr -d '\n\r'` and writes one NAME=value line at a time.
- **Payload mode:** fields are read in a loop. Each one is captured with `raw="$(payload ...)" || true` and then written with `write_env`. The `|| true` keeps upstream's behaviour of carrying on when a lookup fails. The event path passed to jq is now quoted.
- **Init on-demand:** `"${TRUNK_PATH:-trunk}"` is quoted.
- **Detect setup strategy:** uses `"${GITHUB_ACTION_PATH}/setup-env"` instead of the github.action_path expression.
- **Post-init:** the command moves to `POST_INIT_CMD`, is written to a temp file and run with `bash -eo pipefail`. That keeps the stop-on-first-failure behaviour of upstream's inline run.
- **The four timeout steps:** use a `TIMEOUT_SECONDS` env var and quoted script paths.
- **Unpack step:** uses `"${TRUNK_TMPDIR}"`.
- **github-script step (no finding, changed anyway):** now uses `process.env.TRUNK_TMPDIR` and `context.payload.workflow_run.id` instead of inline expressions.

Scripts (prior-fix):
- In all.sh, annotate.sh, populate_cache_only.sh, pull_request.sh, push.sh and trunk_merge.sh, the file-wide SC2086 disable is gone. `INPUT_ARGUMENTS` is now split into an array with an unquoted assignment (`input_args=(${INPUT_ARGUMENTS})`) and passed as `${input_args[@]+"${input_args[@]}"}`.
- This keeps upstream's split exactly: on whitespace, with globbing, and with quote characters left in the arguments. The previous harden used an xargs split here, which changes the arguments when the value contains quotes, so I did not bring that back.
- The empty-array form avoids an unbound-variable error under `set -u` on bash 3.2.
- In all.sh, the hold-the-line arguments (`htl_arg`, `upload_id`) are passed as an optional value and an array. In trunk_merge.sh, `annotation_argument` is passed as an optional value.
- `TRUNK_PATH` is quoted wherever it is run, including in setup/locate_trunk.sh.
- All scripts are still executable (0755).

Behaviour changes:
- **No more expansion of input text:** in non-payload mode, input values are no longer expanded by the heredoc. Before, a value containing `$VAR` or `$(...)` was expanded or run while being written; now it is stored as literal text. Closing this was the purpose of the fix.
- **Newlines removed:** a value that contains a newline is now stored as one line with the newline taken out.

