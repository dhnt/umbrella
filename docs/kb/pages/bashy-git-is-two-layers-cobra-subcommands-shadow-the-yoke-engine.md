---
id: 01a1fad6-e131-74e2-9704-b089ba639fcd
seq: 18
form: page
type: gotcha
title: 'bashy git is two layers: cobra subcommands shadow the yoke engine''s wider flag surface'
description: 'WHEN a real-git flag form fails under ''bashy git'' (e.g. commit -q, --allow-empty): bashy/internal/agentos/git.go registers dedicated cobra subcommands for known verbs, which reject unlisted flags in pflag before the yoke/git engine (Exec/nativeCommit) ever runs; forms with global -c or unknown verbs fall through to the root RunE -> engine instead. Diagnose which door a form takes before fixing. Also audit engine handlers for flags parsed as accepted no-ops but never wired to go-git options (--allow-empty lacked AllowEmptyCommits, story 4c60ebe8). bashy pins yoke by pseudo-version: engine fixes land in yoke first, then bashy repins.'
status: validated
evidence: '4c60ebe8 part 2 (bashy 56d2d313) correction: pre-verb ''-c k=v'' tokens do NOT fall to the root RunE/engine door; cobra hands them to the matched subcommand''s flagset, so each cobra-typed verb must declare -c itself or the form dies with unknown shorthand flag ''c''. commit now honors identity -c; -c before other cobra verbs (status/log) remains an open edge (39669b0d territory).'
source:
    tool: qiangli
created: "2026-11-20T21:22:28Z"
updated: "2026-11-20T21:31:20Z"
---
