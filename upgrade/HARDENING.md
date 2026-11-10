<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--upgrade/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--upgrade/v1.3.1** was hardened automatically. 8 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the expression is placed directly in the run script of the 'Locate trunk' step: `${{ github.action_path }}/../setup/locate_trunk.sh`. Use "$GITHUB_ACTION_PATH" instead.

Locations:

- `action.yaml:111`

### script-injection (severity: high)

Rule (a): the expression is placed directly in the run script of the 'Detect setup strategy' step: `ln -s ${{ github.action_path }}/../setup-env .trunk/setup-ci`. Use "$GITHUB_ACTION_PATH" instead.

Locations:

- `action.yaml:131`

### script-injection (severity: high)

Rule (a): the expression is placed directly in the run script of the 'Run upgrade' step: `${{ github.action_path }}/upgrade.sh`. Use "$GITHUB_ACTION_PATH" instead.

Locations:

- `action.yaml:144`

### script-injection (severity: high)

Rule (a): the expression is placed directly in the run script of the 'Cleanup temporary files' step: `${{ github.action_path }}/../cleanup.sh`. Use "$GITHUB_ACTION_PATH" instead.

Locations:

- `action.yaml:154`

### script-injection (severity: high)

Rule (b): upgrade.sh, which the 'Run upgrade' step runs, expands workflow-controlled variables without quotes. Line 7 is `upgrade_output=$(${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS} | ...)`. UPGRADE_ARGUMENTS comes from inputs.arguments, and TRUNK_PATH comes from the inherited environment or the trunk-path input. Line 30 is `${TRUNK_PATH} daemon shutdown`, also unquoted. Neither line is an array assignment with an SC2086/SC2206 shellcheck directive, so the exemption does not apply. Quote TRUNK_PATH. Split UPGRADE_ARGUMENTS into an array first, e.g. `# shellcheck disable=SC2206` followed by `args=(${UPGRADE_ARGUMENTS})`, then pass "${args[@]}".

Locations:

- `upgrade.sh:7`
- `upgrade.sh:30`

### github-env-injection (severity: high)

upgrade.sh writes values derived from command output to $GITHUB_ENV unsafely. That output comes from `trunk upgrade` run with the workflow-controlled inputs.arguments. (1) PR_DESCRIPTION is written between a FIXED heredoc delimiter (`echo "PR_DESCRIPTION<<EOF"` ... `echo "EOF"`), which is case (f). If the description contains a line equal to EOF, the block ends early and the lines after it become new env variables. Generate the delimiter from /dev/urandom or openssl rand instead. (2) `echo "PR_TITLE=${title_message}" >> "${GITHUB_ENV}"` writes a value built from the parsed upgrade output without the `printf '%s' ... | tr -d '\n\r'` sanitization.

Locations:

- `upgrade.sh:46`
- `upgrade.sh:51`

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
index bef5fab..3f01d5e 100755
--- a/upgrade/upgrade.sh
+++ b/upgrade/upgrade.sh
@@ -3,8 +3,12 @@
 set -euo pipefail
 
 # Step 1: Run upgrade and strip ANSI coloring.
-# trunk-ignore(shellcheck/SC2086): pass arguments directly as is
-upgrade_output=$(${TRUNK_PATH} upgrade --no-progress -n ${UPGRADE_ARGUMENTS} | sed -e 's/\x1b\[[0-9;]*m//g')
+upgrade_args=()
+if [ -n "${UPGRADE_ARGUMENTS}" ]; then
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
 
@@ -43,10 +47,8 @@ d
 }' "${GITHUB_ACTION_PATH}"/upgrade_pr.md)
 
 # Step 6: Write outputs
-{
-  echo "PR_DESCRIPTION<<EOF"
-  echo "${description}"
-  echo "EOF"
-} >>"${GITHUB_ENV}"
+safe_title=$(printf '%s' "${title_message}" | tr -d '\n\r')
+echo "PR_TITLE=${safe_title}" >>"${GITHUB_ENV}"
 
-echo "PR_TITLE=${title_message}" >>"${GITHUB_ENV}"
+safe_description=$(printf '%s' "${description}" | tr -d '\n\r')
+echo "PR_DESCRIPTION=${safe_description}" >>"${GITHUB_ENV}"

```

Locations:

- `upgrade.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, prior-fix

**Notes:**

action.yaml: the four inline ${{ github.action_path }} uses (locate_trunk.sh, the setup-env symlink, upgrade.sh, cleanup.sh) now use a quoted "$GITHUB_ACTION_PATH", and $GITHUB_ENV is quoted. upgrade.sh: TRUNK_PATH is quoted in both places. UPGRADE_ARGUMENTS is split with an unquoted array assignment and a shellcheck disable comment, so arguments split on whitespace and globs expand exactly as upstream's unquoted variable did. The array is passed as ${arr[@]+"${arr[@]}"} so an empty value still works under set -u on bash 3.2. The prior harden used xargs here, which would have changed how quotes in the arguments are handled, so I did not reuse it. PR_DESCRIPTION is still written as a multi-line block, but the fixed EOF delimiter is replaced with a random one read from /dev/urandom. The prior harden instead stripped the newlines, which would have merged the description into one line. PR_TITLE now has newlines and carriage returns stripped before it is written.

