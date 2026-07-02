#!/usr/bin/env bash
# PreToolUse(WebSearch|WebFetch) - auto-approve research during an active
# brainstorm session, so permission prompts never interrupt the flow.
# Inactive session → no output (normal permission flow applies).
# Fails open - on any error, exit 0 with no output; never block the tool.

input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null || true)"
[ -n "$cwd" ] || cwd="$PWD"
[ -f "$cwd/.brainstorm/state.json" ] || exit 0

cat <<'JSON'
{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow","permissionDecisionReason":"Brainstorm session active - research is pre-approved so flow is never interrupted."}}
JSON
exit 0
