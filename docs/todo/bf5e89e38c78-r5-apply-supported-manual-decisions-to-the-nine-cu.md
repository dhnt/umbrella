---
id: bf5e89e38c78
kind: test
title: R5 Apply supported manual decisions to the nine current INSPECT results
seq: 17
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.05149Z
sprint: 571
sprint_id: 74f43bab-7fb6-58b1-97e0-94c52ed5986c
sprint_title: Resolve S561 residuals and prepare POSIX certification
---

Depends on R1; independent of the external authority reply lanes. Retrieve existing S377 manual-decision rules and evidence for stty (7), df (1) and locale (1). A qualified reviewer must verify applicability and evidence for the exact S561 journal; prior-arm decisions are not automatically transferable. Record reviewer, decision, rationale and evidence in the permitted private resolution mechanism, preserving raw INSPECT codes. Missing or contradictory evidence requires a bounded approved replay. Acceptance: nine individually supported and independently reviewed current-journal decisions, no pending inspection.

Plan: docs/plan-s571-posix-certification-readiness.md. Baseline: bashy/docs/s561/a4-licensed-results.md and candidate-manifest.json. Restricted fixtures, journal details and correspondence stay outside this public repository; publish only sanitized aggregates and references. This sprint is being planned, not launched.
