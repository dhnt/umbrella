---
id: 5efc76fc662d
kind: feature
title: 'S5 exemplars: ssh.bsh (superset face over outpost reach/doctor/connect --stdin/ssh exec with elevation and route handling) and kb.bsh; stub-outpost tests'
seq: 249
status: todo
priority: p1
labels:
    - agentic
created: 2026-11-13T19:17:59.408302Z
sprint: 633
sprint_id: 9e1f8ffa-529b-5c1a-8633-138b7615dc97
sprint_title: 'agentic <command>: self-improving skill-scripts as the calling agent''s muscle memory'
---

bashy/examples/agentic/exemplars/ssh.bsh is hand-written and is what make shows the model; it is also the seed of the live demo. Accepts the command's own argv (agentic ssh gatehost -- uptime, agentic ssh user@host) and a sentence (agentic ssh "connect to host gatehost"; slot extraction by regex, model fallback). Flow: outpost doctor; outpost reach HOST (JSON route lan|mesh|cloudbox|offline, exit 0/10/20); outpost ssh exec HOST --timeout 30s -- true; on 'elevation cookie' or 'no TTY': bashy secret exec <HOST>_SSH_PW=P -- sh -c 'printf %s "$P" | outpost connect --stdin HOST' then retry; answer {route, user, exec: outpost ssh exec HOST --timeout 10m -- CMD}; --json; never a password on argv or in the script. Pitfalls to encode from the kb: 1-minute exec cap, old daemon relays through the paid satellite, Windows targets need full exe paths and -EncodedCommand. kb.bsh: a plain-English face over bashy kb (search/show/ask) as the second exemplar. Tests: a stub outpost on PATH that flips route and cookie state; the recipe runs with zero model calls on native argv; a sentence fills the same slots. Hosts by role only; scrub gate applies.
