---
id: 01a22163-4220-71a9-897b-bb4f4c558ecb
seq: 32
form: page
type: lesson
title: A bashy adapter verb gets only the hooks of the packages it links
description: 'WHEN you add or extend a yoke verb that bashy runs as an adapter (bashy/yoke/<verb>/main.go), or a feature whose package wires itself into another package in init(): the adapter process links only what its main.go imports, so an init-registered hook (e.g. pkg/offer setting broker''s offer runner and sharedfiles'' share hooks) is silently absent there although the in-process bashy route has it. Blank-import the wiring package in each adapter that needs it, and cover it with a gate that runs the real adapter (Sprint 739: door 503 ''offer runner unavailable'', folder share registered no app). Sealed-image e2e gates also need those adapters prebuilt into the adapter cache, since the image has no source tree.'
status: candidate
source:
    tool: claude-opus5.5
created: "2026-11-28T09:01:22Z"
---
