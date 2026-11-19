---
id: adecf6b4e577
kind: task
title: K3 bootstrap the owner minter; re-mint the dev box session token via CLI; revoke the 2036 token
seq: 545
status: assigned
priority: p0
labels:
    - tokens
created: 2026-11-19T19:55:21.414278Z
assignee: claude-opus5.5-s672
sprint: 672
sprint_id: 29ae1f6b-e8b8-5520-be86-51a7c2dd4d8c
sprint_title: Token minting and CLI parity for access tokens
---

Create the owner minter once in the console (bashy browser; a cookie session is the only parent that can grant the first all-scope token), value straight to the vault. Then from the CLI: mint the dev box session token with tasks/sprints scopes and a <=365d TTL into the vault, keep the secrets.map binding, verify session sync, revoke the console-made 2036 session token.
