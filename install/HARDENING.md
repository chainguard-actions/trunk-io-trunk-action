<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.2.2

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.2.2** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: The `${{ inputs.tools }}` expression is directly interpolated into a `run:` shell command string without any quoting or sanitization. The offending line is: `run: trunk tools install --ci ${{ inputs.tools }}`. Because `inputs.tools` is a caller-controlled value (required: false, no default), an attacker invoking this composite action can supply a value such as `; malicious-command` to execute arbitrary shell commands on the runner.

Locations:

- `action.yaml:31`

### static-inline-injection (severity: high)

shell injection: expression "${{ inputs.tools }}" appears directly in run: block of step "Trunk install"; move to env: map

Locations:

- `action.yml:32`

## Iteration Notes

### Iteration 1

**Fixes applied:** script-injection, static-inline-injection

**Notes:**

Fixed script injection in action.yaml at the 'Trunk install' step. Moved `${{ inputs.tools }}` from the run: shell command string into an env: block as INPUT_TOOLS. In the shell command, replaced the direct interpolation with `${INPUT_TOOLS:+"$INPUT_TOOLS"}` — this conditional expansion drops the argument entirely when INPUT_TOOLS is empty (preserving the original behavior for the optional input with no default), and double-quotes the value when present to prevent word splitting and globbing.

