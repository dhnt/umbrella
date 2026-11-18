---
id: ac5024b9f791
kind: refactor
title: Move unchanged full Bash command entry point into Bash repository
seq: 456
status: done
created: 2026-11-18T04:50:16.505408Z
assignee: s575-codex-manager
sprint: 575
sprint_id: 65ce85f5-87c0-5863-bf55-62de86f5df36
sprint_title: 'Layer separation: Classic <- Bash# <- Yoke import-graph delineation'
closed: 2026-11-18T06:47:19.576352Z
closed_by: s575-codex-manager
---

Operator explicitly requested moving bashy/cmd/bash into bash/cmd/bash. Preserve both Go files unchanged. Add only fixed shared CLI module reference and build target references. No engine implementation edits. Add standalone DAG/container build and test workflow using existing locked image/harness.
