---
id: 967a7d958160
kind: bug
title: 'bsh startup gate red: github.com/mattn/go-runewidth init costs 12-14 ms (cap 5 ms/package, 15 ms total) in the bsh binary'
seq: 625
status: todo
priority: p0
labels:
    - bashsharp
    - release
    - gate
created: 2026-11-22T16:00:49.888603Z
sprint: 692
---

Candidate gate leg 2 (umbrella 8b8db523f, docs/sprint-677-integration-evidence.md): test-startup-linux now measures bsh and fails deterministically (4/4 runs) with 'inittrace: 14-21 ms total (309 packages); max 12-14 ms (github.com/mattn/go-runewidth)'. POINTER: bashsharp/cmd/bsh/go.mod pins upstream github.com/mattn/go-runewidth v0.0.27 (indirect, via the readline fork), while bashy/go.mod replaces it with github.com/qiangli/yoke/external/runewidth (a fork that exists exactly to tame init cost). bsh must stay zero-yoke (TestBshImportBoundary), so the yoke fork cannot be pulled in as-is. ROOT CAUSE FIRST: read what v0.0.27's init() does (LUT build / env probing) and diff it against yoke/external/runewidth; measure with GODEBUG=inittrace=1 on a bsh build. SMALLEST FIX candidates, pick by measurement: (a) pin bsh (and the readline fork) to a go-runewidth version whose init is cheap, if readline's API needs allow it; (b) make the readline fork import a bashsharp-local copy of the trimmed fork (new path under bashsharp/external, no yoke import); (c) lazy-init in the readline fork so runewidth is only touched on an interactive terminal. Do not loosen the thresholds in scripts/test-startup-linux.sh. Verify: GODEBUG=inittrace=1 on the rebuilt bsh (linux/amd64 cross-build is fine for inittrace) shows max package init under 5 ms and total under 15 ms; bsh builds GOWORK=off; TestBshImportBoundary passes; readline unit tests pass. Any readline/engine-side change is a separate commit (migration policy: engine inputs changed -> the conductor reruns the sealed Bash gate). Owner codex, --repo . (umbrella: touches bashsharp and possibly readline). TEST RULE (operator 2026-11-22): build + smallest targeted unit tests only, then submit; the re-run of the red gate legs is the conductor's. Root cause recorded on this story BEFORE the fix. Start on current origin main of each repo touched; Sprint/Story/Story-ID + Agent trailers; submodule commit first (do not push), the conductor merges and bumps pins. Long remote commands: nohup + poll, never block one command for more than a minute.

POINTER (conductor): yoke commit 99ef1333 "external: defer runewidth table construction until first width query" is the fork that bashy uses via replace; its diff vs upstream v0.0.27 is the smallest known fix. Carry the same change into bsh without importing yoke: a bashsharp-local copy (bashsharp/external/runewidth, module path under github.com/bashsharp/bashsharp) replaced into bashsharp/cmd/bsh/go.mod, or the equivalent lazy-init in the readline fork. Keep the LICENSE and README.yoke.md provenance notes with any copy.
