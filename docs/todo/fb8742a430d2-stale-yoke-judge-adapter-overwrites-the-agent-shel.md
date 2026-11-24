---
id: fb8742a430d2
kind: bug
title: Stale yoke judge adapter overwrites the agent shell shims with its own path
seq: 722
status: done
priority: p3
created: 2026-11-24T19:49:57.353877Z
closed: 2026-11-24T21:22:01.776637Z
---

RESOLVED ON THE DEV BOX 2026-11-24; kept open only for the hardening below.

What happened: the cached judge adapter binary was built on 11-22 a little over an hour before the shim-target guard landed in yoke (ba95983e, validateShellShimTarget). At 10:44 AM PST on 11-24 it rewrote the sh/bash/zsh agent shims to exec the judge binary; agents resolving a bare shell name through the shim directory then failed with 'bashy judge: unknown shorthand flag: c'. It stalled the sprint 675 manager's checkpoint loop for 65 minutes.

Root cause: an adapter wrapper rebuilds only when its own main.go or go.mod is newer than the cached binary. The cache is shared by every checkout and weave workspace, so a run from an older workspace sees nothing newer and keeps using the stale binary.

Done: shims rewritten by hand; judge rebuilt through its own wrapper from the current checkout (5 s); all 14 cached adapters that write shims now contain the guard (checked by symbol scan).

Remaining (hardening, optional): (1) key the adapter cache on the pinned source version rather than file mtime, so a shared cache cannot serve a binary older than the checkout expects; (2) a doctor check that shim targets are the bashy launcher.
