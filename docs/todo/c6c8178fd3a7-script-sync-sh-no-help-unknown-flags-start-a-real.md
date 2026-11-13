---
id: c6c8178fd3a7
kind: bug
title: 'script/sync.sh: no --help, unknown flags start a real (pushing) sync; add a read-only drift check'
seq: 206
status: done
priority: p1
labels:
    - sync
    - pins
    - safety
created: 2026-11-13T11:00:02.268503Z
closed: 2026-11-13T11:21:57.28492Z
---

Observed 2026-11-13: an agent ran `script/sync.sh --help` expecting usage; the script ignores arguments and began the full sync (fast-forward every submodule, rewrite .sibling-pins and COMMIT+PUSH inside consumers, stage gitlinks). It was cut off only because its stdout pipe closed (head -3); verified afterwards that nothing changed. Separately, repos repeatedly drifted out of sync during Sprints 626/627 (pins lagging pushed fixes, a submodule checkout BEHIND its pin that would have rolled the pin back if committed, story files and todos left uncommitted/unpushed), causing builds without delivered fixes and phantom-issue rework.
Fix (umbrella, separate small repair; default no-argument sync behaviour unchanged per the migration preservation policy): -h/--help prints usage; any unknown argument is refused with exit 2 and 'nothing was changed'; new --check is a READ-ONLY drift report (fetch only): per submodule pin vs origin default branch, checkout vs pin (flags 'BEHIND the pin — do not commit this gitlink'), unpushed commits, uncommitted tracked changes; umbrella unpushed commits and uncommitted tracked files; exit 0 in sync / 1 drift.
Verify: --bogus exits 2 with no change; --help exits 0; --check leaves every submodule HEAD and porcelain status byte-identical (hash before/after) and reports drift correctly.

## Delivery evidence (2026-11-13)

- script/sync.sh: `-h/--help` prints usage (exit 0); any unknown argument
  is refused with "nothing was changed" (exit 2); `--check` is a read-only
  drift report (fetch only), exit 0 in sync / 1 drift. Default no-argument
  sync unchanged (migration preservation policy).
- Verified: `--bogus` exit 2 with no change; `--check` left every submodule
  HEAD and porcelain status byte-identical (hash before/after) and flagged
  exactly the one uncommitted file at the time; umbrella CI shell-syntax,
  gitlink and scrub checks pass.
- Guideline: bashy 03b7fe3b (conductor skill + `sprint --help`: drift
  check on every checkpoint and before stop/end, forward-only pins,
  steward sweep). Generic verb follow-up: bashy todo f7be1028.
