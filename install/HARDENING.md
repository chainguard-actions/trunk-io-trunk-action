<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v2.0.0

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v2.0.0** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a): The 'Trunk install' step in action.yaml directly interpolates `${{ inputs.tools }}` inside a `run:` shell command: `trunk tools install --ci ${{ inputs.tools }}`. GitHub Actions substitutes this expression into the shell string before the shell parses it, so a caller supplying a crafted `tools` input (e.g. containing `;`, `&&`, `$(...)`, or backticks) can execute arbitrary commands on the runner. The fix is to pass the value via an `env:` variable and reference it as a double-quoted shell variable: `env: TOOLS: ${{ inputs.tools }}` then `run: trunk tools install --ci "$TOOLS"`.

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

Fixed script injection in the 'Trunk install' step of hardened/action/action.yaml. Moved `${{ inputs.tools }}` out of the run: shell string into an env: block as INPUT_TOOLS. Since inputs.tools is an optional whitespace-separated list of tool names, used the xargs-based tokenization pattern with a guard for empty input to safely split the value into a bash array and pass each token as a separate argument to `trunk tools install --ci`. This prevents shell injection while correctly handling multi-tool inputs and the empty/unset case.

