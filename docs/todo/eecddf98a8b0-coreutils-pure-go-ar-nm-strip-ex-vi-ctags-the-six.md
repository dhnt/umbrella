---
id: eecddf98a8b0
kind: feature
title: 'coreutils: pure-Go ar nm strip ex vi ctags (the six POSIX names still served by pinned external providers)'
seq: 876
status: todo
priority: p3
labels:
    - posix
created: 2026-11-28T21:28:39.85036Z
---

From the Sprint 749 plan (D5). Agents expect the POSIX-required set on every OS without probing. Six names (ar nm strip ex vi ctags) come from pinned external providers that need a download, so a fresh machine without network, especially Windows, does not have them. Until this lands, the manifest lists them as guaranteed after install, with their state in bashy version --json.
