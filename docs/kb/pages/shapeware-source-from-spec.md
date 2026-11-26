---
id: 01a21794-3957-7845-9cf3-0952cc2184b7
seq: 26
form: page
type: runbook
title: 'Build an app from a shapeware spec (forward: spec to source), the builder''s guide'
description: 'WHEN you are asked to build or rebuild an app from a shapeware spec folder and it will be judged by conform at a stated venue: read the rules first, build for the venue, write files early, run conform while building, deliver source and a launcher with no host-built binaries'
tags:
    - shapeware
    - conform
    - builder
    - spec2src
status: candidate
evidence: Failure classes from Sprint 722 (15 runs) and Sprint 723 (start, step and rerun batches)
source:
    tool: claude
created: "2026-11-26T11:18:39Z"
---

Goal: build an app from a shapeware spec folder (`CONTRACT.md`, `features.yaml`, `examples/`, a task file) so that it passes the judge at the stated venue. Lessons are from the Sprint 722 and 723 drills.

## Steps
1. **Read the rules section of `CONTRACT.md` before the assertions.** Envelope keys, projection flags and open/closed outputs apply to every command.
2. **Read the task file for the venue:** OS, interpreter and toolchain versions, network, what is absent. Build for that venue, not for the machine you are on.
3. **Write files early.** Start the launcher and a first command within the first minutes, then extend. A long plan with nothing on disk can be cut off.
4. **Run the judge while you build:** `conform run CONTRACT.md --path . --fresh-home`. Fix by assertion name until all pass.
5. **Cover every example file and every input format** in `examples/`, including each syntax the examples use.
6. **Errors:** exactly the stated stream, text prefix and exit code. Nothing else on that stream.
7. **UI:** follow the stated label, required and control rules; the judge reads the accessible inventory, not your markup.
8. **Deliver source plus the launcher.** Before you finish:
   - remove build outputs and caches from the workspace, or make the launcher rebuild when the cached binary does not run;
   - make sure the launcher works from a fresh HOME with no network;
   - use only the standard library or dependencies vendored in the workspace.

## Failure causes seen
- A binary built on the session host shipped in the workspace and could not execute at the venue.
- A module that is deprecated in the venue's interpreter version printed a warning on the error stream and failed every error assertion.
- An input format named in the spec was not implemented because only the other format had been tried.
- A projection flag was honoured on some commands only, or dropped the always-present key.
- Nothing was delivered: the session ended during a long first planning turn.
