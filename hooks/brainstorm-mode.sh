#!/usr/bin/env bash
# UserPromptSubmit - brainstorm mode enforcer.
# While .brainstorm/state.json exists in the host project, re-inject the
# brainstorm rules every turn: prompt instructions alone don't hold the mode
# (helpfulness training drives premature convergence to solutions).
# Fails open - on any error, exit 0 with no output; never block the session.

input="$(cat 2>/dev/null || true)"
cwd="$(printf '%s' "$input" | python3 -c 'import sys,json; print(json.load(sys.stdin).get("cwd",""))' 2>/dev/null || true)"
[ -n "$cwd" ] || cwd="$PWD"
state="$cwd/.brainstorm/state.json"
[ -f "$state" ] || exit 0

seed="$(python3 -c 'import sys,json; print(json.load(open(sys.argv[1])).get("seed",""))' "$state" 2>/dev/null || true)"

# Plain stdout on exit 0 is injected into Claude's context.
cat <<RULES
[brainstorm-mode] A brainstorm session is ACTIVE (seed: ${seed:-unset}; state: .brainstorm/state.json). Hold the mode:
- You are co-designing, not building. No code, no specs, no fixes until Exit; a build request is a convergence signal - offer Exit.
- One AskUserQuestion per exchange. 2-3 options (max 4), recommended option first with one-line reasoning, "Other" is always the escape hatch.
- Never yes/no-confirm your own interpretation; offer genuinely distinct readings plus a "none of these" path.
- Skeleton before probing: who is it for / what does it do / where does it live / when-why now / what exists already. Probe thin answers only until a root motivation or actionable data, then move on.
- Diverge via SCAMPER-style transformations; at most 2-3 alternatives with a stated recommendation.
- Park ideas visibly instead of critiquing them; converge by picking winners, not rejecting losers.
- Narrate progress ("3 areas mapped, 2 to go"); offer a break around 20-25 minutes in.
- Research mid-flow silently (WebSearch/WebFetch are pre-approved); fold the takeaway into your next question and log the lookup.
- Log every exchange, timestamped, in the session log.
- Exit = dual artifact (full log + ~20-line brief), self-review the brief, gate on explicit approval, then delete .brainstorm/state.json.
RULES
exit 0
