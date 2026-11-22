---
id: 16574b71a591
kind: feature
title: Convert remaining folders + fix account regression (after optional/toolchain landed)
seq: 605
status: done
priority: p0
created: 2026-11-21T14:21:18.576317Z
assignee: claude-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-22T12:00:03.75542Z
closed_by: claude-opus5.5
---

Continuation of ee056056de3e conversion under FINAL STRUCTURE. LANDED: stats pilot (742cfc72), optional classic+GNU (fba31dee+aa43e65d), toolchain 20 (f14538f0) - all pushed+umbrella-pinned, manager sample-verified (optional md5sum/tree tests ok, toolchain build ok, adapter tests green at f14538f0).

ROOT CAUSE FIRST (directive #3): yoke cluster 628c8f9e (preserved as live-bashy branch salvage/s677-yoke4a-123, NOT merged) regresses internal/agentos TestAccountBuiltinAdaptersLinked: PASSES at 742cfc72 and at f14538f0, FAILS at 628c8f9e with 'schema does not list adapter cloudbox/llm/digitalocean/aws' (account_door_test.go:90). The cluster converted the account verb; converting it broke its builtin account-adapter schema registration. Diagnose precisely, record root cause HERE before fixing, then fix minimally (account may belong in custom/ or need its adapter schema preserved through the adapter boundary). Bring 628c8f9e forward onto current heads (cherry-pick/rebase trivial-only; else redo clusters fresh using it as reference), rerun agentos Adapter tests + the account test green.

REMAINING CONVERSION: yoke/ coupled verbs not in 4a (weave, sprint, kb, mb, meet, dag, todo...), examples/, custom/ (registry CLIs aws/gcloud/kubectl/helm/gh, podman/ollama, otel, agent CLIs, user-registered). Same per-command pattern + independence acceptance as ee056056 (standalone GOWORK=off build from own entry+own pins; dep test no other command package; commit per cluster, first <15m; exception list here). FINAL: drop unused generator code (internal/cmdgen, tools/cmdgen, internal/agentos/cmdcatalog; seam call already removed by pilot), prove unused, keep build caches. Parent ee056056 closes with this acceptance.
