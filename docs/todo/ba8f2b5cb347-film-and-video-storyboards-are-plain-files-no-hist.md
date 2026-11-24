---
id: ba8f2b5cb347
kind: feature
title: 'film and video storyboards are plain files: no history, undo or group edit'
seq: 692
status: todo
priority: p2
labels:
    - group-shaping
created: 2026-11-24T11:57:47.14259Z
---

Found by the group-shaping coverage matrix (docs/group-shaping-coverage-matrix.md). Evidence: film storyboard is PROJECT/storyboard.json, schema bashy-film-storyboard-v1 (bashy/examples/film/film.bsh:110, init :272-283), validated by check_storyboard (:238-258). film lock (cmd_lock film.bsh:975-1030) is the existing named-revision analog: freezes a successful draft into lock/ with lock.json (bashy-film-lock-v1, per-file sha256 :1019-1022), refuses if the storyboard changed since the draft (:994-995), verify_lock (:1037-1045) gates final (:555); it is a single slot replaced by rm -rf and mv (:1025-1026), no history. video storyboard is PROJECT/storyboard.txt, one segment per line (bashy/examples/video/video.sh:410,434); README.md:8 says it is an example, not a bashy command; no shaped.json or register.sh for either. Neither has an access check, guest door or a CLI verb for revisions. Gap: adopt the kit RevisionStore (desk/kit/revision.go:137) with lock as a named pointer, plus a way for group members to edit. Not small. Existing story dc493ef9 covers co-edit and render.
