---
id: 7aedcd5bed36
kind: enhancement
title: 'form: no reopen after close and results_visible cannot be unset (page poll/form blocks gate both page-side)'
seq: 663
status: todo
priority: p2
labels:
    - page
    - form
created: 2026-11-23T13:16:18.90656Z
---

Found by Sprint 696 story #654 (8677f12abd00, poll/form native blocks). Evidence, bashy examples/desk/form/server/main.go at bashy 5b423767: mutate() refuses any change once it.closed() ('This form is closed', 409), so a closed form cannot be reopened; and set only ever turns ResultsVisible on (if req.ResultsVisible { next.ResultsVisible = true }), so results cannot be hidden again. The page needs facilitator open/close/show/hide on a live poll, so in Sprint 696 the page keeps both as page-side gates (block_form.go nativeBlock.Open/ResultsVisible) and never calls form close. Gap: a participant who reaches the form URL directly (loopback only today) is not subject to the page's close; the page does not count such responses. Proposed fix in form (not in Sprint 696 scope per its rule 2): an explicit reopen action and results_visible false on set, each owner-keyed and logged; then the page adapter can mirror its gates into form.
