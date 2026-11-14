---
id: 0123321b5e80
kind: test
title: 'S3 contribute: trove add|put by owner, members and agents into a granted mount (URL, file, stdin, app artifact), provenance recorded'
seq: 292
status: todo
priority: p1
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:52.770059Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
---

Planned vendor: claude. Example level. Contributing content INTO a trove is a first-class, general operation: anyone with a write grant on a mount (the owner, a member, an agent acting as a principal) runs trove add SRC --to MOUNT [--as NAME] where SRC is a URL (bashy fetch --md), a local file, stdin, or an app:<command>/<id> artifact; trove put writes an existing entry's bytes to another writable mount. Every contribution records provenance (principal, agent tool/model if any, time, source ref, sha256) on the entry; --dry-run always; refused without a write grant with the same result on CLI and HTTP. Rod, not fish: small --json verbs with meaningful exit codes; any higher flow is a short Bash# skill-script composing them, itself shapeable. Accept: a member contributes a file and the owner sees it with the member's provenance; an agent's contribution carries producer: agent; a URL ingests as markdown; no write without a grant; --dry-run writes nothing. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md
