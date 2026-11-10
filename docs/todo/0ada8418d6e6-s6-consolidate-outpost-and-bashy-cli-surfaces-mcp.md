---
id: 0ada8418d6e6
kind: doc
title: S6 Consolidate outpost and bashy CLI surfaces, MCP metadata, and satellite runbooks
seq: 74
status: assigned
priority: p2
labels:
    - satellite
    - cli
    - docs
    - satellite-cli
created: 2026-11-10T01:43:06.799342Z
assignee: muse-spark1.3
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S1, S2, S3, S4, S5.

Scope
- Consolidate the two-layer CLI model: local host daemon verbs on outpost (register, unpair, satellite attach|detach|list, peers) and account/fleet verbs on bashy (login, satellite, paired-host).
- Reconcile help text, JSON schemas, and MCP tool metadata across yoke and bashy.
- No cobra `completion` subcommand anywhere on the bashy surface (operator: generated completion scripts are for old-fashioned shells; bashy does better through its own discovery: --skill, help --format=mcp, the manifest, hints, and the shell's built-in completion from command metadata). Today it shows on `bashy satellite`, `bashy fleet` and the fronted `bashy outpost`, while weave/kb/chat/meet/ask disable it one by one. Fix it in ONE place for every Go front-door verb (and outpost's root), with a test that walks the whole tree and finds no `completion` command.
- Software shaping: Go adds only small verbs; each journey (owner: provision, invite, share, LLM peer; member: pair once, accept, attach, publish) is a Bash# skill-script at examples level composing those verbs (satellite-member.bsh is the model), so users and agents shape it instead of patching Go.
- UI parity (operator): the system is for agents; humans use it with agentic tools. Only a few web consoles target humans, and every action a human can do there (cloudbox, satellite, outpost admin) has a companion bashy verb tailored to agents. Deliver docs/ui-cli-parity.md: each console action -> its bashy verb; every gap becomes a story.
- Agent-first check (operator): every owner/member journey (pair once, attach/detach, member invite/accept/circle, share, LLM peer) runs end to end through bashy verbs with --json, with no web UI step and no ad hoc HTTP; list any gap as a story.
- Update docs/satellite-operations-workflow.md and KB pages to reflect single-daemon multi-satellite attachments and member sharing without master-token or outpost-profile workarounds.

Acceptance
- Help, schema, and docs match the consolidated CLI surface; end-to-end HTTP fixture tests verify primary pairing, multi-satellite attachment, and member sharing.
- Owner/member regression (reuse the S587 members sandbox e2e, no new harness): a member reaches a shared app; the shared LLM through the satellite answers 200 for a shared member, 403 for an unshared member, 401 without a credential; a member without an outpost reaches the pooled /v1 with only their satellite credential; S602 per-peer limits still apply.
