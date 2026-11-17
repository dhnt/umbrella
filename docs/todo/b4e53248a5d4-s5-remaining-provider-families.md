---
id: b4e53248a5d4
kind: feature
title: S5 Remaining provider families
seq: 418
status: todo
priority: p3
labels:
    - yoke
created: 2026-11-17T18:49:46.747936Z
sprint: 655
sprint_id: 31ee6639-a559-5fea-9e71-a7ca52cdea91
sprint_title: 'One app: unified command contract (yoke)'
---

Problem: after forge, the other provider families remain non-uniform.
Behavior: same pattern as S4 for cloud (aws, az, gcloud, doctl), llm (llmgw providers, local and hosted), agent (claude, codex, opencode via the agent-CLI adapters) and oci (podman); one adapter per provider plus parity fixtures; native passthrough kept.
Depends on: S4.
Verification: per-family parity fixtures scored in the gate and recorded in the claims ledger.
