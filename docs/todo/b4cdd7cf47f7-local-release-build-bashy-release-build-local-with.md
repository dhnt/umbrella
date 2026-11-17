---
id: b4cdd7cf47f7
kind: feature
title: 'Local release build: bashy release build --local, with GitHub used only to publish assets'
seq: 386
status: todo
priority: p1
created: 2026-11-17T11:49:55.979453Z
---

Operator 2026-11-17: GitHub is the biggest release risk (rate limits, quota blocks); move builds to the local machines and leave only the public release on GitHub. Scope: reproduce release.yml locally (preflight, govulncheck, license gate and SBOM matrix, the darwin native build on a macOS host, GoReleaser linux/windows and linux packages inside bashy oci on the always-on Windows gate host via loom, the scratch image), then one gh release create with uploaded assets plus a local promote (gh release edit), replacing promote.yml. Target: about 15 min per release after the first. Trade-off to decide: GitHub Actions build-provenance attestation is unavailable locally; replace it with local checksums, SBOMs and possibly a signed manifest. Follows docs/local-loom-sdlc-control-plane.md (GitHub only for public hand-offs). rc.37 ships through GitHub by operator decision; this lands next.
