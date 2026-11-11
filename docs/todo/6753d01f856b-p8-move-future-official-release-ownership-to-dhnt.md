---
id: 6753d01f856b
kind: feature
title: P8 Move future official release ownership to dhnt
seq: 138
status: todo
priority: p2
labels:
    - shaping
    - dogfood
created: 2026-11-11T20:10:51.364024Z
sprint: 618
sprint_id: deff293a-cb7b-552c-9392-3edf1b388c44
sprint_title: 'Bashy shaping wave 2: coupled-source pilot, dhnt release ownership, shaping-first enforcement'
---

Depends on P4/P7. Adapt existing build-once/byte-promotion mechanism for qiangli staging artifacts -> dhnt official releases. Verify repository identity, exact source, complete assets, hashes and provenance across that boundary before publication; preserve historical qiangli release URLs/assets. Preserve existing module paths for this transition; ensure consumer commits remain resolvable there. No bashsharp/* release or organization changes.

Use self-hosted validation routes by default; do not make paid hosted CI a prerequisite. Preserve signing and existing release eligibility checks. Source PR, release publication and installation are separate operations with distinct evidence/authorization.

Acceptance: dry-run/scratch publication proves cross-repository provenance and byte-identical complete artifact transfer with no rebuild, safe retry and partial-failure recovery. Installer/update references are explicitly reconciled before ownership cutover. Do not enable unsupported package channels as a side effect. Actual release needs explicit operator approval; no official v1.0.0 before POSIX certification.
