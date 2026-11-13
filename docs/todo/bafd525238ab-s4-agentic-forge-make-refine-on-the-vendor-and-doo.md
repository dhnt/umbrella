---
id: bafd525238ab
kind: feature
title: 'S4 agentic-forge make|refine on the vendor and door tiers: prompts, bashy chat --read-only --agent X and bashy genie -m MODEL, --deep opt-in'
seq: 248
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:17:59.254938Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

make CMD (pretraining): prompt = bashy CMD --help --format mcp (or CMD --help for an external), bashy kb search CMD pages, graph pitfalls cmd:CMD, the skill-script conventions (fence, @guard, --json, --no-input, superset face: native flags/args AND a sentence), three exemplars; output one CMD.bsh; S2 gates; saved as version 1. refine CMD: prompt = current script, failing argv, exit, stderr tail, the script's own --probe output when defined, pitfalls; output the corrected whole script; S2 gates plus the failing invocation must pass on rerun; saved copy-on-write. Tiers: --train vendor NAME uses bashy chat --read-only --agent NAME -m PROMPT (verified this session: claude answered a one-shot in 2 s; use the envelope result, not --plain stream); --train MODEL uses bashy genie -m MODEL -- PROMPT with an instruction to answer with the script only (this host lacks the door credential: bashy genie -m door-claude-opus5 asks for BASHY_LLM_API_KEY in secrets.map; the tool-free bashy ycode btw path rejects -m, see the bug story). AGENTIC_FORGE_MODEL_CMD stubs the call in tests. --deep (tool-enabled genie turn, --yolo only when unattended) stays opt-in. Depends on S2, S3.
