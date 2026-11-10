<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v2.0.0** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): a GitHub Actions expression is placed directly inside run: scripts. The lines are `${{ github.action_path }}/../setup/locate_trunk.sh` (Locate trunk), `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci` (Detect setup strategy), `${{ github.action_path }}/upgrade.sh` (Run upgrade) and `${{ github.action_path }}/../cleanup.sh` (Cleanup temporary files). Use the quoted env var "$GITHUB_ACTION_PATH" instead.

Locations:

- `action.yaml:111`
- `action.yaml:131`
- `action.yaml:144`
- `action.yaml:154`

### github-env-injection (severity: high)

The 'Run upgrade' step (upgrade.sh) writes to $GITHUB_ENV in two unsafe ways. (f) It writes PR_DESCRIPTION, built from the `trunk upgrade` output (which runs with the workflow-controlled UPGRADE_ARGUMENTS / inputs.arguments), between the fixed heredoc delimiter `EOF`: `echo "PR_DESCRIPTION<<EOF"` ... `echo "EOF"`. Generate the delimiter from /dev/urandom on every run instead. It also writes `echo "PR_TITLE=${title_message}" >>"${GITHUB_ENV}"`, where title_message comes from parsed command output, without running it through `printf '%s' ... | tr -d '\n\r'` first.

Locations:

- `upgrade.sh:47`
- `upgrade.sh:52`
- `action.yaml:144`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/upgrade/action.yaml b/upgrade/action.yaml
index 434ff48..8afe753 100644
--- a/upgrade/action.yaml
+++ b/upgrade/action.yaml
@@ -1,117 +1,101 @@
 name: Trunk Upgrade
 author: trunk.io
 description: Upgrade trunk and its tools
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
   prefix:
     description: Prefix to be added in the PR title
     required: false
-
   arguments:
     description: Extra arguments to pass to trunk upgrade
     required: false
-
   base:
     description: The base branch to create a PR against
     required: false
     default: main
-
   github-token:
-    description:
-      A GitHub token to allow created PRs to run pull_request workflows. See
-      https://github.com/peter-evans/create-pull-request/blob/main/docs/concepts-guidelines.md#triggering-further-workflow-runs
-      for more information.
+    description: A GitHub token to allow created PRs to run pull_request workflows. See https://github.com/peter-evans/create-pull-request/blob/main/docs/concepts-guidelines.md#triggering-further-workflow-runs for more information.
     required: false
     default: ${{ github.token }}
-
   setup-deps:
-    description:
-      Install dependencies for trunk check that the trunk CLI does not manage. This is only
-      necessary if you have Node dependencies in your package.json that your Node linters need (e.g.
-      eslint dependencies, or @types packages).
+    description: Install dependencies for trunk check that the trunk CLI does not manage. This is only necessary if you have Node dependencies in your package.json that your Node linters need (e.g. eslint dependencies, or @types packages).
     required: false
     default: "false"
-
   branch-name:
     description: The branch name to generate the PR from
     default: trunk-io/update-trunk
     required: false
-
   assignees:
     description: A comma or newline separated list of GitHub assignee usernames
     required: false
-
   reviewers:
     description: A comma or newline separated list of GitHub reviewer usernames
     required: false
-
   labels:
     description: A comma or newline separated list of GitHub labels that should be added to the PR
     default: trunk
     required: false
-
   add-paths:
     description: Specific paths to add to the created pull request. Comma separated.
     required: false
     default: .trunk
-
   lowercase-title:
     description: A boolean to decide if the PR and commit message title should be in lowercase
     required: false
     default: false
-
   signoff:
     description: A boolean to add a Signed-off-by line to the commit message
     required: false
     default: false
-
   sign-commits:
-    description:
-      A boolean to sign commits. See
-      https://github.com/peter-evans/create-pull-request/blob/main/docs/concepts-guidelines.md#commit-signature-verification-for-bots
+    description: A boolean to sign commits. See https://github.com/peter-evans/create-pull-request/blob/main/docs/concepts-guidelines.md#commit-signature-verification-for-bots
     required: false
     default: false
