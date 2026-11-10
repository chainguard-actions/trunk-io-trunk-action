<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v1.3.1** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

Step 'Determine pnpm version' writes PNPM_VERSION to $GITHUB_ENV with `echo "PNPM_VERSION=${PNPM_VERSION}" >>$GITHUB_ENV` and does not sanitize it first. The value can come from untrusted sources: the repository's package.json `packageManager` field (`PNPM_VERSION="${PM#pnpm@}"`), or a PNPM_VERSION env var passed down from the calling workflow, because the script only checks it with `-z` and does not set it itself. A value containing a newline can add extra variables to GITHUB_ENV. Fix: run `safe=$(printf '%s' "$PNPM_VERSION" | tr -d '\n\r')` and write `$safe` instead.

Locations:

- `action.yaml:98`

### script-injection (severity: high)

Rule (a): step 'Check for node installation' puts an expression directly in the run: script: `if [ ${{ steps.setup_node.outcome }} == "success" ]; then`. Fix: pass it in through an env: variable and use it double-quoted.

Locations:

- `action.yaml:118`

### script-injection (severity: high)

Rule (a): step 'Install ${{ env.PACKAGE_MANAGER }} packages' puts an expression directly in the run: script: `run: ${{ env.INSTALL_CMD }}`. INSTALL_CMD is an env value, and the calling workflow can control it.

Locations:

- `action.yaml:147`

### script-injection (severity: high)

Step 'Check for package install' breaks both rules. Rule (a): an expression is put directly in the script: `if [ ${{ steps.install_packages.outcome }} == "success" ]; then` (line 154). Rule (b): the env var TRUNK_PATH, inherited from the calling workflow, is expanded without quotes: `${TRUNK_PATH} check disable eslint stylelint` (line 166).

Locations:

- `action.yaml:154`
- `action.yaml:166`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/setup-env/action.yaml b/setup-env/action.yaml
index 14d0dab..bcac6d2 100644
--- a/setup-env/action.yaml
+++ b/setup-env/action.yaml
@@ -1,18 +1,31 @@
 name: Setup environment
 author: trunk.io
 description: Automatic setup for trunk check dependencies (e.g. Node)
-
 inputs:
   cache-key:
-    description:
-      Cache key for setup (either passed into .trunk/setup-ci/, or used to cache node_modules in
-      this action).
+    description: Cache key for setup (either passed into .trunk/setup-ci/, or used to cache node_modules in this action).
     required: false
     default: ""
-
 runs:
   using: composite
   steps:
     - name: Detect npm/yarn/pnpm & custom setup
       shell: bash
       run: |
@@ -70,7 +83,6 @@ runs:
         else
           echo "Could not find existing node install, skipping node package installation"
         fi
-
     - name: Determine pnpm version
       if: env.PACKAGE_MANAGER == 'pnpm'
       shell: bash
@@ -96,26 +108,25 @@ runs:
           PNPM_VERSION=latest
         fi
         echo "PNPM_VERSION=${PNPM_VERSION}" >>$GITHUB_ENV
-
     - name: Install pnpm
       if: env.PACKAGE_MANAGER == 'pnpm'
       uses: pnpm/action-setup@0e279bb959325dab635dd2c09392533439d90093 # v6.0.8
       with:
         version: ${{ env.PNPM_VERSION }}
-
     - name: Install Node dependencies
       id: setup_node
       if: env.PACKAGE_MANAGER && env.NODE_VERSION_FILE
       uses: actions/setup-node@48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e # v6.4.0
       with:
         node-version-file: ${{ env.NODE_VERSION_FILE }}
       continue-on-error: true
-
     - name: Check for node installation
       if: env.PACKAGE_MANAGER && env.NODE_VERSION_FILE
       shell: bash
+      env:
+        SETUP_NODE_OUTCOME: ${{ steps.setup_node.outcome }}
       run: |
-        if [ ${{ steps.setup_node.outcome }} == "success" ]; then
+        if [ "$SETUP_NODE_OUTCOME" == "success" ]; then
           exit 0
         fi
         echo "::warning::Failed to install specified node version."
@@ -124,34 +135,34 @@ runs:
           echo "::warning::No existing node install detected - installing latest node instead."
           echo "INSTALL_LATEST_NODE=true" >>$GITHUB_ENV
         fi
-
     - name: Install backup node version
       if: env.PACKAGE_MANAGER && env.NODE_VERSION_FILE && env.INSTALL_LATEST_NODE == 'true'
       uses: actions/setup-node@48b55a011bda9f5d6aeb4c2d9c7362e8dae4041e # v6.4.0
       with:
         node-version: latest
-
     - name: Cache node_modules
       if: inputs.cache-key && env.PACKAGE_MANAGER
       uses: actions/cache@27d5ce7f107fe9357f9df03efb73ab90386fccae # v5.0.5
       with:
         path: node_modules/
-        key:
-          ${{ env.PACKAGE_MANAGER }}-${{ runner.os }}-${{ inputs.cache-key }}-${{
-          hashFiles(env.HASH_GLOB) }}
-
+        key: ${{ env.PACKAGE_MANAGER }}-${{ runner.os }}-${{ inputs.cache-key }}-${{ hashFiles(env.HASH_GLOB) }}
     - name: Install ${{ env.PACKAGE_MANAGER }} packages
       id: install_packages
       if: env.PACKAGE_MANAGER && (env.NODE_VERSION_FILE || env.RUN_INSTALL_NODE_PACKAGES)
       shell: bash
-      run: ${{ env.INSTALL_CMD }}
+      env:
+        INSTALL_CMD: ${{ env.INSTALL_CMD }}
+      run: |
+        printf '%s\n' "$INSTALL_CMD" > /tmp/_trunk_install_cmd.sh
+        bash -eo pipefail /tmp/_trunk_install_cmd.sh
       continue-on-error: true
-
     - name: Check for package install
       if: env.PACKAGE_MANAGER && (env.NODE_VERSION_FILE || env.RUN_INSTALL_NODE_PACKAGES)
       shell: bash
+      env:
+        INSTALL_PACKAGES_OUTCOME: ${{ steps.install_packages.outcome }}
       run: |
-        if [ ${{ steps.install_packages.outcome }} == "success" ]; then
+        if [ "$INSTALL_PACKAGES_OUTCOME" == "success" ]; then
           exit 0
         fi
         echo "FAILED_NODE_PACKAGE_INSTALL=true" >>$GITHUB_ENV
@@ -163,4 +174,4 @@ runs:
         fi
         echo "::warning::Failed to install node packages."
         echo "::warning::Disabling linters that depend on node packages."
-        ${TRUNK_PATH} check disable eslint stylelint
+ 
... (truncated)
```

Locations:

- `action.yaml`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection, prior-fix

**Notes:**

All changes are in action.yaml:
- PNPM_VERSION: newlines and carriage returns are now stripped with tr -d '\n\r' before the value is written to $GITHUB_ENV, and the file name is quoted.
- steps.setup_node.outcome and steps.install_packages.outcome are now passed in through env: (SETUP_NODE_OUTCOME and INSTALL_PACKAGES_OUTCOME) and compared double-quoted.
- INSTALL_CMD is now passed in through env:. The step writes it to a mktemp file under $RUNNER_TEMP and runs it with 'bash -eo pipefail', so a failing line still stops the step as it did when upstream inlined it.
- ${TRUNK_PATH} is now quoted. It holds one path to the trunk binary.
This re-applies the security changes from the previous harden. Its formatting-only changes (removed blank lines, rejoined descriptions) were not re-applied.

