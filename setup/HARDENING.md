<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--setup/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `374911c4be584df24e6da57af2d990570ef0f859`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--setup/v1.3.1** was hardened automatically. 4 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### github-env-injection (severity: high)

locate_trunk.sh, the script run by the composite step in action.yaml, copies the input `trunk-path` (via INPUT_TRUNK_PATH) into trunk_path. It then writes it with `echo "TRUNK_PATH=${trunk_path}" >>"${GITHUB_ENV}"` and never strips newlines first. If the value contains a newline, it can add any extra environment variable, such as LD_PRELOAD or BASH_ENV, for later steps. Fix: before the write, run `trunk_path=$(printf '%s' "$trunk_path" | tr -d '\n\r')`.

Locations:

- `locate_trunk.sh:26`
- `locate_trunk.sh:12`

### script-injection (severity: high)

Rule (b): locate_trunk.sh expands the input-derived variable without quotes when running it as a command: `${trunk_path} version || echo "::warning::${trunk_path} does not exist!"`. Because trunk_path comes from inputs.trunk-path, the shell splits it into words and expands globs, so the value can add extra arguments or pick which binary runs. Fix: quote it as `"${trunk_path}" version`.

Locations:

- `locate_trunk.sh:28`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed action.yaml without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/setup/action.yaml b/setup/action.yaml
index b9aa1b6..1f55dee 100644
--- a/setup/action.yaml
+++ b/setup/action.yaml
@@ -1,22 +1,33 @@
 name: Trunk Check
 author: trunk.io
 description: The official trunk.io GitHub action to install trunk
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
 branding:
   icon: check
   color: green
-
 runs:
   using: composite
   steps:
     - name: Locate trunk
       shell: bash
       run: ${GITHUB_ACTION_PATH}/locate_trunk.sh

```

Locations:

- `action.yaml`

### prior-fix (severity: high)

Carried forward from this version's previous harden, which fixed it; fix it again unless the code no longer has the problem. The previous harden changed locate_trunk.sh without recording a finding for it, and this analysis reported nothing there. Re-apply its security changes unless the code no longer needs them. The previous patch:
```diff
diff --git a/setup/locate_trunk.sh b/setup/locate_trunk.sh
index b9f84a2..13dfee5 100755
--- a/setup/locate_trunk.sh
+++ b/setup/locate_trunk.sh
@@ -23,6 +23,7 @@ if [[ -z ${trunk_path} ]]; then
     trunk_path="${tmpdir}/trunk"
   fi
 fi
-echo "TRUNK_PATH=${trunk_path}" >>"${GITHUB_ENV}"
+safe_trunk_path="$(printf '%s' "${trunk_path}" | tr -d '\n\r')"
+echo "TRUNK_PATH=${safe_trunk_path}" >>"${GITHUB_ENV}"
 # Ensure that trunk CLI is downloaded before subsequent steps
-${trunk_path} version || echo "::warning::${trunk_path} does not exist!"
+"${safe_trunk_path}" version || echo "::warning::${safe_trunk_path} does not exist!"

```

Locations:

- `locate_trunk.sh`

## Iteration Notes

### Iteration 1

**Fixes applied:** github-env-injection, script-injection, prior-fix

**Notes:**

locate_trunk.sh: trunk_path now has newlines and carriage returns stripped (printf | tr -d '\n\r') before it is written to GITHUB_ENV. Because the script runs with pipefail, a failure there still stops it. The trunk binary call is now quoted ("${trunk_path}" version). This re-applies the earlier locate_trunk.sh fix. action.yaml: the earlier patch only reformatted the file. inputs.trunk-path already reaches the script through env (INPUT_TRUNK_PATH), so nothing needed fixing there. The only change is quoting the script path in run:. Nothing was tested.

