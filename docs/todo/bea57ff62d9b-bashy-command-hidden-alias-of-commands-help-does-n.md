---
id: bea57ff62d9b
kind: bug
title: 'bashy command (hidden alias of commands): --help does not follow the alias; recommender suggests the hidden spelling'
seq: 877
status: todo
priority: p3
labels:
    - commands
created: 2026-11-28T21:35:51.381433Z
---

Seen 2026-11-28 at bashy c5b94ec4. (1) bashy command --help prints 'bashy help: no atlas entry for "command"' while bashy commands --help works; the front door maps command to commands (internal/agentos/agentos.go:1332), but help resolution does not. (2) The not-found recommender for 'bashy version' suggested 'bashy command add version', which is the hidden spelling; it should name the canonical 'commands'. Inside the shell, 'command' stays the POSIX builtin.
