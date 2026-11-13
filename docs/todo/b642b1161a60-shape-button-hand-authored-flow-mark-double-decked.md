---
id: b642b1161a60
kind: enhancement
title: 'Shape button: hand-authored Flow mark (double-decked S) in genie and the Shape page'
seq: 257
status: assigned
priority: p1
labels:
    - app
    - web
    - software-shaping
created: 2026-11-13T20:51:42.611929Z
assignee: claude-fable5.1-s636
sprint: 636
sprint_id: 3a22a674-3f50-586e-914a-4be22f7e6de5
sprint_title: 'bashy apps UI: landing section order + Flow mark on the Shape button'
---

State 2026-11-13: yoke commit ec5bebe4 (2026-11-09) already replaced the genie sparkle with a polyline TRACED from bashy docs/software-shaping-design/monochrome PNGs; it is in bashy's yoke pin and in the installed dev-box binary. The design archive has PNG masters only, no SVG. Do: hand-author one Flow SVG master on the 24 grid (two separate broad flattened S curves in a diagonal stack; keep their separation, silhouette and orientation per the archive README), smooth cubic paths not polylines; use it as the genie top-right button mark (genie.js const sparkle, 18px, fill currentColor so it follows light/dark) and in shape.html where the mark appears; commit the SVG as bashy docs/software-shaping-design/flow.svg and update SHA256SUMS. Verify side by side with monochrome/flow-256.png at 256px and at 18px in both themes; genie DOM tests still pass (genie_draft_dom_test, genie_review_dom_test). Then pin bump yoke in bashy and the umbrella. If the operator meant a different newer asset than the Flow mark, attach it to this story first.

Treatment (operator, 2026-11-13): same as the old sparkle. The mark is a flat glyph filled with the button's text color (currentColor): near-black on the white button in the light theme, white on the dark button in the dark theme. No violet tile or background behind it on the button. Comparison page shown to the operator: https://claude.ai/artifact/WdRRekMDDiEGPkryQwD5Kc
