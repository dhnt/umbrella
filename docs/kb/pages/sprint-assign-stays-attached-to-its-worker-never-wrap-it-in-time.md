---
id: 01a1d6a9-be8b-7bd7-86cf-35c5788f1477
seq: 12
form: page
type: lesson
title: 'sprint assign stays attached to its worker: never wrap it in timeout, launch one per background process'
description: 'WHEN dispatching fleet workers with bashy sprint assign (or weave start): the verb attaches to the run and returns only when the worker ends, so wrapping it in bashy''s builtin timeout kills the worker at the deadline (Sprint 632 runs #60/#62 died at ~4 min with exit -1, work already committed). Launch each assign as its own background process with stdin closed (</dev/null) and no timeout; killing the loop shell also kills the attached wrapper and orphans the worker. Before any abandon, fetch the workspace''s submodule HEADs into the main checkouts as refs/salvage/<sprint>-run-N; cherry-pick in a detached scratch worktree, rerun the story gates yourself, pin via git update-index --cacheinfo so shared checkouts stay untouched, and rewrite worker trailers that read Agent: agent-weave-issue-N to the assigned agent name.'
status: candidate
source:
    tool: claude
created: "2026-11-13T20:46:51Z"
---
