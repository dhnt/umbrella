---
id: 73feb12c6472
kind: feature
title: F2 A new agent reaches shaping in one documented step, accountability unchanged
seq: 461
status: todo
priority: p2
labels:
    - shaping
    - agent
created: 2026-11-18T18:32:34.025051Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
---

Problem: an agent CLI with no registered identity gets 'authored communication: unattributed agent session' from shape and mb. Sprint 655 needed 'bashy agent add NAME --tool T --model M', then 'export BASHY_AGENT' and a seat claim ('inbox --as NAME --peek') before 'shape status' worked; '--as NAME' alone was not enough until the seat was claimed. A human passes '--as <name>'.
Behavior: keep the accountability rule (every shaping action has an actor). Reduce first use to one documented step the error message prints verbatim, e.g. one command that registers the detected tool/model and claims the seat for this session. Decide whether '--as NAME' on an already registered, unclaimed name should claim the seat itself.
Depends on: none. Origin: Sprint 655 S1 disposable shaping run.
Verification: from a fresh bashy home under an agent CLI, the printed step followed by 'bashy shape status APP --user U' succeeds; actor is recorded exactly as today; unattributed sessions are still refused.
