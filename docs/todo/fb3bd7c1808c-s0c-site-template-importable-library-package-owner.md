---
id: fb3bd7c1808c
kind: feature
title: 'S0c site template: importable library package + owner module path + optional summary (so the hosted plane can import <owner>/site)'
seq: 646
status: done
priority: p1
created: 2026-11-23T04:59:07.958936Z
weave: 163
assignee: agy-gemini4-carbon
sprint: 693
closed: 2026-11-23T05:25:57.267675Z
closed_by: claude-fable5.1
---

Follow-up to S0 (3fa6721bb6c6, merged as bashy 6226a196). Gap found in review: template/ is one 'package main' with 'module site', so github.com/dhnt/site generated from it cannot be imported by the hosted plane (plan: 'the hosted plane imports the module at a pinned version'). Deliver in bashy examples/shaping/site: (1) split the renderer into an importable library: the module ROOT is package 'site' (types Page/Section/NavItem, Load(dir) / LoadFS, Render HTML fragment / Markdown / JSON, TwinPaths, revision and section hashing, negotiation helper, and an http.Handler constructor for the public routes), and the binary moves to cmd/server/main.go (server + check verbs; shaped.json server.main points there; contract.bsh/checks unchanged); (2) 'site init' writes go.mod with the owner's module path: new flag --module PATH (default github.com/<owner>/site when --owner is given; required otherwise) and rewrites the internal imports accordingly; the template's own go.mod stays 'module site' for the example tests; (3) front matter accepts an optional 'summary:' line (one lead paragraph) exposed as Page.Summary ('summary' in JSON, a paragraph under the title in HTML and Markdown, part of the canonical content so it changes the revision); unknown keys stay rejected or ignored exactly as today, document which; (4) update the embedded skill, README, site_test.go and template tests; keep every existing verb, flag and output identical. Acceptance: script tests + GOWORK=off go test ./... in template/ green on the gate host; 'site init /tmp/x --title T --origin https://example.test --owner acme' yields a module 'github.com/acme/site' whose root package builds with 'go build ./...' and whose cmd/server runs the same routes as before; a tiny external module importing github.com/acme/site via a replace directive compiles (prove in a test); bashy shape verify passes on the generated repo in the scrubbed environment. WORKER RULES: work only under bashy/examples/shaping/site/ (branch off bashy origin/main 6226a196 or later); template tests only, no full bashy build on this host; trailers Sprint: #693 / Sprint-ID: cdef0a9b-7ae4-54d0-bd26-139ef3609d4a / Story: #<seq> / Story-ID: <id> / Agent: agy-gemini4-carbon; do not bump umbrella pins; on completion bashy sprint submit 693 <id> --as agy-gemini4-carbon -m '<verify commands and results, commit SHA>'. Plan: docs/sprint-693-master-execution-plan.md.
