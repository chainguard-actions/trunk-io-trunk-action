<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action/v2.0.0** was hardened automatically. 36 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

Step 'Set up inputs' writes untrusted values to $GITHUB_ENV with no `printf '%s' | tr -d '\n\r'` sanitization. Examples: `echo "INPUT_TIMEOUT_SECONDS=${{ inputs.timeout-seconds }}" >>"${GITHUB_ENV}"`, and two `cat >>$GITHUB_ENV <<EOF` heredocs. The first heredoc writes INPUT_ARGUMENTS, INPUT_LABEL, INPUT_TRUNK_PATH, INPUT_CACHE_KEY, INPUT_UPLOAD_SERIES, GITHUB_REF_NAME and others straight from ${{ inputs.* }} / ${{ github.* }}. The second writes $(payload ...) values read from the workflow_dispatch event payload. The shell heredoc delimiter is only for bash. The lines still go into GITHUB_ENV as single-line KEY=value entries. A value that contains a newline can therefore inject arbitrary environment variables such as LD_PRELOAD, BASH_ENV or PATH into later steps.

Locations:

- `action.yaml:133`
- `action.yaml:168`
- `action.yaml:213`

### script-injection (severity: high)

Step 'Set up inputs' breaks rule (a): many expressions are placed directly in the run script. Examples: `echo "INPUT_TIMEOUT_SECONDS=${{ inputs.timeout-seconds }}"`, `if [[ "${{ inputs.check-mode }}" == "payload" ]]`, `INPUT_GITHUB_TOKEN=${{ github.token }}`, `if [[ -n "${{ inputs.github-token }}" ]]`, `echo "::add-mask::${{ inputs.trunk-token }}"`, and every `${{ inputs.* }}` / `${{ github.* }}` / `${{ runner.os }}` line in the heredoc. One is `INPUT_ARGUMENTS=${{ inputs.arguments }}`, which sits inside an unquoted heredoc, so bash runs any $(...) in it. The step also breaks rule (b): `${TEST_GITHUB_EVENT_PATH:-${GITHUB_EVENT_PATH}}` is expanded unquoted, and TEST_GITHUB_EVENT_PATH is inherited from the calling workflow.

Locations:

- `action.yaml:133`
- `action.yaml:143`
- `action.yaml:152`
- `action.yaml:158`
- `action.yaml:206`
- `action.yaml:223`

### script-injection (severity: high)

Step 'Init on-demand' breaks rule (b): `${TRUNK_PATH:-trunk} --ci init` expands TRUNK_PATH without quotes. TRUNK_PATH is workflow-controlled: it comes from inputs.trunk-path or the payload through GITHUB_ENV, or it is inherited from the caller.

Locations:

- `action.yaml:274`

### script-injection (severity: high)

Step 'Detect setup strategy' breaks rule (a): `ln -s ${{ github.action_path }}/setup-env .trunk/setup-ci` puts an expression directly in the run script. Use "$GITHUB_ACTION_PATH" (quoted) instead.

Locations:

- `action.yaml:285`

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

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/action.yaml b/action.yaml
index 0743a6b..1edd23e 100644
--- a/action.yaml
+++ b/action.yaml
@@ -1,136 +1,128 @@
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
-    deprecationMessage:
-      The Trunk web app has been shut down; hold-the-line uploads are no longer supported.
+    description: If set to "hold-the-line", computes new/existing issues by comparing to previous upload.
+    deprecationMessage: The Trunk web app has been shut down; hold-the-line uploads are no longer supported.
     required: false
     default: ""
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
-    description:
-      Trusted shell to run after auto-init / before check (caller-controlled escape hatch).
+    description: Trusted shell to run after auto-init / before check (caller-controlled escape hatch).
     required: false
-
   github-token:
-    description:
-      GitHub token for API/checkout. Defaults to github.token; pass a PAT/App secret only for extra
-      permissions.
+    description: GitHub token for API/checkout. Defaults to github.token; pass a PAT/App secret only for extra permissions.
     required: false
     default: ${{ github.token }}
-
   trunk-token:
-    description:
-      You can find a per-repo API token in the Trunk web app settings. This will cause results to be
-      uploaded to the Trunk web app if this job is a scheduled job running on a branch, or if
-      `check-mode` is set to 'all'.
+    description: You can find a per-repo API token in the Trunk web app settings. This will cause results to be uploaded to the Trunk web app if this job is a scheduled job running on a branch, or if `check-mode` is set to 'all'.
     deprecationMessage: The Trunk web app has been shut down; uploads are no longer supported.
     required: false
-
   upload-series:
-    description:
-      Upload series name, for when `trunk-tok
... (truncated)
```

Locations:

- `action.yaml`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed all.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/all.sh b/all.sh
index ef3a3d7..600b758 100755
--- a/all.sh
+++ b/all.sh
@@ -1,12 +1,18 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 # shellcheck source=git_github.sh
 source "${BASH_SOURCE[0]%/*}/git_github.sh"
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${INPUT_DEBUG} == "true" ]]; then
   set -x
 fi
