---
id: 1e3c44f8169c
kind: refactor
title: 'S3: Replace k8s.io/client-go in internal/agentos/dks_scope.go with lightweight YAML + REST (-20 MB, -247 pkgs)'
seq: 553
status: todo
priority: p1
labels:
    - bashy
    - size
created: 2026-11-20T10:01:53.550083Z
sprint: 677
sprint_id: 334e4662-d75c-5c5f-8671-7b62ea882de1
sprint_title: Fast build, small core binary, and shapeable Yoke CLI modularization
---

Repo: bashy. internal/agentos/dks_scope.go is the only file in bashy importing k8s.io/client-go, k8s.io/api, k8s.io/apimachinery, and gnostic-models (247 transitive packages, ~18-22 MB of code, reflection types, and pclntab). Replace kubeconfig load/save with gopkg.in/yaml.v3 and implement namespace list + SelfSubjectAccessReview with net/http + crypto/tls. Remove k8s.io/* from bashy/go.mod. Acceptance: dks_scope_test.go passes; zero k8s.io/* packages in go list -deps ./cmd/bashy; binary shrinks by ~18-22 MB. Spec: docs/plan-sprint-677-fast-build-small-binary-shaping.md
