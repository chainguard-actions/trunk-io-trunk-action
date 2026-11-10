<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.3.1** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) direct expression interpolation: the 'Trunk install' step puts an input straight into the shell command: `run: trunk tools install --ci ${{ inputs.tools }}`. Whoever calls the action controls inputs.tools, so a value with shell metacharacters (;, $(...), backticks) runs as arbitrary commands. Fix: pass it through env (e.g. `TRUNK_TOOLS: ${{ inputs.tools }}`) and expand it as a quoted shell variable. If the value needs to be split into a list of tools, use an array assignment marked with a shellcheck disable directive.

Locations:

- `action.yaml:31`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tools }}" appears directly in run: block of step "Trunk install"; move to env: map

Locations:

- `action.yml:32`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/install/action.yaml b/install/action.yaml
index 40642f1..db644b5 100644
--- a/install/action.yaml
+++ b/install/action.yaml
@@ -1,23 +1,36 @@
 name: Trunk Check
 author: trunk.io
 description: Install trunk and managed tools to PATH
-
 inputs:
   tools:
     description: specific tools to install (if not specified will install all enabled tools)
     required: false
-
 branding:
   icon: check
   color: green
-
 runs:
   using: composite
   steps:
     - name: get trunk
       shell: bash
       run: ${GITHUB_ACTION_PATH}/get_trunk.sh
-
     - name: clean up possible dead symlink
       shell: bash
       run: |
@@ -25,11 +38,17 @@ runs:
         if [ -L "${tools_path}" ] && [ ! -e "${tools_path}" ] ; then
           rm "${tools_path}"
         fi
-
     - name: Trunk install
       shell: bash
-      run: trunk tools install --ci ${{ inputs.tools }}
-
+      env:
+        INPUT_TOOLS: ${{ inputs.tools }}
+      run: |
+        tools=()
+        if [ -n "$INPUT_TOOLS" ]; then
+          while IFS= read -r -d '' t; do tools+=("$t"); done \
+            < <(printf '%s' "$INPUT_TOOLS" | xargs printf '%s\0')
+        fi
+        trunk tools install --ci "${tools[@]}"
     - name: Add .trunk/tools to path
       shell: bash
       run: echo ".trunk/tools" >> $GITHUB_PATH

```

Locations:

- `action.yaml`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection, prior-fix

**Notes:**

In action.yaml, the 'Trunk install' step no longer puts inputs.tools straight into the shell command. The value now goes through env as INPUT_TOOLS. The script splits it into an array with the quote-aware xargs method, which matches how the shell split upstream's inline expression. The split includes a check that fails on an unmatched quote and uses the shell's built-in printf via sh -c. The array is only expanded when it's non-empty, so an empty input passes no extra argument and trunk still installs all enabled tools. This re-applies the previous harden's fix and improves on it: that version didn't check for unmatched quotes and called the external printf directly. Nothing was run or tested.

