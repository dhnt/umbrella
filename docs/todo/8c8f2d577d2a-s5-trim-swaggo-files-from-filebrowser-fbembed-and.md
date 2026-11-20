---
id: 8c8f2d577d2a
kind: enhancement
title: 'S5: Trim swaggo/files from filebrowser fbembed and lazy-load compressed tiktoken vocabularies (-16 to -18 MB)'
seq: 555
status: todo
priority: p1
labels:
    - yoke
    - size
created: 2026-11-20T10:01:53.818655Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: yoke (and filebrowser-quantum fork if needed). (1) Decouple or build-tag github.com/swaggo/http-swagger + github.com/swaggo/files (8.57 MB of embedded Swagger UI assets unused by bashy) out of filebrowser/backend/fbembed. (2) Replace github.com/tiktoken-go/tokenizer/codec's 9.64 MB static init-time Go map literals in yoke/cmds/tokens with lazily decoded compressed vocabulary data loaded only when tokens runs without --fast. Acceptance: yoke/pkg/webconsole and yoke/cmds/tokens tests pass; binary shrinks by ~16-18 MB and startup avoids codec.init() map allocations. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
