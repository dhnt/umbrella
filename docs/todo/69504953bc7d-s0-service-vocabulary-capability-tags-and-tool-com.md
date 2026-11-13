---
id: 69504953bc7d
kind: doc
title: S0 Service vocabulary, capability tags and tool-commands design catalog
seq: 173
status: done
priority: p1
labels:
    - vendor-services
created: 2026-11-12T23:18:13.910281Z
weave: 8
assignee: claude-opus5.5
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
closed: 2026-11-12T23:36:38.788077Z
resolution: fixed
closed_by: claude-opus5.5-h
---

Spec: docs/sprint-626-master-execution-plan.md. Depends F. Add search, image, draw, pdf, video, film, transcribe, narrate, song, animate, email, drive to fleet.CanonicalToolCommands (yoke/pkg/fleet/toolcommand.go) and capability tags/aliases (yoke/pkg/capability); add a service catalog section to the tool-commands design doc. Verify: TestBaselineToolCommandsValidate and capability tests.
