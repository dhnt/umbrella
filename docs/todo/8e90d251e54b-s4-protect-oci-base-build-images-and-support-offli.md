---
id: 8e90d251e54b
kind: feature
title: S4 Protect OCI base/build images and support offline sandboxes
seq: 407
status: done
priority: p1
created: 2026-11-17T18:00:04.844141Z
assignee: agy-gemini4-carbon-s654
sprint: 654
sprint_id: e505bc2c-9f7b-5ce5-a426-7b88c6a8d198
sprint_title: 'Self-contained offline bashy: protected bootstrap and reusable artifact services'
closed: 2026-11-26T13:55:01.090052Z
closed_by: agy-gemini4-carbon-s654
---

Depends on S1 and S3; coordinate Sprint 653 build-image gate. Preserve image manifests/layers, engines, helpers, VM assets and build package inputs. Reuse Podman/image libraries; restore engine cache from CAS; disable external pulls; allow only declared internal dependencies. Go/Bash# default, other fences configurable packs. Acceptance: recreate engine storage, build and run new sandbox offline, prune preserves baseline/leases; nondeterministic image identities are never falsely promised recoverable.
