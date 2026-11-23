---
id: 94b8d8d8aaf8
kind: feature
title: 'S3 Owner shaping round trip on the engine: wish from /about#team at the observed revision, same candidate in HTML and Markdown/JSON, approve, undo, isolation'
seq: 640
status: todo
priority: p1
created: 2026-11-23T02:45:09.247108Z
sprint: 693
sprint_id: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a
sprint_title: dhnt.io navigation and shaping for people and agents
---

Depends on S0b only (not on S1). Register dhnt/site as a shaped app on the owner's always-on engine host with the existing website workflow (no engine change). Wish: bashy shape wish site --page /about --element 'section=team revision=<rev>' with a reversible copy edit; the frozen stale-base check refuses a revision that is not the base revision of the page ('stale, re-read'). Verify; preview: the candidate's HTML, .md and .json carry ONE new revision and the edited copy; the owner (browser, signed in) and Bashy (CLI, bashy fetch) read them and find the same revision. Approve: the owner's active version shows the edit; an anonymous request and a second principal see the base. bashy shape undo restores the base; history lists both. The live ai.dhnt.io/about ETag is unchanged before and after (publishing to the live site is a follow-up: PR on dhnt/site, pin bump, hosted-plane release). Evidence with candidate and revision ids, hosts by role. Plan: docs/sprint-693-master-execution-plan.md.
