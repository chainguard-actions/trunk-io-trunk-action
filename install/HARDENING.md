<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.2.2** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Rule (a) violation: The `${{ inputs.tools }}` expression is directly interpolated into a `run:` shell command string on line 30 of action.yaml (`run: trunk tools install --ci ${{ inputs.tools }}`). GitHub Actions performs template substitution before the shell ever sees the string, so an attacker-controlled value for `inputs.tools` can inject arbitrary shell commands (e.g., `; malicious-command`). The fix is to route the value through an `env:` variable and double-quote it in the script: set `env: TOOLS: ${{ inputs.tools }}` and use `run: trunk tools install --ci "$TOOLS"`.

Locations:

- `action.yaml:30`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tools }}" appears directly in run: block of step "Trunk install"; move to env: map

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed action.yaml: moved `${{ inputs.tools }}` out of the `run:` block into an `env:` variable (`TOOLS: ${{ inputs.tools }}`). Since `inputs.tools` is a list-style input (space-separated tool names), used the xargs-based array tokenization pattern to safely split the value into individual arguments. Added an `if [ -n "$TOOLS" ]` guard to handle the optional (empty) case correctly. The command now runs as `trunk tools install --ci "${tools_args[@]}"` with no template injection risk.

