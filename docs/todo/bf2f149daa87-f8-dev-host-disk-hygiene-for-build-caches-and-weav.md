---
id: bf2f149daa87
kind: chore
title: F8 Dev-host disk hygiene for build caches and weave/grade checkouts
seq: 129
status: todo
priority: p3
labels:
    - collaboration-followup
created: 2026-11-11T09:56:33.048261Z
---

Sprint 614 ran the dev host to 0 bytes free (Go build cache 65 GB, temp 41 GB, grade attempts and weave workspaces). Add a bashy-visible check and a safe, age-based reclaim verb (go-build cache trim, stale go-build temp dirs, grade attempts of ended sprints, workspaces of merged/abandoned runs) with --dry-run and --json; never touch other agents' live work.

## Root cause for grade checkouts (2026-11-21)

`bashy sprint grade` fetches the run into a fresh checkout under
`$BASHY_HOME/sprint/grade/<sprint>/<hash>/` (yoke
`pkg/weave/sprint_grade.go`, around line 239). It runs the gate there and
records the verdict as a `grade` event on the sprint thread. Nothing ever
removes the checkout. The verdict lives in the thread, so the checkout is
disposable once the event is written. On the dev host it had reached 10 GB
across 12 sprints (Sprint 557 alone: 2.2 GB, because an umbrella checkout
includes its submodules). The ended sprints' checkouts were removed by hand on
2026-11-21 (6 GB).

Fix at the source, ahead of the reclaim verb (operator rule 2026-11-21):
DELETE IS THE DEFAULT; retention is explicit.
- Grade: remove the checkout as soon as the grade event is recorded,
  whether the gate passed, failed or errored. `--retain` (recorded in the
  event, with its path) keeps it for inspection.
- Weave workspaces, same rule: when a run reaches a terminal state (merged,
  pulled, abandoned, stopped), remove its workspace unless the run was started
  or marked with an explicit retain flag. Unmerged commits are never lost:
  before removal, push the run branch or confirm its commits are reachable
  from it (`git cherry`). A workspace with uncommitted changes or unpushed
  unique commits is kept, and reported as retained-for-safety with the reason.
- Retained items carry an owner and reason; the reclaim verb lists them and
  ages them out.
Tests: a grade leaves no checkout by default; `--retain` keeps it and
records the path; a merged/abandoned weave run's workspace is removed by
default; a dirty workspace or one with unique unpushed commits is kept and
reported; a run marked retain is kept.

Also seen on the same day: an untracked default podman machine (8 GB of
memory, 16 GB disk) had run on the dev host for 10 days and filled swap.
`bashy podman` manages only the `bashy` machine, so it cannot see or stop the
default one. The reclaim/check verb should report running podman machines
that bashy does not manage.
