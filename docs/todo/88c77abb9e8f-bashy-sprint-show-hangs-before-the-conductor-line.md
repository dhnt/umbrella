---
id: 88c77abb9e8f
kind: bug
title: bashy sprint show hangs before the conductor line when the conductor seat has no managed inbox delivery
seq: 458
status: todo
priority: p2
labels:
    - sprint
created: 2026-11-18T17:26:18.515091Z
---

Observed 2026-11-18 (found by the Sprint 655 command checker). After 'bashy sprint take 655 --owner claude-opus5.5-s655' (a seat registered with 'bashy agent add', claimed via BASHY_AGENT, reported 'no verified managed inbox delivery'), 'bashy sprint show 655' prints the goal checklist and then never exits: timeout 25 -> exit 124, with stdout to a pipe, a file or the tool, with or without BASHY_AGENT in the environment and with or without --no-input. Same host and binary: 'bashy sprint show 575' (conductor s575-codex-manager) completes in about 4 s. Before the take, 'sprint show 655' completed. Root cause not yet identified: next step is to profile the conductor/lease/inbox section of sprint show for this seat. Not a checker artifact: reproduced without the checker and without timeout --foreground differences.

## Follow-up measurement (2026-11-18)

Without any timeout wrapper, `bashy sprint show 655 </dev/null >/dev/null 2>&1`
finished with exit 0 after 9m07s. Its completion roughly coincides with
`bashy sprint end 655` releasing the conductor lease, which suggests the
conductor section waits on the live seat/lease (unconfirmed). So it is a very
long stall rather than a permanent hang; root cause still to be identified.
