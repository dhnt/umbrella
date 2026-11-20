---
id: adecf6b4e577
kind: task
title: K3 bootstrap the owner minter; re-mint the dev box session token via CLI; revoke the 2036 token
seq: 545
status: todo
priority: p0
labels:
    - tokens
created: 2026-11-19T19:55:21.414278Z
assignee: claude-opus5.5-s672
---

Create the owner minter once in the console (bashy browser; a cookie session is the only parent that can grant the first all-scope token), value straight to the vault. Then from the CLI: mint the dev box session token with tasks/sprints scopes and a <=365d TTL into the vault, keep the secrets.map binding, verify session sync, revoke the console-made 2036 session token.

## Carry-over (2026-11-19, Sprint 672 ended)

Blocked on the cloudbox release that carries tokens.scopes varchar(2000) (dev b84710c, SchemaRevision 32) and the bearer edit endpoint (dev 67276df); production v0.18.78 still has varchar(512), so a minter holding all 45 delegable scopes (608 chars) cannot be saved. A release needs the operator's go-ahead; candidate = origin/dev 8367640 (v0.18.78 + six commits). Before release: run the release e2e gate and TestPostgresMigrateWidensTokenScopes (CLOUDBOX_TEST_PG_DSN) on the Linux test host.

After release:
1. Console (bashy browser): New token `owner-minter`, every scope except host:proxy:admin, Generate, pipe the value straight into vault secret `cloudbox-owner-minter`, Save; confirm with `bashy token list`.
2. Bind it: add `CLOUDBOX_MINTER_TOKEN=@cloudbox-owner-minter` to ~/.config/bashy/secrets.map.
3. CLI: `bashy token create --name session-<host> --scope tasks:read,tasks:write,sprints:read,sprints:write --ttl 365d --to-secret cloudbox-session-<host>` (overwrites the vault value the binding CLOUDBOX_TOKEN already points at); verify `bashy sprint session status`; then `bashy token revoke <id of the console-made 2036 session token>`.
4. Exercise `bashy token edit` once against production.

Carried over (2026-11-20): Sprint 673 closed with M1 (cloudbox v0.18.79) and the header change (v0.18.80) delivered; K3 needs the operator at the browser (owner minter bootstrap via the console session + vault). Unlinked to the backlog; pick it up in a later operator-attended sprint. Prerequisites live: bearer PUT /api/v1/tokens/:id and tokens.scopes varchar(2000) since v0.18.79.
