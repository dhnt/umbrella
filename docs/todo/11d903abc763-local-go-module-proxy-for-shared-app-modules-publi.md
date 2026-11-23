---
id: 11d903abc763
kind: feature
title: 'Local Go module proxy for shared app modules: publish desk-kit/desk-chart as versioned modules, apps require them without replace directives, shaped builds set GOPROXY'
seq: 683
status: todo
priority: p1
labels:
    - shaping
    - gomod
created: 2026-11-23T20:11:40.028144Z
---

Operator direction 2026-11-23 (see bug d35e0de8): every app builds independently of any other app or sibling directory; no copying of sibling modules, no vendoring, no build-time path rewrites. Deliver: (1) bashy mod proxy: a local Go module proxy (GOPROXY protocol: @v/list, .info, .mod, .zip) that bashy runs on the host, with a publish verb that cuts a version (tag or pseudo-version) of a module directory from the checkout; (2) desk-kit and desk-chart published; the eight consumers (calendar, desk/form, desk/chart, desk/page, desk/viewer, desk/notepad, brainstorm/server, session) switch from replace to require vX.Y.Z with go.sum entries; module paths renamed to proper paths if go or the proxy requires it; (3) webconsole shaped builds and verifier candidate builds set GOPROXY=<local>,direct plus GONOSUMDB/GOPRIVATE for those paths; (4) bashy app add --type shaped fails loudly, with the fix, when go.mod has a relative replace escaping the source dir; (5) test: register an app and build it from the extracted tree with no siblings present. Related: yoke story 61c28d52cf73 (S516.4 S3-layer GOPROXY cache). Unblocks Sprint 682 C4. Scope decision (which sprint; who) is the operator's; filed unowned.
