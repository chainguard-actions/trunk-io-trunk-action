<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `${{ inputs.tools }}` expression is directly interpolated into the `run:` shell command string in the 'Trunk install' step. Because YAML template substitution happens before the shell ever sees the string, an attacker-controlled value for `inputs.tools` can inject arbitrary shell commands (e.g. semicolons, backticks, subshell operators). The fix is to pass the value through an `env:` block and reference it as a quoted shell variable: `env: TOOLS: ${{ inputs.tools }}` then `run: trunk tools install --ci "$TOOLS"`.

Locations:

- `action.yaml:27`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tools }}" appears directly in run: block of step "Trunk install"; move to env: map

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed the script-injection finding in hardened/action/action.yaml (the 'Trunk install' step). Moved ${{ inputs.tools }} from the run: shell string into an env: block as INPUT_TOOLS. Since 'tools' is a list-style input (space-separated tool names to install), used the xargs tokenization pattern to safely split the value into a bash array with a guard for the empty case, then expanded the array as arguments to 'trunk tools install --ci'. Both findings (script-injection and static-inline-injection) refer to the same issue in the same file (action.yaml / action.yml are the same file).

