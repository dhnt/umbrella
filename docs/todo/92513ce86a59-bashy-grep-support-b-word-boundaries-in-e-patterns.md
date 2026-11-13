---
id: 92513ce86a59
kind: task
title: 'bashy grep: support \b word boundaries in -E patterns (currently errors: ''word-boundary escape \b is not supported by the locale byte substrate'')'
seq: 226
status: todo
created: 2026-11-13T14:30:09.590275Z
---

Found 2026-11-13 (Sprint 631): GNU and BSD grep accept \b in -E patterns. Scripts written for system grep, such as umbrella script/no-phone-home.sh, broke under bashy's grep (exit 2). That script now pins /usr/bin/grep (umbrella a9dd1aa7). As a Bash 5.3 drop-in userland, bashy grep should support \b and \< \> to match GNU behavior.
