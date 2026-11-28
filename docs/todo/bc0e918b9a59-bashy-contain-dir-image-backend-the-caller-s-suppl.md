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

Status (2026-11-27): not fixed, because it cannot be verified here. The limitation is in rootless podman (`--userns=keep-id` does not carry supplementary groups; it predates the `--user` flag). The candidate fix, `--group-add keep-groups`, works only with some runtimes and only rootless; the gate lanes run rootful as root, where it cannot be exercised, and a wrong option would break every rootless confined run. No reproduction exists yet. Needs a rootless Linux venue first: reproduce with a group-access-only socket, then choose the option.
