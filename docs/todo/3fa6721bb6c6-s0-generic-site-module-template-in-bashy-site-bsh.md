---
id: 3fa6721bb6c6
kind: feature
title: 'S0 Generic site module template in bashy: site.bsh skill-script + Go renderer/server for HTML, Markdown and JSON under one revision, shaped-app face'
seq: 641
status: todo
priority: p1
created: 2026-11-23T03:16:09.231565Z
sprint: 693
---

The pattern is generic: every site owner gets a public or private <owner>/site repository generated from one bashy template (operator 2026-11-22: 'each site will also have <other-website>/site'); dhnt/site is only the first instance (S0b). Lives in bashy next to examples/shaping/website (which already scaffolds a companion layer for an existing static site): examples/shaping/site/site.bsh with an embedded skill and a template/ directory. Verbs: init DIR --title --origin (writes content/*.md, site.json, the stdlib Go server, shaped.json, contract.bsh, checks/), render DIR [--format html|md|json] PATH, serve DIR, check DIR (all --dry-run, --json). Renderer contract: content Markdown per page with front matter title/path and declared section ids (never derived from headings); HTML fragment with <section id>, Markdown with front matter path/revision/alternates, nav as labeled links and {#id} headings; JSON {path,title,revision,nav,sections[{id,heading,html,markdown,sha256}]}; revision = short SHA-256 of the canonical content document (copy change changes it, rendering change does not). Server: HTML by default, Accept text/markdown -> Markdown, application/json -> JSON; twins PATH.md and PATH.json (index.md/index.json for /); Vary: Accept; strong ETag = revision; Link rel=alternate for both twins; <link rel=canonical>, <meta name=revision>; /robots.txt; /llms.txt listing the pages. Checks frozen from the base: render determinism (byte-identical twice), unique ids, internal links resolve, stale-base (a wish --element 'section=ID revision=REV' must match the base page revision, else 'stale, re-read'). Acceptance: bashy script tests + GOWORK=off go test in the template on the gate host; init on a sample produces a repo whose bashy shape verify passes in the verifier's scrubbed environment; the three representations list the same links and section ids. No hosted-plane code; no engine change. Plan: docs/sprint-693-master-execution-plan.md.
