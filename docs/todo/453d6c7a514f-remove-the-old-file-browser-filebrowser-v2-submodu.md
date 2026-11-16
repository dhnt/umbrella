---
id: 453d6c7a514f
kind: chore
title: Remove the old File Browser (filebrowser/v2) submodule and every reference
seq: 382
status: done
priority: p1
labels:
    - build
created: 2026-11-16T11:40:53.503599Z
closed: 2026-11-16T11:57:03.207791Z
---

Operator decision 2026-11-16: the old File Browser fork (github.com/filebrowser/filebrowser/v2 via qiangli/filebrowser, umbrella submodule filebrowser/) is no longer used and is to be removed cleanly now, accepting breakage. The quantum fork (qiangli/filebrowser-quantum, module github.com/gtsteffaniak/filebrowser/backend) stays.

Impact survey: cloudbox, outpost, yoke and current bashy link 0 v2 packages. ycode links 16 through its stale bashy pin (rc.9-dev 2026-10-27, internal/harness/bashy -> bashy/pkg/harnessrunner -> internal/agentos). bashy container scripts (test-self-container.sh, tools/bashy-oci) stage the filebrowser/ sibling.

Scope: bump ycode's bashy pin; drop the v2 replace/require from ycode and bashy; drop the bashy container staging, sbom/license entries and docs; drop filebrowser from yoke pkg/src repos; drop the umbrella submodule, .gitmodules, go.work use+replace, sync.sh list and CLAUDE.md layout. Historical evidence files (s561 manifests, tour results) stay as records.
