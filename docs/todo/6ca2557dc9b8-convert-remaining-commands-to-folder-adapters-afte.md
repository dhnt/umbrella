---
id: 6ca2557dc9b8
kind: feature
title: Convert remaining commands to folder adapters (after stats pilot)
seq: 604
status: assigned
priority: p0
created: 2026-11-21T13:31:43.82403Z
weave: 123
assignee: agy-gemini4-carbon
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Continuation of ee056056de3e under the FINAL STRUCTURE (operator 2026-11-21). PILOT DONE+LANDED: stats -> bashy/yoke/stats (bashy 742cfc72): few-line Bash# adapter + minimal main, yoke/internal/adapter cobra bridge, dispatch case calls runCommandAdapter; manager-verified standalone GOWORK=off build+test, 427 deps zero other-command packages, help parity identical. FOLLOW THAT PATTERN EXACTLY.

REMAINING: every non-internal command, folder by folder - optional/ (GNU extras, jq, tar...), toolchain/ (go, node, python, rust, cmake...), yoke/ (weave, sprint, kb, mb, meet...), examples/, custom/ (registry CLIs, podman/ollama, otel, agent CLIs, user-registered). INTERNAL verbs stay untouched (commands, app, skill, agent/tool/model, self, inspect, doctor, version + similar). Per command: folder entry (Bash# adapter; minimal Go main only where wrapper does not fit, say why) + dispatch case switched to the adapter, argv/surface unchanged. COMMIT PER COMMAND/CLUSTER - the pilot run died at the 40m print cap with one big commit; do not batch a whole folder into one commit. First commit within 15 minutes. Per command acceptance: builds ALONE GOWORK=off from its own entry with own pinned versions; dependency test: no other command's package in go list -deps (shared libs yoke pkg/*, coreutils, bsh fine); shared-code change isolated per command (local copy or self-pinned version; duplication acceptable); fast unit tests shipped+run. Non-fitting commands: EXCEPTION LIST on this story (verb + root cause). FINAL STAGE: drop unused generator code (internal/cmdgen, tools/cmdgen, internal/agentos/cmdcatalog + seam; seam call already removed by pilot - remove dead packages), prove unused via grep/build/tests, keep build-speed caches. Sync rule + producer-first pin order. Integration run at sprint end only.
