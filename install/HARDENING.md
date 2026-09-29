<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Trunk install' step in action.yaml directly interpolates `${{ inputs.tools }}` inside a `run:` shell command string: `trunk tools install --ci ${{ inputs.tools }}`. The YAML template engine substitutes this value before the shell processes it, allowing an attacker-controlled input to inject arbitrary shell metacharacters and commands (e.g., a value like `; malicious-command` would be executed). The fix is to pass the input via an `env:` variable and double-quote the expansion: set `TOOLS: ${{ inputs.tools }}` in an `env:` block and use `trunk tools install --ci "$TOOLS"` in the run script.

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

Fixed script injection in hardened/action/action.yaml: moved `${{ inputs.tools }}` from the `run:` shell string into an `env:` block as `INPUT_TOOLS`. Since `tools` is a list-style input (space-separated tool names), used xargs-based quote-aware tokenization into a bash array, guarded by a `[ -n "$INPUT_TOOLS" ]` check to handle the optional/empty case. The array is then expanded with `"${tools[@]}"` to preserve argument boundaries. Both findings (script-injection at action.yaml:27 and static-inline-injection at action.yml:32) refer to the same issue and are resolved by this fix.

