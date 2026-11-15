---
id: 754a8c8b9709
kind: task
title: Assess shaping foundation reuse for Outpost and Bashy app surfaces
seq: 323
status: done
created: 2026-11-15T07:08:58.016571Z
assignee: codex-gpt6-sol
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
closed: 2026-11-15T08:12:01.082344Z
closed_by: codex-gpt6-sol
---

Assessment complete: the named-action architectural pattern is reusable, but each app needs an adapter for its own framework, authentication, mount prefix and domain APIs. Outpost uses vanilla JS with admincore CLI/API mutations and OS-user sessions; Bashy uses an injected plain-JS Shape component and existing source-candidate CLI workflows. Implement a framework-independent action registry and private transport, then migrate Bashy Shape and Outpost networking/navigation first. Runtime presentation must remain distinct from persistent source revisions, with no duplicate domain logic. This assessment led to R1 46d76276772e, R2 0b1b0346e78e, R3 96be6ef5a8a5. Acceptance: shared human/agent handlers, explicit field validation, reversible Shape-only, session cleanup, prefix support, no replay, CLI parity inventory. Other surfaces remain deferred by operator instruction.
