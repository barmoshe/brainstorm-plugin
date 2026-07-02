# brainstorm

A `/brainstorm` mode for Claude Code: a structured-but-adaptive one-on-one
brainstorm that co-designs an idea with you, one short tappable question at a
time. Designed around an AuDHD thinking partner - the agent carries the
executive load (sequencing, remembering, summarizing, timing); you only answer.

Built from a deep-research pass (22 sources, 25 claims adversarially verified).
The core bet: a **fixed question skeleton + adaptive AI follow-ups** is the
evidence-supported middle ground between shallow standardized questioning and
deep-but-exhausting open conversation, with **multiple-choice as the default
exchange format** to cut respondent burden.

## What a session looks like

1. `/brainstorm <seed idea>` - the mode activates.
2. **Map** - fixed aspect-cues, one per exchange: who is it for / what does it
   do / where does it live / when-why now / what exists already. Never "tell me
   about your idea."
3. **Probe** - adaptive follow-ups only where answers were thin; the why-chain
   stops at a root motivation.
4. **Diverge** - SCAMPER-style transformations, 2–3 alternatives max, always
   with a recommendation.
5. **Converge** - winners get picked; everything else parks visibly in a
   parking lot (nothing gets critiqued to its face).
6. **Exit** - dual artifact: the full timestamped session log plus a ~20-line
   brief (decisions, parked ideas, next 3 actions) built to reload into a fresh
   session. You approve the brief before anything happens downstream.

Mid-session web research is auto-approved while the session is active, so
permission prompts never break the flow. Progress is narrated ("3 areas mapped,
2 to go") and a break is offered around 20–25 minutes.

## How the mode holds

Prompt instructions alone don't hold a divergence mode - helpfulness training
drives premature convergence to solutions. So the mode is enforced mechanically:

- `/brainstorm` creates `.brainstorm/state.json` in your project.
- A **UserPromptSubmit hook** re-injects the brainstorm rules every turn while
  that file exists.
- A **PreToolUse hook** auto-approves WebSearch/WebFetch while it exists.
- Exit (after you approve the brief) deletes the state file, releasing both.

Both hooks fail open: on any error they no-op rather than block your session.

## Layout

```
.claude-plugin/plugin.json      manifest
commands/brainstorm.md          /brainstorm entry point
skills/brainstorming/SKILL.md   the session playbook
hooks/hooks.json                hook registration
hooks/brainstorm-mode.sh        UserPromptSubmit mode enforcer
hooks/approve-research.sh       PreToolUse research auto-approve
templates/log.md                session log template
templates/brief.md              exit brief template
```

Session artifacts land in `.brainstorm/sessions/<date>-<slug>/` in the host
project. **Add `.brainstorm/` to the host's `.gitignore`** - session logs can
carry personal context.

## v2 candidates (open research questions)

- Instrument session length/cadence: does hyperfocus extend tolerance, or does
  fatigue accumulate as in surveys? (Default today: conservative ~20–25 min check-ins.)
- Track whether the "Other" escape hatch actually gets used when fatigued, or
  whether options anchor the partner to the agent's framings.
- Alternative exit artifacts (mind map, pure next-actions list) vs the dual
  Markdown.

Requires `bash` and `python3` on the host (hook scripts).

## Install

```
/plugin marketplace add barmoshe/brainstorm-plugin
/plugin install brainstorm@brainstorm
```

## Evidence base (key sources)

The design comes from a deep-research pass: 22 sources fetched, 25 claims
adversarially verified (3-vote), 22 confirmed. The load-bearing ones:

- Norris, Crane & Maras 2020 (aspect-cues restore recall specificity for
  autistic adults; question format, not capability): https://pmc.ncbi.nlm.nih.gov/articles/PMC7376628/
- Barari et al. 2025, n=1,800 RCT (hybrid fixed-skeleton + LLM probing;
  acquiescence bias in yes/no confirmations): https://arxiv.org/pdf/2504.13908
- Hadler 2023/25 (open-ended probes measurably increase break-off and
  backtracking; default to closed): https://journals.sagepub.com/doi/10.1177/00491241231176846
- Boonpracha 2023 (SCAMPER improves ideation): https://www.sciencedirect.com/science/article/abs/pii/S1871187123000524
- ADHD digital-work support, CHItaly 2025 (low-interaction-burden tools): https://arxiv.org/pdf/2507.06864
- Ara et al. 2025 (AI body-doubling, small preprint): https://arxiv.org/abs/2509.12153
- Prior art: the obra/superpowers `brainstorming` skill (one question per
  message, recommendation-first, review-gated design doc) and
  MadeByTokens/claude-brainstorm (state-file + hook mode enforcement, dual artifact).

Caveat: no study directly examined brainstorming with AuDHD adults; the
combined profile is a synthesis-level inference across autistic-adult
interview research, ADHD productivity research, and general survey-burden
evidence. Claims that failed verification were excluded from the design.

## License

MIT
