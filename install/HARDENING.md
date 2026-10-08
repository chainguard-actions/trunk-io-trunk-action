<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.3.1

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.3.1** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `${{ inputs.tools }}` expression is interpolated directly into a `run:` shell command string: `trunk tools install --ci ${{ inputs.tools }}`. Because YAML template substitution happens before the shell ever sees the string, an attacker who controls the `tools` input can inject arbitrary shell metacharacters (`;`, `|`, `$(...)`, etc.) and execute arbitrary commands on the runner. The fix is to pass the value via an `env:` variable and double-quote it in the script: `env: { TOOLS: "${{ inputs.tools }}" }` then `run: trunk tools install --ci "$TOOLS"`.

Locations:

- `action.yaml:20`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tools }}" appears directly in run: block of step "Trunk install"; move to env: map

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed script injection in hardened/action/action.yaml: moved `${{ inputs.tools }}` out of the `run:` shell string and into an `env:` block as `INPUT_TOOLS`. Since `inputs.tools` is a list of tool names (space-separated, optional), used the xargs-based tokenization pattern with a null-delimiter read loop to safely split the value into an array while preserving quoting. An `if [ -n "$INPUT_TOOLS" ]` guard prevents xargs from emitting an empty argument when the input is not provided. Both findings (script-injection at action.yaml:20 and static-inline-injection at action.yml:32) refer to the same vulnerability in the same file.

