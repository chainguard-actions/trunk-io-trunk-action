<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The `run:` block in the 'Trunk install' step directly interpolates the GitHub Actions expression `${{ inputs.tools }}` into a shell command string: `trunk tools install --ci ${{ inputs.tools }}`. The `inputs.tools` value is caller-controlled and is substituted into the shell command before the shell ever sees it, allowing an attacker to inject arbitrary shell commands by supplying a crafted value (e.g., `; malicious-command`). The fix is to pass the input via an `env:` variable and reference it as a double-quoted shell variable: set `env: TOOLS: ${{ inputs.tools }}` and use `trunk tools install --ci "$TOOLS"` in the run block.

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

Fixed script injection in action.yaml's 'Trunk install' step. Moved `${{ inputs.tools }}` from the run: block into an env: variable `TOOLS: ${{ inputs.tools }}`. Since `inputs.tools` is an optional, potentially space-separated list of tool names, used the xargs-based tokenization pattern (with a `[ -n "$TOOLS" ]` guard) to safely expand it into an array and pass each tool as a separate argument to `trunk tools install --ci`. This prevents attacker-controlled input from being interpreted as shell commands.

