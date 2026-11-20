---
id: fa9fcc8de90d
kind: task
title: Expose dag.md task discovery through make help in one pilot project
seq: 558
status: todo
created: 2026-11-20T10:31:08.700554Z
sprint: 678
sprint_id: e2cf7613-74c4-537f-ad54-327d8dcebbc1
sprint_title: Discover dag.md project tasks through make help
---

Pilot in the bashy submodule, which already has a Makefile and dag.md. Extend make help to show how to run bashy dag <target> and list the live targets with bashy dag --list. Keep task bodies and dependencies in dag.md. Add a short agent-facing pointer to list and run tasks and optionally export an Agent Skill with bashy dag --skill DIR. Preserve existing Make targets, default goal, and help output. Verify make help lists the same targets as direct discovery without running task bodies, preview a listed target with --dry-run, and verify skill export in a temporary directory. The umbrella-wide rollout and language-specific converters are outside this pilot.
