---
id: ab59d1e0ecff
kind: bug
title: 'desk-kit/render: fix 256 KiB readAsset truncation corrupting base64-inlined PDF/HTML assets'
seq: 35
status: done
priority: p0
labels:
    - desk
    - pdf
created: 2026-11-07T22:23:26.065859Z
assignee: agy-gemini3.8-flash
sprint: 589
sprint_id: 154c840a-9158-552f-9a27-d6e500d339cb
sprint_title: Competition media & Desk tools — PDF and video production fixes
closed: 2026-11-08T00:00:38.635466Z
closed_by: agy-gemini3.8-flash
---

In bashy/examples/desk/kit/render/embeds.go, readAsset wraps asset files in io.LimitReader(f, 256<<10) while inlineURI checks len(raw) > 1<<20. Any PNG/JPEG asset between 256 KiB and 1 MiB is silently truncated at 256 KiB when base64-inlined into exported HTML and PDFs. Raise the read limit for inline assets to 1 MiB + 1 byte so inlineURI's size check works and oversize assets degrade cleanly instead of corrupting images. Add a unit test in render_test.go and viewer_test.go with a >256 KiB PNG asset.
