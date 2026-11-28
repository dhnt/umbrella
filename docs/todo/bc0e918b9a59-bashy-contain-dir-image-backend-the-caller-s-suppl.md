---
id: bc0e918b9a59
kind: bug
title: 'bashy contain --dir (image backend): the caller''s supplementary groups are not carried into the container'
seq: 857
status: todo
priority: p3
created: 2026-11-28T00:51:44.643886Z
---

Sprint 738 review round 2 (codex), should-fix, not done in the sprint. The confined image run passes --user UID:GID, so a path or socket the caller can reach only through a supplementary group is unreachable inside. Fix and test with a group-access-only socket; check that the chosen podman option works for both rootless and rootful engines before using it.
