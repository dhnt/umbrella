---
id: 82bd765e812b
kind: feature
title: 'K2 yoke: bashy token edit and minter-from-vault authentication'
seq: 544
status: done
priority: p0
labels:
    - tokens
created: 2026-11-19T19:55:21.248671Z
assignee: claude-opus5.5-s672
sprint: 672
sprint_id: 29ae1f6b-e8b8-5520-be86-51a7c2dd4d8c
sprint_title: Token minting and CLI parity for access tokens
closed: 2026-11-19T20:16:49.181532Z
closed_by: claude-opus5.5-s672
---

bashy token edit ID [--name] [--scope] [--requests-per-day] [--route-policy]; create/list/revoke/edit accept --token-secret NAME (vault) so an owner minter token stored in the vault authenticates without printing it. Unit tests; pin into bashy.
