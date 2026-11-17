---
id: 77c567eacb9d
kind: feature
title: 'R8 Strict mode: only bashy and registered commands run; a build''s external tools come from a bashy config that auto-registers them'
seq: 400
status: todo
priority: p1
created: 2026-11-17T13:17:47.628701Z
sprint: 653
sprint_id: 9df162a8-6713-594e-b658-a9d7fc8d1938
sprint_title: 'Registered remote runners: run any bashy command or dag task on a remote outpost, GitHub or AWS as if it were local'
---

Operator 2026-11-17. A shell-wide switch (bashy --strict, BASHY_STRICT=1) under which a bashy -c session, dag body or skill-script may run only: bashy builtins and Go applets (incl. bashy go and friends), and registered commands. Any other external command is refused with a named reason ('make is not registered: add it to this build's commands config'), never found silently on PATH, including absolute-path calls. The allowlist is a bashy config, not a bare list: a build declares the external tools it needs (e.g. cc for a cgo build) in a bashy config file that is auto-registered when the build starts, each entry with what bashy commands add takes today (exec path or download, version or sha pin through the binary manager, effects), so the build's dependencies are explicit, pinned and visible in the atlas. Existing pieces to reuse: the command registry (bashy commands add, rings), the atlas external view and effects, the MCP policy that already refuses unknown commands. Uses: bashy's own self-build runs strict with an empty external config (generalising the make stub in tools/bashy-build/build.sh, which misses absolute paths); the official build image sets strict mode, and each repo's build carries its config (yoke and cloudbox cgo: cc, pkg-config). Acceptance: bashy dag build under --strict with no config builds bashy; an unregistered external in a strict session is refused with the reason; a config entry auto-registers and then runs; the refusal and registration show in --json.
