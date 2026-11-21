---
id: 1e3c44f8169c
kind: refactor
title: 'S3: Replace k8s.io/client-go in internal/agentos/dks_scope.go with lightweight YAML + REST (-20 MB, -247 pkgs)'
seq: 553
status: wontfix
priority: p2
labels:
    - bashy
    - size
created: 2026-11-20T10:01:53.550083Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
closed: 2026-11-21T09:22:53.650333Z
---

SUPERSEDED by plan v3 (operator forms form-f1bc68d375d5/form-00159a6e1f7e, 2026-11-21): dropped as a library rewrite - the k8s weight leaves the core with its command when dks converts in P4b (52a3c08d). Closed wontfix as superseded; reopen only if a converted dks binary still needs the rewrite.
