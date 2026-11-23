---
id: 3fa6721bb6c6
kind: feature
title: 'S0 Content module dhnt/site: home and About content with declared section ids, one renderer for HTML/Markdown/JSON with revision, stdlib server, shaped.json + checks'
seq: 641
status: todo
priority: p1
created: 2026-11-23T03:16:09.231565Z
sprint: 693
---

New public Go module (proposed github.com/dhnt/site; operator decision 1). Content: Markdown source per page (home, about) with front matter title/path and declared section ids (never derived from headings). Renderer: HTML fragment, Markdown (front matter path/revision/alternates, nav as labeled links, {#id} headings), JSON {path,title,revision,nav,sections[{id,heading,html,markdown,sha256}]}; revision = short SHA-256 of the canonical content document (copy change changes it, rendering change does not). Stdlib server: / and /about with negotiation (Accept text/markdown|application/json|else HTML), twins /index.md /index.json /about.md /about.json, Vary: Accept, strong ETag = revision, Link rel=alternate for both twins, <link rel=canonical>, <meta name=revision>, /robots.txt, /llms.txt. Shaped-app face: shaped.json, contract.bsh, checks/ (render determinism: same content renders byte-identical twice; unique ids; internal links resolve; stale-base: a wish --element revision must equal the base page revision). Acceptance: go test ./... green on the gate host; bashy shape verify passes in the verifier's scrubbed environment; the three representations of /about list the same links and section ids. No dependency on the hosted plane. Plan: docs/sprint-693-master-execution-plan.md.
