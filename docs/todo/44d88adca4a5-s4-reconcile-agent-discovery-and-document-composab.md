---
id: 44d88adca4a5
kind: doc
title: S4 Reconcile agent discovery and document composable shaping workflows
seq: 61
status: done
priority: p1
labels:
    - satellite
    - cli
    - agentic
created: 2026-11-08T18:28:23.418797Z
weave: 3
assignee: agy-gemini3.8-flash
sprint: 598
sprint_id: 3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3
sprint_title: 'Agent-friendly satellite CLI: minimal daily operations'
closed: 2026-11-08T19:39:10.374921Z
closed_by: s598-manager
---

Sprint 598 (3ee2100b-b8bf-51f7-8b62-2ff0afa5bbf3). Agreed MVP: KISS, rod not fish, software shaping.

Depends on S1-S3.
Goal: agent-facing discovery accurately describes the small supported surface and teaches composition.
Reconcile bashy satellite summaries, help/MCP schemas and effects/capability metadata with list/show/invite/transfer and their actual flags. Correct stale reproduce guidance that still labels satellite listing absent, while retaining genuine gaps such as bearer host-to-satellite assignment and unsupported detail contracts. Do not infer mapping from local profiles or claim live API availability based on a client implementation.
Document a concise workflow: existing account discovery -> satellite list/show -> paired-host inspection -> explicit invite/transfer. Use synthetic identities/endpoints. State that current invite JSON includes the pairing code even when a file is written; preserve output compatibility. Clarify that owner-issued pairing invites establish owner-controlled pairing, not ordinary membership; members pair with their own account.
Use the existing software-shaping lifecycle for tailored CLI behavior: wish, diff, verify, preview, approve, undo. Trusted verification remains outside candidate source. No new shaping framework or bundled bespoke workflow is required.
Acceptance: generated help/MCP flags agree with dispatch; focused fleet/account and bashy dispatch/schema checks pass; one composed workflow is demonstrated against fixtures. Keep live service verification separate and record it as unverified unless actually performed. Follow existing documentation indexing conventions if adding a doc.
Boundaries: no generic HTTP command, workflow engine, context store, provisioning, membership admin, upgrades, recovery implementation or host-assignment API work.
The operator subsequently authorized implementation, managed assignment, verification, and delivery of Sprint 598. The creation-only restriction is superseded.
