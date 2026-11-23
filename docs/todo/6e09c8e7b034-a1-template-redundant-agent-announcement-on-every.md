---
id: 6e09c8e7b034
kind: feature
title: 'A1 Template: redundant agent announcement on every classic channel (/agents.txt first implementation, Bashy-Shaped header, hidden Bash# recipe + visible block, link relations, well-known files, robots/sitemap/feed/noscript/JSON-LD), Markdown-first, tie-break; regenerate dhnt/site'
seq: 671
status: todo
priority: p1
created: 2026-11-23T13:51:45.467246Z
sprint: 697
---

Note on the script block: keep type="text/bashsharp". Per the HTML standard a script whose type is not a JavaScript MIME type, module or importmap is a data block: never fetched, parsed or executed, kept in the DOM (the JSON-LD and client-template precedent), inert under a strict CSP. Do not change it to text/javascript with comments: a strict CSP blocks and logs inline JS, the engine parses it, and '*/' or '</script>' inside the recipe would break it. The recipe must not contain the literal </script> and should be plain ASCII.
