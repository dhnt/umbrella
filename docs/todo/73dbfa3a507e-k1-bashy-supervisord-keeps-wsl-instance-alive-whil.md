---
id: 73dbfa3a507e
kind: bug
title: 'K1: bashy supervisord keeps WSL instance alive while supervised oci jobs run (gate-host keep-alive product fix)'
seq: 597
status: wontfix
priority: p0
labels:
    - windows
created: 2026-11-21T11:09:13.126424Z
assignee: agy-sonnet5.5
sprint: 692
closed: 2026-11-22T13:41:41.090535Z
---

WONTFIX (operator rescope 2026-11-22, Sprint 692 plan docs/plan-sprint-692-release-thin-bashy.md): not required to release v1.0.0-rc.40 as the thin bashy core + shapeable commands. Venue tooling: gate-host runs stay session-attached. Design note is preserved in the salvaged weave #111 commit be717b1b (refs/salvage); reopen in the follow-up sprint if detached lane jobs are needed.

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

OPERATOR DECISION 2026-11-21 via bashy form (recorded on 677 card; relayed by conductor claude+2): PRODUCT fix, not a host tweak. bashy supervisord must keep the WSL instance alive (hold a wsl.exe session) while any supervised app/job runs under bashy oci in WSL, and drop it when none does. Blocks P1 long runs and A2 image roll + 86/86.

ROOT CAUSE (recorded on befc2403, P1 #587): gate-host WSL distro shuts down when idle - journalctl --list-boots showed 6 boots 01:35-02:01 PST lasting 20s-6min; WSL stops the instance when no wsl.exe session is attached, killing detached lane containers. P1 run #105 lane containers destroyed this way (then watchdog-killed at 48m, 0 commits); run #109 forced into attached-session-only measurements.

DESIGN NOTE BEFORE CODE (conductor requirement): worker's FIRST commit on this story is a design note (docs/ or story-linked) covering: where supervisord learns that a supervised oci job targets WSL; how the held wsl.exe session is started/owned/refcounted across concurrent jobs; how/when it is released (last job ends, supervisord shutdown, crash cleanup); failure modes (wsl.exe absent, distro name differences, session dies mid-job); why no effect when nothing supervised targets WSL. Manager reviews the design note commit before implementation proceeds - say so in your first submit.

ACCEPTANCE (conductor wording): on the gate host, a lane job launched through bashy oci survives its launching session exiting for longer than WSL's idle timeout; no effect when nothing is supervised; Windows-native test in resource the Windows-native gate resource (claim it first; name venue by role only in committed text - public repo scrub gate). Heavy gate runs only on gate host in official image via bashy oci (directive #2); targeted unit tests on dev box. Root cause before fixing any red test (directive #3). Every commit: Sprint/Story/Story-ID trailers + Agent (directive #4); submodule (bashy) commit+push first, then umbrella pin.

MANAGER DESIGN REVIEW (muse-wonder-full, 2026-11-21): APPROVED. Design note = docs/plan-wsl-keepalive-supervisord.md, commit be717b1b in weave #111 workspace (Agent trailer corrected by manager to agy-sonnet5.5; umbrella landing converged at WS tip 70526ef6, held only by another agent's uncommitted docs/INDEX.md edit in the shared checkout). Decisions on the note's section 9: (1) fail-closed on session-start failure - YES. (2) settings.wsl_distro + inference rules as designed (explicit wins; inferred resolved against wsl --list; unlisted inferred = no target, no error) - YES. (3) immediate release, no linger - YES (operator: drop it when none does). Implementation run: start with the section-8 gate-host spike (cat-on-pipe holds instance; close releases) and commit its result BEFORE the full implementation; then code per sections 2-7 in bashy (supervisord_wslhold.go + monitor hooks), targeted unit tests on dev box, Windows-native acceptance test per section 8 with control arm. Commit after each stage (spike / detection+hold / monitor wiring / tests) - no zero-commit long runs.
