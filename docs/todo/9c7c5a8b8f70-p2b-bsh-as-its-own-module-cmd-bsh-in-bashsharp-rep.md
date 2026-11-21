---
id: 9c7c5a8b8f70
kind: feature
title: 'P2b: bsh as its own module - cmd/bsh in bashsharp repo (P2 redo per operator rescope)'
seq: 602
status: done
priority: p0
created: 2026-11-21T12:04:41.714318Z
weave: 118
assignee: agy-opus5.5
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T12:17:41.15278Z
closed_by: muse-wonder-full
---

OPERATOR RESCOPE 2026-11-21 via conductor claude+2 (supersedes P2 46743cdd0cda placement): bsh must be its OWN module BEFORE P3/P4 depend on it. Do NOT put cmd/bsh in the bashy module. Home: bashsharp repo, cmd/bsh beside cmd/bashsharp (Sprint 575 put the shared CLI there). go.mod requiring ONLY bashsharp, coreutils and bash (+ the frozen sh/readline replaces they need), toolchain go1.27.4. The zero-yoke/zero-bashy link test (NO allowlist) and the binary smoke move with it, run GOWORK=off. bashy stays UNCHANGED (expand stage of expand->switch->contract); later bashy pins a released bsh. REFERENCE (not base): weave #114 commits bashy 95649bb2 + 41fb6ec8, preserved as live-bashy branch salvage/s677-p2-114 (manager-verified: 515 deps 0 yoke, tests ok, 31.0MB stripped, warm 0.68s) - port its main/test logic, sign as yourself. ACCEPTANCE: GOWORK=off go build + go test of bashsharp/cmd/bsh green; go list -deps shows ZERO yoke/bashy/ycode; bashsharp go.mod has no yoke/bashy requires; size + warm build numbers recorded. Fast unit tests shipped+run; 86/86 + frozen digest deferred to milestone gate.final (conductor-called). Sync rule: start from current origin heads (bashsharp/coreutils/bash), rebase before submit, no acceptance with mod drift stale/cycle on touched modules. Producer (bashsharp) commit+push first, then umbrella pin. Hold: P3 #115 does not integrate with bsh until this lands.

OPERATOR CONFIRMED 2026-11-21 (option b, via conductor claude+2): cmd/bsh in the bashsharp repo as its own module, minimal change - exactly as specified above. Name note for docs/comments: bsh = b[ash]sh[arp].
