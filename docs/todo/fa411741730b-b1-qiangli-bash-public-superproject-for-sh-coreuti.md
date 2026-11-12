---
id: fa411741730b
kind: doc
title: 'B1 qiangli/bash: public superproject for sh + coreutils with READMEs'
seq: 167
status: todo
priority: p1
labels:
    - software-shaping
created: 2026-11-12T19:29:38.581702Z
sprint: 622
sprint_id: 03e47ab4-d1a0-5152-97e2-eee6dcb08395
sprint_title: 'Software Shaping one theme: definition, READMEs, qiangli/bash, product marks'
---

Repo creation approved by operator 2026-11-12. Thin superproject: submodules sh (qiangli/sh) + coreutils (qiangli/coreutils), README (pure-Go GNU Bash 5.3 + POSIX.1-2016 userland, one binary every OS, built for POSIX certification but NOT certified - cite S561 evidence and S571 readiness, 86/86 gate pointer, how bashy consumes it), MIT LICENSE for the superproject. Prepend a fork section to sh/README.md (keep upstream text); add 'part of qiangli/bash' line to coreutils/README.md. Not mounted in the dhnt umbrella. Planned worker: muse-spark1.3. Verify: git clone --recurse-submodules on a clean dir; scrub gate.
