---
id: ffd48cc9993d
kind: bug
title: 'K1b: implement supervisord WSL keep-alive per approved design (K1 73dbfa3a)'
seq: 599
status: todo
priority: p0
labels:
    - windows
created: 2026-11-21T11:19:35.118789Z
assignee: agy-sonnet5.5
sprint: 692
---

PAUSED (operator 2026-11-21, via conductor claude+2): all non-677 work paused until the 677 refactor completes, and inside 677 focus is ONLY the refactor (bsh own module / generator+dispatcher+pilot / convert all / retire switch). This side story is checkpointed here and STOPPED - do not staff or continue until the conductor unpauses it. State preserved: see salvage branches and prior records on this story.

weave     #112 (in flight)

Implementation of K1 73dbfa3a507e per APPROVED design docs/plan-wsl-keepalive-supervisord.md (commit be717b1b; full design text also in weave issue-111 workspace if the umbrella landing has not reached your clone yet - read K1 story 73dbfa3a for root cause + manager decisions). Manager decisions (design section 9): fail-closed on session-start failure; settings.wsl_distro + inference as designed; immediate release, no linger.

STAGES, commit after each (Sprint/Story/Story-ID trailers + Agent: agy-sonnet5.5 - sign as YOURSELF): (1) gate-host spike per design section 8: prove wsl.exe cat-on-open-pipe holds the instance past idle timeout and closing the pipe releases it; commit spike result (script + observed output) FIRST. If pipe does not hold, fall back to pty sleep-infinity per design and say so in the commit. (2) bashy code per design sections 2-7: internal/agentos/supervisord_wslhold.go (wslTarget, wslHold Ensure/Reconcile/Close, starter seam) + supervisord_monitor.go hooks (Reconcile in transition, Ensure before Activate, Close in run defer) + owner record reuse. (3) targeted unit tests on dev box via bashy dag (wslTarget table; fake-starter hold lifecycle incl. shared session, last-release, backoff-keeps-hold, forced shutdown, death-restart, no-target-never-starts, Ensure fail-closed). (4) Windows-native acceptance on gate host per design section 8 (claim the Windows-native gate resource first; venue by role only in committed text): supervised detached oci lane job survives launching-session exit > idle timeout with unchanged boot_id; control arm without supervisord dies/boot_id changes; after stop, hold wsl.exe gone + distro Stopped. bashy submodule commit+push first, then umbrella pin (directive #4). Root cause before fixing any red (directive #3). K1 parent story closes when this is accepted.

OPERATOR RULE 2026-11-21: skip long-running tests during implementation; close on build + targeted unit tests. For THIS story: the short gate-host spike (stage 1) stays (it is development evidence, minutes); the full Windows-native survival acceptance incl. control arm is DEFERRED TO FINAL GATE - record 'windows-native survival acceptance deferred to final gate' in the submit. No lane-long suites mid-sprint.

OPERATOR RULE 2026-11-21 (typed, supersedes earlier 'final run at sprint end' wording): this story ships enough FAST unit-test coverage, written and RUN while building (smallest maintained tests in the repo's normal layout, asserting the changed behavior). Integration tests (go test ./..., Bash 86/86, 3-OS dispatch e2e, browser/judge tests, release gates) run ONLY at epic/milestone completion via .bashy/gate.final when the conductor calls the milestone - NOT per story, NOT per sprint. Any earlier text in this story saying 'sprint-final gate' means that milestone integration gate. Per-story gate (.bashy/gate) is build-only. Record skipped integration checks in the submit as 'deferred to milestone integration gate (gate.final, conductor-called)'.

SYNC RULE (operator 2026-11-21, typed; conductor relay): never work on outdated code. (1) Start from CURRENT origin default branch of each repo touched, never stale umbrella pins or the shared checkout. (2) Before submit: rebase onto current origin (incl. S0 baseline sync 6ce2c2cb once landed) and rerun this story's unit tests. (3) After merge, manager syncs consumer go.mod pins (producer push first) + umbrella pins. (4) This story is not accepted while 'bashy mod drift' shows stale/cycle for modules it touched. (5) No long-lived branches left to rot.

RUN #112 CLASSIFICATION (manager, 2026-11-21): agy print-timeout 40m0s killed the turn during the windows-native acceptance (tool limit, not watchdog state, not venue). Stages 1-3 were already committed in bashy (spike 877510c5, feat 1b2834f1, tests 91d49783) and manager-verified (go test ./internal/agentos/ -run WSL ok 1.836s; diffs additive per staging rule). Preserved as salvage/s677-k1b-112; remainder = K1c 80b2540c53f1 (rebase onto S0 + rerun + deliver; windows acceptance deferred to milestone gate).