-
 outputs:
   pull-request-number:
     description: The pull request number
     value: ${{ steps.cpr.outputs.pull-request-number }}
-
   pull-request-url:
     description: The URL of the pull request.
     value: ${{ steps.cpr.outputs.pull-request-url }}
-
   pull-request-operation:
-    description:
-      The pull request operation performed by the action, `created`, `updated` or `closed`.
+    description: The pull request operation performed by the action, `created`, `updated` or `closed`.
     value: ${{ steps
... (truncated)
```

Locations:

- `action.yaml`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed upgrade.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/upgrade/upgrade.sh b/upgrade/upgrade.sh
index bef5fab..05639ae 100755
--- a/upgrade/upgrade.sh
+++ b/upgrade/upgrade.sh
@@ -3,8 +3,12 @@
 set -euo pipefail
 
 # Step 1: Run upgrade and strip ANSI coloring.
-# trunk-ignore(shellcheck/SC2086): pass arguments directly as is
-upgrade_output=$(${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS} | sed -e 's/\x1b\[[0-9;]*m//g')
+upgrade_args=()
+if [ -n "${UPGRADE_ARGUMENTS:-}" ]; then
+  while IFS= read -r -d '' t; do upgrade_args+=("$t"); done \
+    < <(printf '%s' "${UPGRADE_ARGUMENTS}" | xargs printf '%s\0')
+fi
+upgrade_output=$("${TRUNK_PATH}" upgrade --no-progress -n "${upgrade_args[@]}" | sed -e 's/\x1b\[[0-9;]*m//g')
 
 # Step 2a: Parse output. If up to date, exit successfully.
 if [[ ${upgrade_output} == *"Already up to date"* ]]; then
@@ -27,7 +31,7 @@ fi
 
 # Step 3: Prepare for pull request creation action.
 # Avoid triggering a git-hook, and avoid resetting git hook config via daemon
-${TRUNK_PATH} daemon shutdown
+"${TRUNK_PATH}" daemon shutdown
 git config --local --unset core.hooksPath || true
 rm -f .trunk/landing-state.json
 
@@ -43,10 +47,14 @@ d
 }' "${GITHUB_ACTION_PATH}"/upgrade_pr.md)
 
 # Step 6: Write outputs
+safe_description=$(printf '%s' "${description}" | tr -d '\r')
+safe_title=$(printf '%s' "${title_message}" | tr -d '\n\r')
+# Use a random delimiter to prevent heredoc injection if description contains a line equal to the delimiter
+_env_delim="EOF_$(dd if=/dev/urandom bs=15 count=1 2>/dev/null | base64 | tr -dc 'A-Za-z0-9' | head -c 20)"
 {
-  echo "PR_DESCRIPTION<<EOF"
-  echo "${description}"
-  echo "EOF"
+  echo "PR_DESCRIPTION<<${_env_delim}"
+  echo "${safe_description}"
+  echo "${_env_delim}"
 } >>"${GITHUB_ENV}"
 
-echo "PR_TITLE=${title_message}" >>"${GITHUB_ENV}"
+echo "PR_TITLE=${safe_title}" >>"${GITHUB_ENV}"

```

Locations:

- `upgrade.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, prior-fix

**Notes:**

action.yaml: the four `${{ github.action_path }}` expressions inside run: scripts now use the quoted "$GITHUB_ACTION_PATH" environment variable instead. upgrade.sh: PR_DESCRIPTION is now written to GITHUB_ENV between a delimiter that is generated randomly from /dev/urandom on each run. The description's own lines are left as they are, because that heredoc form exists to carry a multi-line value. PR_TITLE has newlines stripped before it is written. TRUNK_PATH is now quoted. Two choices differ from the previous harden: (1) UPGRADE_ARGUMENTS is still expanded unquoted, as upstream does. Upstream already splits it on whitespace, and an unquoted variable only splits and globs; it doesn't run anything inside the value, so this isn't an injection risk. The earlier xargs rewrite would have honored quotes and changed how arguments are split. (2) The description is no longer stripped of carriage returns. That strip wasn't needed once the delimiter is random. The previous harden also put each multi-line input description on one line; that had no security effect, so I didn't repeat it.

