---
id: 6164e3384b72
kind: feature
title: A4 DOM walker in Go and JS with parity test
seq: 759
status: todo
priority: p0
labels:
    - conform
created: 2026-11-25T21:18:55.784038Z
sprint: 722
sprint_id: ffc7a05d-4229-598a-8834-4c1212246274
sprint_title: 'dhnt/conform, then: does the spec reproduce the app?'
---

Port _FormInventoryParser/extract_ui_inventory/compare_ui_inventory_with_definition (grader_lib.py ~1046-1290) to package walk: Inventory(r io.Reader) (Inventory, error) using golang.org/x/net/html; fields (id, label, kind, required, options), buttons, visibility (hidden attr, type=hidden, display:none inline). Same algorithm as walk/walker.js (embedded via go:embed, exported as walk.JS) using only DOM primitives (tagName, getAttribute, children/childNodes, textContent) so it runs in a browser page. Parity test: parse testdata/*.html with x/net/html, expose the tree to goja (github.com/dop251/goja, test-only) as a minimal DOM object, run walker.js, assert deep-equal with the Go inventory. Fixtures: at least the form page served by bashy examples/desk/form (capture once), plus edge cases (label for= vs wrapping label, select/radio/checkbox groups, hidden fields). Acceptance: parity green on every fixture; unit tests green.

Source to port: agent-bench commit a6a90e23 (branch salvage/s721-p2b-wip), `git -C agent-bench show a6a90e23:packs/shapeware/grader_lib.py`. Repo: github.com/dhnt/conform (umbrella submodule conform/). Rules: conform/CLAUDE.md (stdlib + x/net/html only; no github.com/qiangli imports; GOWORK=off go vet + go test green; fixtures under testdata/). Commit trailers Sprint: 722 / Story: / Story-ID:. Keep the story under 30 minutes of work; heavy verification is the conductor's.
