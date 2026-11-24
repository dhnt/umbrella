---
id: 9482e3dad022
kind: feature
title: 'S10 core seam (small, separate commit): external recipe admission in yoke/cmds/lens (recipes.json scheme -> argv, ParseLocatorWithSchemes); oci/k8s unchanged'
seq: 299
status: wontfix
priority: p2
labels:
    - shaping
    - content
    - trove
created: 2026-11-14T23:25:53.757357Z
sprint: 639
sprint_id: 59409a5a-4d63-513c-af53-8f97cf8be185
sprint_title: 'Trove: shaped content space — one tree for agents and humans, presented on the fly'
closed: 2026-11-24T18:21:19.884457Z
---

Planned vendor: codex. CORE, small, separate commit, optional lane (operator decision 2026-11-14: included, conductor may defer). yoke/pkg/lens/provider/recipe.go RegisterRecipe admits only oci and k8s and a Recipe is an in-process callback; add $BASHY_HOME/lens/recipes.json (scheme -> argv that prints bashy-node-v1 / bashy-edge-v1 JSONL, read-only) loaded by yoke/cmds/lens through ref.ParseLocatorWithSchemes(extra). Accept: bashy lens -t listing trove:local/ and bashy tree work through the recipe; oci/k8s unchanged; unregistered scheme still exit 3; go test ./pkg/lens/... ./cmds/lens/... green; yoke pin bump in bashy only if this lands. Spec: docs/sprint-639-master-execution-plan.md; design: docs/trove-content-app-design.md

## Closed won't do 2026-11-24

Operator decision 2026-11-24: closed won't do. The account tier (accounts without an outpost) is served by Sprint 691 H6/H6b, the trove as the virtual drive. Retired, not delivered.
