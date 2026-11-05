---
id: 60e864ce9f7a
kind: bug
title: R6 Implement and verify repairs required by residual decisions
seq: 18
status: todo
priority: p1
labels:
    - posix-cert
created: 2026-11-05T04:19:28.165424Z
sprint: 571
sprint_id: 74f43bab-7fb6-58b1-97e0-94c52ed5986c
sprint_title: Resolve S561 residuals and prepare POSIX certification
---

Starts only for a confirmed defect or supported setup change from R2-R5. Current triage classifies the residuals as decision items, not proven product defects; reclassify if new evidence warrants it. Make the smallest causal fix in the owning product or private harness repository. Preserve failing control, focused regression and affected licensed-case evidence; no skip, weakened assertion, fabricated pass or arbitrary timeout increase. Pin producers before consumers, record build/artifact changes, and identify invalidated evidence. Acceptance: every required repair independently verified with no regression. If no repair is required, close only with explicit evidence-backed not-applicable reasoning.

Plan: docs/plan-s571-posix-certification-readiness.md. Baseline: bashy/docs/s561/a4-licensed-results.md and candidate-manifest.json. Restricted fixtures, journal details and correspondence stay outside this public repository; publish only sanitized aggregates and references. This sprint is being planned, not launched.
