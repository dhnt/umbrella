---
id: bbbb3b54a44e
kind: question
title: 'bashy thin core: the first-use adapter and its source checkout are not refreshed when the bashy binary changes'
seq: 856
status: todo
priority: p2
created: 2026-11-28T00:51:44.45467Z
---

Found 2026-11-27 in the Sprint 738 drill with a private BASHY_HOME and BASHY_ADAPTER_CACHE. After replacing the bashy binary with a newer build, 'bashy llm' kept using the adapter built from the earlier source checkout under BASHY_HOME/src/bashy (it stayed at the first commit fetched), so a fix in the pinned yoke did not reach the running door until the checkout was moved by hand and the cached adapter removed. With the real home (an older src/bashy) and an empty adapter cache the build failed with 'go: go.mod file not found'. Expected: the adapter is keyed to the binary's own source pin and rebuilt when it changes. Root cause not yet identified.

Root cause (2026-11-27), and why this is not fixed as a bug. Code inspected: bashy `internal/agentos/adapter_dispatch.go` (`resolveAdapterScript`), the adapter wrapper `yoke/llm/llm.bsh`, yoke `pkg/src/fetch.go`.
- A Go-backed adapter is built from `<home>/src/bashy/<adapter>` whenever that file exists; nothing compares that checkout with the running binary's release commit. The wrapper rebuilds only when the binary is missing or `main.go`/`go.mod` is newer than it. So after the bashy binary changes, the adapter keeps coming from the checkout made for the earlier binary.
- `src fetch` on an existing checkout at another commit **refuses** by design ("checkout at X, want release commit Y (remove it to re-fetch)"): `src/bashy` is the owner's editable source, with its own `pristine` branch and protected files. Moving it automatically could discard shaped changes.
- The "go.mod file not found" case was a development build in a home whose `src/bashy` predates the adapter layout; the resolver then fell back to the embedded wrapper, which has no Go sources beside it.
So the behaviour follows from a deliberate rule (the owner's source checkout wins and is never moved for them); what is missing is a decision on what an upgrade should do with it: refuse to run a mismatched adapter, warn, or migrate the checkout as part of `bashy update`. That is an owner decision about the source model, not a repair. Left open, reclassified from bug to a design question.
