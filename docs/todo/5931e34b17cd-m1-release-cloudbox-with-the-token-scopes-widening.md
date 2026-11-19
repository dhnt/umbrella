---
id: 5931e34b17cd
kind: task
title: M1 Release cloudbox with the token scopes widening and the bearer edit endpoint
seq: 547
status: todo
priority: p0
labels:
    - tokens
    - release
created: 2026-11-19T20:45:29.420932Z
sprint: 673
sprint_id: 805fd7b6-ff67-5e09-a28c-f28ee49c74d3
sprint_title: Owner minter bootstrap and session token re-mint
---

Candidate: cloudbox origin/dev 8367640 = v0.18.78 + 67276df (bearer PUT /api/v1/tokens/:id), b84710c (tokens.scopes varchar(2000), SchemaRevision 32), 342b285 (embedded UI: token dialog reports a failed save), plus docs and an e2e-script fix. Needs the operator's go-ahead. Gates on the Linux test host before release: the release e2e gate and TestPostgresMigrateWidensTokenScopes with CLOUDBOX_TEST_PG_DSN. Follow the internal release playbook; the cloudbox migrate step widens the column. Accept: version live, schema_version 32, PUT /api/v1/tokens/:id answers.
