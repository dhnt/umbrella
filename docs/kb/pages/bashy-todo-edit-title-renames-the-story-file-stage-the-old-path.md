---
id: 01a1fb6a-1ed9-7cc1-80a6-b2191d991688
seq: 19
form: page
type: gotcha
title: 'bashy todo edit --title renames the story file: stage the old path''s deletion too'
description: 'WHEN committing docs/todo stories after retitling one with bashy todo edit --title: the slug is derived from the title, so the file is renamed on disk; git add docs/todo/<id>-*.md picks up only the new path and leaves the old path as an unstaged deletion, so the commit tracks two files for one story. Stage with git add -A docs/todo/<id>-* (or git rm --cached the old path) and check git ls-files docs/todo | grep <id> shows exactly one path before pushing. Learned 2026-11-20 on the group shaping epic (umbrella 1e364971).'
status: candidate
source:
    tool: claude
created: "2026-11-21T00:03:18Z"
---
