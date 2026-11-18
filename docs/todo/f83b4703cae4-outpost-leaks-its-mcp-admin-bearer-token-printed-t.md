---
id: f83b4703cae4
kind: bug
title: 'outpost leaks its MCP admin bearer token: printed to daemon.log on every start since 2026-05-25; log world-readable on macOS/Linux (local only)'
seq: 439
status: assigned
priority: p1
labels:
    - outpost
    - security
created: 2026-11-17T21:03:06.658435Z
assignee: s575-codex-manager
sprint: 658
sprint_id: f426cf37-7c11-5d0c-beca-7e405177868d
sprint_title: outpost MCP admin token leaked to daemon.log (fix with the refactor/rebuild)
---

2026-11-17 gate host: the first lines of ~/.cache/outpost/daemon.log (4.4 GB, never rotated) contain the MCP bearer token in clear. Fix: never log secrets (redact or log a fingerprint); rotate the exposed token on affected hosts after the fix; consider log rotation for daemon.log. Unit test asserting no token in startup log output; build.

2026-11-17 operator: remove. Done on the gate host: 66 occurrences of '(bearer: <token>)' in ~/.cache/outpost/daemon.log overwritten in place with X (same length, notrunc, daemon kept appending; inode/offsets unchanged); 0 remaining; no other log in the cache dir carried it. Still open: the product fix (never log the token), rotating the exposed token (it is the live one), and the same line is presumably in every other host's daemon.log.

Scope (2026-11-17, verified in code): cmd/outpost/main.go:1050 prints 'MCP endpoint: <url>/mcp/  (bearer: <token>)' to stderr on every daemon start since outpost 79335b0 (2026-05-25); the supervisor sends stderr to ~/.cache/outpost/daemon.log, which on macOS/Linux is -rwxr-xr-x in a drwxr-xr-x dir (agent.json, the token's real home, is 0600). The token grants the full MCP admin surface (apps/builtins/bundles install, SSO secrets, federation/cluster tokens, pairing, sshd, upgrade = code exec as the outpost user). The endpoint listens on 127.0.0.1:17777 only: local privilege escalation / credential leak, NOT remotely reachable.
Operator decision 2026-11-17: not remotely accessible, so no fleet mitigation now; fix with the upcoming refactoring/rebuild, tracked in its own sprint (658). Fix: print the endpoint without the token (outpost mcp show prints it on demand); create logs 0600 and tighten existing logs/cache dir at startup; rotate every host's MCP token and redact old logs on rollout; unit test that no secret appears in startup output. Gate host log already redacted (66 occurrences).
