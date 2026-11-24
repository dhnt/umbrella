---
id: 01a20fea-ee67-7ef8-8d1f-91cea6a8ef7d
seq: 23
form: page
type: lesson
title: 'Conducting a sprint with weave workers: merge mechanics that bite'
description: 'WHEN conducting a bashy sprint with weave workers across umbrella submodules: fetch the shared submodules (git -C yoke|bashy|outpost fetch origin) before ''sprint assign'', or workspace hydration fails with ''not our ref''; prefer a fresh run over ''weave start --resume'', which can spin at 100% CPU without spawning (703 bug 5771d343); workers often stop before submitting, so review the diff, rebase, run a targeted test, push, then ''weave abandon N --disposition superseded --reason integrated:<sha> --yes'' and ''sprint submit'' + ''accept''; review every worker diff, because 706 R10 shipped a served site that followed ANY principal''s activation; pass BASHY_SPRINT_LEASE_TOKEN to every verb, since a dry run without it is logged as a scorecard bypass; bump umbrella pins from a separate worktree with git update-index --cacheinfo and pathspec commits.'
status: candidate
source:
    tool: claude
created: "2026-11-24T23:36:24Z"
---
