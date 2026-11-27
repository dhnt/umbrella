---
id: a36b302f7f27
kind: bug
title: 'cligw door refuses claude/muse/agy: supervisor PATH lacks ~/.local/bin, router lookPath misses managed tools'
seq: 828
status: done
priority: p1
labels:
    - cligw
created: 2026-11-27T14:32:26.625354Z
assignee: claude-opus5.5
sprint: 738
sprint_id: 7ecf2342-069f-53f2-b07e-bd3a348052e9
sprint_title: 'Contained subscription agents: genie in a sandbox over cligw'
closed: 2026-11-27T16:49:27.912252Z
closed_by: claude-opus5.5
---

Found 2026-11-27 starting Sprint 738 C1. The host model door (bashy llm serve, started by outpost supervisord -> bashy supervisord) runs with PATH=/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/homebrew/bin, without bashy's own install dir ~/.local/bin. cligw's Router.toolInstalled (yoke pkg/cligw/router.go:499) resolves tool.Binary() with lookPath on that PATH, so every binding whose CLI lives only in ~/.local/bin (claude, muse, agy) is filtered out of /v1/models (filterServable) and refused with 503 "no matching candidate is installed and outside breaker cooldown"; codex and opencode (in /opt/homebrew/bin) are served. `bashy weave fleet` resolves the same tools from bashy's managed cache, so the two disagree. Classification: product defect (a realistic service environment exposes it): the door/supervisor must resolve fleet tools the way the fleet does, not depend on a login PATH. Evidence: /v1/models lists no claude/muse/agy rows; chat completion to claude-opus5.5 and muse-wonder -> that 503; ps -E of pids in the supervisor chain shows the PATH. Blocks Sprint 738 C1/C4/C6.

Refined cause (code): the fleet baseline declares claude/muse/agy cli.binary as bare names with a MANAGED INSTALL; cligw's worker launch honours it (worker.go startLocked -> agentlaunch.EnsureManaged), but Router.toolInstalled (router.go:499-506) only does exec.LookPath(tool.Binary()) on the door process PATH, so a managed-installable tool absent from that PATH is never a candidate (codex passes only because /opt/homebrew/bin has one). Proposed small repair (own C commit in yoke pkg/cligw): toolInstalled accepts a tool whose managed install resolves (the launch path's rule); unit test via withLookPath failing plus a managed spec. Then pin bump and a door restart to take it. Not started: awaiting operator go (restarts the shared host door).

## Resolution (2026-11-27, conductor)

Duplicate of Sprint 738 C2a (`7b1377e52c26`), found independently by the managed manager session. The proposed repair is what C2a shipped: yoke `c85cba65` (toolInstalled accepts a managed pin for this platform; other tools resolve like the fleet), bashy `a60e1c64`. The remaining failure after C2a (the door under outpost's system LaunchDaemon cannot use keychain logins) is fixed by G1 (`4b2f8a4ea109`, yoke `3c7b2a32`, bashy `345f01d0`): claude, muse and agy now answer PROBE_OK through 24556 via `bashy llm up --session`.
