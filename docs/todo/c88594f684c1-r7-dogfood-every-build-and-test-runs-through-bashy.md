---
id: c88594f684c1
kind: requirement
title: 'R7 Dogfood: every build and test runs through bashy in an official bashy-base-derived build image'
seq: 399
status: todo
priority: p0
created: 2026-11-17T12:38:37.061563Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
---

Operator 2026-11-17: builds and releases must use bashy (dogfood) inside an official bashy base image, and cloudbox and bashy must strictly use it. Today: bashy-base:ubuntu24.04 (make build-bashy-oci, docs/bashy-oci-base.md) is the runtime foundation; tools/dev-test-container is a separate plain-Ubuntu build lane (build-essential, Go, make, libgpgme-dev, libseccomp-dev...) not derived from it; and ad-hoc runs on host shells (WSL distros, the dev box) use whatever is installed, e.g. yoke cmds/all failing to build on a WSL distro during the rc.37 run. Scope: one named derived image (e.g. bashy-build) FROM bashy-base with the pinned Go toolchain, cgo libraries and make; a reviewed digest pin; built from our own sources by bashy; all suites and release builds for bashy, yoke, outpost and cloudbox run as bashy oci run <image> inside the runner instances (R2/R6), with caches mounted from the runner (never re-downloaded); gate scripts refuse to run outside the image (an explicit, logged override for diagnosis only). Acceptance: yoke cmds/all and the full yoke, bashy, outpost and cloudbox suites build and pass in the image on the always-on host; a gate started on a bare host shell refuses with the reason.
