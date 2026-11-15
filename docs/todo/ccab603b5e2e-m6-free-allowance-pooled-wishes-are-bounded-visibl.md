---
id: ccab603b5e2e
kind: requirement
title: 'M6 Free allowance: pooled wishes are bounded, visible, and refuse rather than degrade'
seq: 312
status: todo
priority: p1
labels:
    - software-shaping
created: 2026-11-15T02:13:07.182937Z
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP: dogfood dhnt.io — a member shapes the company site in their own GitHub-backed space, proven Red-Green-Refactor'
---

A public 'try it now' that calls a model is a cost and abuse surface, so the invitation cannot ship without a ceiling. This story is the ceiling, not a feature.

Scope: a per-visitor quota on practice wishes (count and tokens) over the existing llmbudget admission, so an exhausted visitor is told plainly rather than queued forever; the pooled route for practice (never the owner's personal key, never an unpooled paid provider); a reset verb that discards a visitor's practice versions and returns the app to base, callable by the visitor for themselves and by the owner for everyone; retention so practice versions do not accumulate; and a refusal, never a silent degradation, when the pool is unavailable.

Acceptance: the quota is enforced on the route and in --json with the remaining allowance; a second visitor is unaffected by the first; reset returns base and leaves history coherent; with the pool down the invitation says so and offers the lesson without the exercise; no practice path can reach a provider the owner did not pool. Cross-check with the standing rule that receivers never pay.
