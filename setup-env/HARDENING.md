<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup-env/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup-env/v2.0.0** was hardened automatically. 5 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a): the 'Check for node installation' step puts an expression straight into the run script: `if [ ${{ steps.setup_node.outcome }} == "success" ]; then`. Move it into env (e.g. SETUP_NODE_OUTCOME) and quote it as "$SETUP_NODE_OUTCOME".

Locations:

- `action.yaml:118`

### script-injection (severity: high)

Rule (a): the 'Install packages' step's whole run script is an expression: `run: ${{ env.INSTALL_CMD }}`. INSTALL_CMD comes from the env context, which the calling workflow can control, and it is substituted into the shell script before bash parses it. Read it from the env var instead (e.g. switch on "$PACKAGE_MANAGER" and run fixed commands).

Locations:

- `action.yaml:147`

### script-injection (severity: high)

Rule (a): the 'Check for package install' step puts an expression straight into the run script: `if [ ${{ steps.install_packages.outcome }} == "success" ]; then`. Rule (b), same step: `${TRUNK_PATH} check disable eslint stylelint` expands TRUNK_PATH unquoted. TRUNK_PATH is inherited from the calling workflow, so it is workflow-controlled. Pass the outcome through env and quote it, and quote "${TRUNK_PATH}".

Locations:

- `action.yaml:154`
- `action.yaml:166`

### github-env-injection (severity: high)

The 'Determine pnpm version' step writes `echo "PNPM_VERSION=${PNPM_VERSION}" >>$GITHUB_ENV` with no sanitization. PNPM_VERSION can come from the caller's inherited env (the script only sets it when it is empty) or from package.json's packageManager field, which is repository content. Either source could contain newlines and inject extra GITHUB_ENV entries. Strip them first: `safe=$(printf '%s' "$PNPM_VERSION" | tr -d '\n\r')`, then write "$safe".

Locations:

- `action.yaml:98`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/setup-env/action.yaml b/setup-env/action.yaml
index 14d0dab..cc462be 100644
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
@@ -124,34 +135,36 @@ runs:
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
+      run: |
+        case "$PACKAGE_MANAGER" in
+          npm)  npm ci ;;
+          yarn) yarn install --immutable ;;
+          pnpm) pnpm install --frozen-lockfile ;;
+          *)    echo "::error::Unknown package manager: $PACKAGE_MANAGER"; exit 1 ;;
+        esac
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
@@ -163,4 +176,4 @@ runs:
         fi
         echo "::warning::Failed to install node packages."
         echo "::warning::Disabling linters that d
... (truncated)
```

Locations:

- `action.yaml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, github-env-injection, prior-fix

**Notes:**

The 'Check for node installation' and 'Check for package install' steps now get the step outcomes through env (SETUP_NODE_OUTCOME and INSTALL_PACKAGES_OUTCOME) and quote them in the test. In 'Install packages', `run: ${{ env.INSTALL_CMD }}` is replaced by a case on "$PACKAGE_MANAGER" that runs the same fixed install commands the detect step wrote to INSTALL_CMD (npm ci, yarn install --immutable, pnpm install --frozen-lockfile). TRUNK_PATH is now quoted. PNPM_VERSION has newlines and carriage returns stripped before it is written to GITHUB_ENV. These changes match the previous harden's patch.

