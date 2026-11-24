---
id: 804b7d9720e0
kind: feature
title: 'H6 MVP trove, the virtual drive: path-keyed bashy-trove-v1 layout in the vault; mount add|ls|rm; ls|find|stat|cat|put|add over dir:, dir:@host, git:'
seq: 290
status: done
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.485725Z
assignee: agy-gemini4-neon
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
closed: 2026-11-24T14:26:51.555793Z
closed_by: claude-opus5.5
---

Staffing 2026-11-24: agy (one worker per vendor; claude holds H1). Hermetic first; the hosted-call acceptance waits for H1 and H2. Start from current heads.

Planned vendor: claude. Example level, bashy/examples/trove/ (trove.bsh + register.sh + embedded skill + hermetic tests). Moved from Sprint 639 S1 on 2026-11-23 and slimmed: the trove is the virtual drive of every cloudbox user, a small JSON of mount points with no storage of its own. Layout bashy-trove-v1, path-keyed: {"schema_version":"bashy-trove-v1","/home":{"locator":"dir:/srv/home@studio-host"},"/drive":{"locator":"drive:My Drive/bashy","account":"me@example.com"},"/repo":{"locator":"gh:owner/repo","account":"owner"}}; values reuse the lens locator grammar (yoke/pkg/ref/locator.go); account names the vault entry holding the token. The layout is read from and written to the vault entry trove/layout through the bashy secret client, with a local file override for tests and for an outpost offline. Verbs: mount add PATH LOCATOR [account=...]|ls|rm; ls|find|stat|cat PATH --json emitting bashy-node-v1 rows + trove attrs (mount, owner, provenance) over bashy lens -t listing for dir:, dir:@host (outpost sftp), git:; put SRC PATH and add URL PATH (bashy fetch --md) to writable dir: mounts; --dry-run on writes; exit 0/3/1, host offline = 3 by name. No grants in this slice (639 S6 later); drive:/gh: in H6b. Accept: rows pass the bashy-node-v1 validation used by provider/recipe_test.go; trove cat of a peer-host file equals lens output; unknown path not-found; no live account in tests; inside an H1 hosted call trove ls and trove put leave no state on the runner. Spec: docs/sprint-691-master-execution-plan.md; design: docs/trove-content-app-design.md

Merged 2026-11-24 by the conductor: bashy 29cd8db6 (cherry-pick of 8ae72773 onto main after H1). Evidence (worker run 235): GOWORK=off go -C bashy/examples/trove test ./... 6/6 PASS, vet, gofmt, bashy --bashsharp -n, GOWORK=off go -C bashy build ./..., yoke TestRecipe, scrub gate. Follow-up carried into H6b: runTrove must fail closed against the real vault (dead loopback BASHY_CLOUDBOX_URL by default).
