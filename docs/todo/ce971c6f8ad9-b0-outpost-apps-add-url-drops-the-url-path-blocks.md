---
id: ce971c6f8ad9
kind: bug
title: B0 outpost apps add --url drops the URL path (blocks publish-outpost for every catalog app; vlog publish-outpost cannot work)
seq: 198
status: done
priority: p0
labels:
    - outpost
    - vlog
created: 2026-11-13T03:40:03.239538Z
weave: 60
assignee: claude-opus5.5
sprint: 632
sprint_id: f9e12c4a-7e87-566d-9d68-faafaff27757
sprint_title: 'Shaping evaluation: upgrade survival, data safety, beachhead vs baseline, scorecard'
closed: 2026-11-13T18:09:56.83808Z
closed_by: claude-fable5.1-s632
---

Root cause (S499.4 live check, 2026-11-12, rc.33 on the Windows test host via satellite zoo): examples/vlog publish-outpost runs 'outpost apps add vlog --url http://127.0.0.1:22749/vlog/'. conf.AppTargetFromURL (outpost internal/agent/conf/file.go) keeps scheme/host/port only, so the app targets the console root; through <sat>/matrix/h/HOST/app/vlog/ the console sees path '/', whose first segment is not the public 'vlog' panel (yoke webconsole gate.go panelTier), and answers 403 'authentication required'. Fails on every OS; S499 never ran the live check. Fix: outpost keeps the URL path as an upstream base path (AppConfig field + proxy director prefix) and refuses or warns on a path it cannot honor; vlog test through a fake satellite. Separate Windows bug fixed: yoke e0f7c849 (site --source MSYS path). Publish was undone (outpost apps rm vlog; app set --auth system).
