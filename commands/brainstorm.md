---
description: Start a structured-but-adaptive brainstorm session around a seed idea
argument-hint: <seed idea>
---

Start a brainstorm session. Seed idea: $ARGUMENTS

1. Read `${CLAUDE_PLUGIN_ROOT}/skills/brainstorming/SKILL.md` and follow it for
   the entire session - it is the playbook; this command only boots the mode.
2. If no seed idea was given, ask for one first (one AskUserQuestion, free-text
   leaning: a couple of guessed directions from context plus "Other").
3. Create the session state and log:
   - `.brainstorm/state.json` - `{"seed": "<seed>", "started": "<ISO timestamp>", "log": ".brainstorm/sessions/<YYYY-MM-DD>-<slug>/log.md"}`
   - the log file itself, from `${CLAUDE_PLUGIN_ROOT}/templates/log.md`.
   The state file activates the mode-enforcer and research-approval hooks; it
   is deleted only at Exit, after the partner approves the brief.
4. Acknowledge the seed in one line, then begin the Map phase: first aspect-cue
   question ("who is it for"), 2–3 options with your recommended read first.

Do not build, spec, or fix anything while the session is active.