@@ -19,7 +25,7 @@ if [[ -z ${INPUT_TRUNK_TOKEN} ]]; then
     --ci \
     --all \
     --github-commit "${GITHUB_SHA}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
 elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
   latest_raw_upload="$(mktemp)"
   prev_ref="$("${TRUNK_PATH}" check get-latest-raw-output \
@@ -54,12 +60,12 @@ elif [[ ${INPUT_CHECK_ALL_MODE} == "hold-the-line" ]]; then
     ${htl_arg} \
     ${upload_id_arg} \
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
index 35beece..4a3bb24 100755
--- a/annotate.sh
+++ b/annotate.sh
@@ -1,13 +1,19 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
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
index c57fc2e..d75f6d6 100755
--- a/populate_cache_only.sh
+++ b/populate_cache_only.sh
@@ -1,9 +1,15 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
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
index f817e4b..0f61150 100755
--- a/pull_request.sh
+++ b/pull_request.sh
@@ -1,12 +1,18 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 # shellcheck source=git_github.sh
 source "${BASH_SOURCE[0]%/*}/git_github.sh"
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${INPUT_DEBUG} == "true" ]]; then
   set -x
 fi
@@ -43,7 +49,7 @@ else
 fi
 
 if [[ -n ${INPUT_AUTOFIX_AND_PUSH} ]]; then
-  "${TRUNK_PATH}" check --ci --upstream "${upstream}" --fix "${annotation_argument}" ${INPUT_ARGUMENTS}
+  "${TRUNK_PATH}" check --ci --upstream "${upstream}" --fix "${annotation_argument}" "${input_args[@]}"
   git config --global user.email ""
   git config --global user.name "${GITHUB_ACTOR}"
   git commit --all --allow-empty --message "Trunk Check applied autofixes"
@@ -55,5 +61,5 @@ else
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
index 3025c8d..3a4d285 100755
--- a/push.sh
+++ b/push.sh
@@ -1,12 +1,18 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 # shellcheck source=git_github.sh
 source "${BASH_SOURCE[0]%/*}/git_github.sh"
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${INPUT_DEBUG} == "true" ]]; then
   set -x
 fi
@@ -18,7 +24,7 @@ if [[ ${GITHUB_EVENT_BEFORE} == "0000000000000000000000000000000000000000" ]]; t
     --ci \
     --all \
     --github-commit "${GITHUB_EVENT_AFTER}" \
-    ${INPUT_ARGUMENTS}
+    "${input_args[@]}"
   exit
 fi
 
@@ -40,4 +46,4 @@ fi
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
index a905159..abf6d4e 100755
--- a/trunk_merge.sh
+++ b/trunk_merge.sh
@@ -1,12 +1,18 @@
 #!/bin/bash
 
-# shellcheck disable=SC2086
-
 set -euo pipefail
 
 # shellcheck source=git_github.sh
 source "${BASH_SOURCE[0]%/*}/git_github.sh"
 
+# Tokenize INPUT_ARGUMENTS (a caller-controlled list of extra flags) in a
+# quote-aware manner so that shell metacharacters are never evaluated.
+input_args=()
+if [ -n "${INPUT_ARGUMENTS:-}" ]; then
+  while IFS= read -r -d '' t; do input_args+=("$t"); done \
+    < <(printf '%s' "${INPUT_ARGUMENTS}" | xargs printf '%s\0')
+fi
+
 if [[ ${INPUT_DEBUG} == "true" ]]; then
   set -x
 fi
@@ -22,4 +28,4 @@ echo "Detected merge queue commit, using HEAD^1 (${upstream}) as upstream and HE
   --upstream "${upstream}" \
   --github-commit "${git_commit}" \
   --github-label "${INPUT_LABEL}" \
-  ${INPUT_ARGUMENTS}
+  "${input_args[@]}"

```

Locations:

- `trunk_merge.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection, static-inline-injection, prior-fix

**Notes:**

action.yaml changes:
- 'Set up inputs': every ${{ }} expression (the inputs, github.token, github.event.pull_request.*, github.ref_name, runner.os, hashFiles) now goes through the step's env: block as an IN_* variable. Both unquoted heredocs (`cat >>$GITHUB_ENV <<EOF`) are gone. In their place is a put() helper that strips CR/LF from each value with `printf '%s' | tr -d '\n\r'` and then writes one KEY=value line. Values are no longer run through the shell, so `$(...)` inside inputs.arguments is never executed.
- The payload values are written by put_payload(), which runs `raw="$(payload ...)" || true`. This keeps upstream's behaviour, where a failing lookup inside the heredoc did not stop the step.
- `${TEST_GITHUB_EVENT_PATH:-${GITHUB_EVENT_PATH}}` is now quoted. INPUT_CACHE_PATH is still the literal '~/.cache/trunk', as the heredoc wrote it.
- 'Init on-demand': changed to `"${TRUNK_PATH:-trunk}" --ci init`.
- 'Detect setup strategy': changed to `ln -s "${GITHUB_ACTION_PATH}/setup-env" .trunk/setup-ci`.
- The post-init step was left as it was. It already runs the command from env with `-eo pipefail`, so it still stops at the first failing line like upstream.

Re-applied changes from the previous harden: the security part of the action.yaml patch, which is the env/sanitization work above. I did not bring back its reformatting of the input descriptions.

Not re-applied, on purpose: the previous harden's changes to all.sh, annotate.sh, populate_cache_only.sh, pull_request.sh, push.sh and trunk_merge.sh.
- These scripts expand ${INPUT_ARGUMENTS} unquoted. That only splits on whitespace and expands globs; it never runs anything, so it is not an injection risk. The real injection was the heredoc in action.yaml, which is now fixed.
- The previous patch replaced the unquoted expansion with `xargs printf '%s\0'`. That would change behaviour in four ways: it honours quotes upstream treated as plain text, drops every argument after an apostrophe, stops globbing, and lets a lone --version or --help be swallowed by the external printf.
- It would also expand an empty array under `set -u`, which fails on bash 3.2 (macOS runners).
- So the scripts are unchanged from upstream.

