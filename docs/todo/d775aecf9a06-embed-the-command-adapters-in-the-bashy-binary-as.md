---
id: d775aecf9a06
kind: bug
title: Embed the command adapters in the bashy binary as the built-in default (fix 'adapter not found' outside a source tree)
seq: 615
status: done
priority: p0
created: 2026-11-21T21:56:07.989123Z
assignee: claude-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-22T12:00:05.754472Z
closed_by: claude-opus5.5
---

Operator approved 2026-11-21. Root cause (recorded on the 677 card from the integration run): resolveAdapterScript (bashy internal/agentos/adapter_dispatch.go) finds <folder>/<entry>/<entry>.bsh only on disk (BASHY_ADAPTERS_ROOT override, ~/.bashy/src/bashy source pin, exe tree, cwd/PWD, GOWORK, runtime.Caller) - inside the official build container none exist, so every adapter-routed command fails ('bashy dag: adapter yoke/dag/dag.bsh not found'); same for any installed bashy without the source pin. FIX (smallest): go:embed the adapter .bsh files of optional/, toolchain/, yoke/, examples/, custom/ into the bashy binary and use them as the LAST fallback in resolveAdapterScript (precedence unchanged: shape slot > override > source pin > on-disk roots > embedded). Write the embedded script to a content-addressed cache file (or run it from memory if bsh supports that) before exec. Only the .bsh adapters are embedded, not the command sources (each command still builds on demand). Acceptance: unit test with an empty HOME/cwd and no source pin resolves and runs an embedded adapter; precedence test (override and source pin still win); binary size delta reported. Start on current heads; unit tests only. Then the conductor reruns dag test in the official image.
