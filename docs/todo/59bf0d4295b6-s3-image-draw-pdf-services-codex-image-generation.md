---
id: 59bf0d4295b6
kind: feature
title: 'S3 image/draw/pdf services: codex image generation, claude/agy draw (SVG) and pdf read'
seq: 176
status: done
priority: p1
labels:
    - vendor-services
created: 2026-11-12T23:18:14.354808Z
weave: 20
assignee: codex-gpt6-sol
sprint: 626
sprint_id: bc2891ba-d9b3-52b0-9209-082fee4e38d2
sprint_title: 'Vendor services: one generic service door (bashy search/image/plan/...) over vendor CLIs, OSS, browser and API providers'
closed: 2026-11-13T01:24:15.933591Z
closed_by: claude-opus5.5-s626
---

Spec: docs/sprint-626-master-execution-plan.md. Depends F,S0. Measure codex image generation headless (output under CODEX_HOME generated_images; fix toolcmd output glob only if needed); claude:draw and claude/agy:pdf print with file outputs. Draw/pdf lane: claude-opus5.5. Verify: artifact files exist and envelope lists them.

Conductor constraints (2026-11-12): codex-gpt6-sol measures all three (claude is on S5). (1) Measure on the wire WITHOUT --dangerously-skip-permissions or any yolo/bypass flag (uncontained-host guard refuses them); use exec: overrides or read-only sandboxes like claude:plan, agy:plan, search-codex (-s read-only), search-muse (--disable-write). An image generation writes a file: confine the write to the requested -o path / workspace and say how. (2) Seed only what is measured; for each vendor that cannot do it headlessly, record command, exit and output instead of seeding. (3) Image generation that spends paid credits declares the spend effect so --yes gates it. (4) Base on yoke origin/main and bashy origin/main; verify bashy image/draw/pdf --provider X --json on a fixture; commit with Sprint/Story/Story-ID and Agent: codex-gpt6-sol trailers; do not push.
