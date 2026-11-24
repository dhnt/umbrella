---
id: f5e23483d156
kind: enhancement
title: kb search inside a repo should also read the host knowledge base
seq: 688
status: todo
priority: p2
labels:
    - kb
created: 2026-11-24T08:16:54.553288Z
---

Observed 2026-11-24 (operator feedback during the sprint 675 start review). Inside a git repository, 'bashy kb search TERMS' reads only that repository's docs/kb store. A page in the host store is found only with --user or --ring host, so an agent that searches before a task misses host knowledge unless it already knows which ring holds it. 'bashy kb context --for TEXT' already assembles the repo and host rings together and returned the host page in the same test.

Operator position: a knowledge base is host wide. A repository can be checked out by another user or agent at another location, so the repo store cannot be the only default place a search looks; host facts (where private evidence lives, machine-specific recipes) must be findable from any checkout without knowing the ring.

Ask: make 'kb search' read the repo ring and the host ring by default when run inside a repo, labelling each hit with its ring as 'kb context' does; keep --repo / --user / --ring to narrow to one. 'kb add' keeps its current default (repo store inside a repo). Check the skill text and 'kb --help' scope paragraph, which describe the single-ring default.

Owning code: yoke pkg/kb (resolve.go, search.go). Acceptance: from inside a repo, a term present only in a host page is returned by plain 'kb search' with a host label; a repo-only term still returns its repo page; narrowing flags unchanged; unit test in pkg/kb.
