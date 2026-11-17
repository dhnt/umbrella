---
id: f83b4703cae4
kind: bug
title: outpost daemon.log prints the MCP bearer token in plaintext at startup
seq: 439
status: todo
priority: p1
labels:
    - outpost
    - security
created: 2026-11-17T21:03:06.658435Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

2026-11-17 gate host: the first lines of ~/.cache/outpost/daemon.log (4.4 GB, never rotated) contain the MCP bearer token in clear. Fix: never log secrets (redact or log a fingerprint); rotate the exposed token on affected hosts after the fix; consider log rotation for daemon.log. Unit test asserting no token in startup log output; build.

2026-11-17 operator: remove. Done on the gate host: 66 occurrences of '(bearer: <token>)' in ~/.cache/outpost/daemon.log overwritten in place with X (same length, notrunc, daemon kept appending; inode/offsets unchanged); 0 remaining; no other log in the cache dir carried it. Still open: the product fix (never log the token), rotating the exposed token (it is the live one), and the same line is presumably in every other host's daemon.log.
