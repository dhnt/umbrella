---
id: 194d9cf946b5
kind: task
title: 'U1 inventory + doc: utils vs tools; minimal built-in set'
seq: 864
status: todo
created: 2026-11-28T18:32:15.054302Z
sprint: 746
sprint_id: d7955ade-9943-51b0-b95d-d19b22e3b547
sprint_title: 'Utils vs tools: minimal bashy built-in set (MVP)'
---

Write bashy/docs/commands-utils-tools.md: definitions (command umbrella, util built-in minimum, tool everything else by source core/optional/example/toolchain/custom), the util list from code (bash BuiltinNames, atlas.PosixRequired, bashy core verbs), the in-process yoke commands today, demotion candidates. GNU-only coreutils = optional tools, stay linked (operator 11-28). Verify: doc lists match code (agentos.go switch vs adapter_dispatch.go adaptedVerbs; yoke/cmds/all).
