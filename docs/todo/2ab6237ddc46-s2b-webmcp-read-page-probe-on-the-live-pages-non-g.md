---
id: 2ab6237ddc46
kind: spike
title: S2b WebMCP read_page probe on the live pages (non-gating)
seq: 642
status: todo
priority: p2
created: 2026-11-23T03:16:09.37828Z
sprint: 693
---

Non-gating probe; dropping it is an acceptable operator decision (plan decision 2). Feature-detected document.modelContext.registerTool('read_page') returning the page JSON (the current W3C CG draft surface; navigator.modelContext/provideContext and the declarative form are gone). Verified in Chrome under the origin-trial token or flag with bashy browser eval (getTools, executeTool) on the gate host. Record browser version, flag or token, and the tool output; absence of the API degrades to nothing. Context: origin trial only (Chrome 149-162), WebKit opposed, one shipped consumer; hence not in the live gate. Plan: docs/sprint-693-master-execution-plan.md.
