---
id: 4725a53dfb36
kind: feature
title: 'S3 agentic-forge run|accept|undo|where: run CMD.bsh, refine on failure, caller-tier yield (bashy-forge-request-v1) and accept --from FILE'
seq: 247
status: todo
priority: p0
labels:
    - agentic
created: 2026-11-13T19:17:59.099902Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

bashy/examples/agentic/forge.bsh registered as agentic-forge (examples/defaults row agentic-forge|examples/agentic/forge.bsh|read,write,exec,net). run CMD ARGS: run the resolved script; exit 0 returns its output unchanged; non-zero calls refine once (--attempts, default 2) and reruns; --json wraps in the envelope. When no training model is configured (default, or --train caller) the forge emits one bashy-forge-request-v1 JSON on stdout and exits 6 (weavecli.ExitInputRequired): kind make|refine, the command's help/mcp doc, allowlist, contract, one exemplar, pitfalls (graph pitfalls cmd:CMD --json), failing context (argv, exit, stderr tail) and the exact follow-up call. accept CMD --from FILE runs the S2 gates, saves the next version, reruns the pending argv recorded in pending.json; a failing candidate is refused and the pending request stays. undo CMD restores the previous version; where CMD prints the resolved path and version. Tests with a stub model and a temp BASHY_HOME: warm run makes zero model calls; yield shape; accept good/bad; undo. Depends on S2.
