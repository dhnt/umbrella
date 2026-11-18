---
id: ce6fff80608e
kind: feature
title: F1 Contract check is a one-line opt-in inside contained shaping checks
seq: 460
status: todo
priority: p1
labels:
    - shaping
    - yoke
created: 2026-11-18T18:32:33.868353Z
sprint: 662
sprint_id: 4a1de847-5d33-5688-abf3-1a3b7903d26d
sprint_title: Shaping friction found by Sprint 655
---

Problem: shaping checks run contained (yoke/pkg/shape/contain: PATH /usr/bin:/bin, HOME in the clone, no bashy home), so a check cannot call registered commands such as 'bashy command-check'. Sprint 655 had to copy the checker into the app (tools/command-check.bsh) and call it through $BASH (yoke/examples/command-check/hello-world-candidate). Every copy drifts from the contract.
Behavior: an app opts into the contract check with one line in checks/, e.g. 'bashy command-check -- "$BASH" --bashsharp bin/hello.bsh', without carrying a copy. Smallest change that keeps containment: make the checker available read-only inside contained checks (for example ship it with bashy as an optional command, or expose its fixed path through the runner's explicit env), never by opening the bashy home or PATH wholesale. Effects of the check stay within the app's cap (the checker only reads and executes).
Depends on: none. Origin: Sprint 655 S1 (yoke dab16d1e).
Verification: the Hello World candidate verifies with a one-line check and no tools/ copy, under the unchanged read cap; the non-conforming variant is still refused on C5/C6; existing shaping tests green.
