---
id: a121e2a30893
kind: bug
title: S13 weave abandon --force loses unpushed submodule commits (salvage keeps only the superproject tip)
seq: 223
status: todo
priority: p1
labels:
    - weave
created: 2026-11-13T12:58:38.431044Z
---

Root cause (recorded 2026-11-13, conductor): abandoning run #45 (S9) with --force --disposition rejected preserved umbrella tip 642efc3f at refs/salvage/abandoned-45, but that tip pins bashy a558cbab, a commit that existed only in the run workspace's bashy submodule and was never pushed; removing the workspace destroyed it (not in any local object store). Classification: tool defect (weave salvage ignores submodules) + conductor process error (abandoned before fetching the submodule commit). Fix in weave: before removing a workspace, fetch every submodule HEAD that a preserved tip pins into the parent checkout's submodule repo under refs/salvage/abandoned-<id>/<submodule>, or refuse without an explicit override. Interim conductor rule: git -C <sub> fetch <workspace>/<sub> HEAD:refs/salvage/run-<id> before any abandon.
