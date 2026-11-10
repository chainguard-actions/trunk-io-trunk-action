<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v2.0.0** was hardened automatically. 3 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) is violated: the 'Trunk install' step puts a GitHub Actions expression straight into the run: shell command: `run: trunk tools install --ci ${{ inputs.tools }}`. Whatever the caller passes in inputs.tools is pasted into the script before bash parses it, so a value containing ;, |, $(...) or backticks runs as a command. Fix: add `env: TOOLS: ${{ inputs.tools }}` to the step. This input is a whitespace-separated list, so expand it as an array with a shellcheck directive. Put `# shellcheck disable=SC2206` on the line above `tools=(${TOOLS})`, then run `trunk tools install --ci "${tools[@]}"`. An unquoted expansion splits on whitespace but never runs commands from the value, and a single quoted "$TOOLS" would wrongly pass the whole list as one argument.

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

In action.yaml, the 'Trunk install' step now reads inputs.tools from env (INPUT_TOOLS) instead of putting the ${{ }} expression into run:. Upstream pasted the expression straight into the script, so the shell honored quotes in the value. To keep that behavior, the list is tokenized with the quote-aware xargs split, as the harden rules say for inlined inputs. A guard handles an empty value, 'xargs -r true' catches an unmatched quote, and the built-in printf runs through sh -c. The result goes into a bash array, and an empty array passes no arguments. This differs from the finding's suggested unquoted-array split, but follows the rules for an input that was inlined as an expression. Nothing in the value is evaluated.

