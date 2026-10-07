<!-- markdownlint-disable -->

# Hardening Report: trunk-io--trunk-action--install/v1.2.4

> This file was generated automatically by the hardening agent.

**Policy SHA:** `d636be7e43ef829af6e853da6b3c7566db9f72fe`

**Test Policy SHA:** `843adf9e4b8f85d0c08b27b9d0b09dd094b54702`

**Harden Agent Version:** `2`

Action **trunk-io--trunk-action--install/v1.2.4** was hardened automatically. 2 finding(s) were identified and resolved across 1 iteration(s).

## Findings Fixed

### script-injection (severity: high)

Sub-rule (a) violation: The `${{ inputs.tools }}` expression is directly interpolated inside a `run:` shell command string on line 30 of action.yaml (`run: trunk tools install --ci ${{ inputs.tools }}`). GitHub Actions performs template substitution before the shell ever sees the string, so an attacker-controlled value for `inputs.tools` can inject arbitrary shell commands (e.g. `; malicious-command`). Additionally, the value is unquoted (sub-rule b), allowing shell metacharacter splitting. The fix is to pass the input via an `env:` variable and double-quote it: `env: { TOOLS: "${{ inputs.tools }}" }` then `run: trunk tools install --ci "$TOOLS"`.

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

Fixed the script injection vulnerability in hardened/action/action.yaml. The `${{ inputs.tools }}` expression was directly interpolated in the `run:` shell command on line 30, allowing shell injection. The fix moves the expression to an `env:` block as `INPUT_TOOLS`, then uses the xargs tokenization pattern (with an empty-value guard) to safely expand the list of tool names as separate arguments to `trunk tools install --ci`. Both findings (script-injection and static-inline-injection) referred to the same issue in the same file.

