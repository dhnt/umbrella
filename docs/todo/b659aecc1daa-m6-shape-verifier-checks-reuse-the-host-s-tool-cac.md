---
id: b659aecc1daa
kind: bug
title: M6 shape verifier checks reuse the host's tool cache (BASHY_BIN_CACHE) like GOMODCACHE/GOCACHE
seq: 742
status: todo
priority: p1
labels:
    - shaping
created: 2026-11-25T06:41:16.812481Z
sprint: 709
sprint_id: b7f6e528-7ee8-56aa-a9bf-0f1db3f255d2
sprint_title: 'Member pull/push: a granted member shapes the owner''s app from their own machine'
---

Found by M4 (6ba1b4777931). Operator 2026-11-24: "file and do the right thing".

Root cause (conductor, code inspection 2026-11-24): a shape verifier check runs with a scrubbed environment and HOME inside the clone. yoke pkg/shape/verify/verify.go checkEnv already shares the host's Go module and build caches (goCaches: GOMODCACHE, GOCACHE, per the warm-cache rule) but not binmgr's tool cache. So a check that runs `bashy go` (examples/desk/page/checks/go.bsh) finds no cached Go toolchain and downloads it again from go.dev (yoke external/gotoolchain Ensure -> resolveFile): it fails offline (the gate sandbox) and re-downloads ~70 MB per verification on a real host. Class: product defect (generic, not Page-specific); exposed by a realistic offline venue.

Fix (KISS, one pattern): in checkEnv, also set BASHY_BIN_CACHE to the host's binmgr cache, resolved in the verifier process (yoke pkg/binmgr CacheDir(): $BASHY_BIN_CACHE, else <UserCacheDir>/bashy/bin), the same way goCaches shares GOMODCACHE/GOCACHE. Same trust posture as the module cache already shared. No Page change, no new flags.

Acceptance (gate host, GOWORK=off): a unit test in pkg/shape/verify that checkEnv carries BASHY_BIN_CACHE equal to binmgr.CacheDir() (honouring an explicit $BASHY_BIN_CACHE); existing pkg/shape/verify and pkg/shape tests green. Record the verify command + result. Trailers Sprint/Story/Story-ID + `Agent: <assignee>`. Push nothing; the conductor merges. Then M4 resumes on top (sandbox seeds the Go toolchain into the owner's tool cache; Page leg green twice).
