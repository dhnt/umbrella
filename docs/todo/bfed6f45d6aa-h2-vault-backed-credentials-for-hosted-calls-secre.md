---
id: bfed6f45d6aa
kind: feature
title: 'H2 vault-backed credentials for hosted calls: secret exec per call, Google credentials file projected into scratch, auth-export --to-vault'
seq: 664
status: todo
priority: p1
labels:
    - bashy-hosting
    - secrets
created: 2026-11-23T13:18:04.15048Z
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
---

Planned vendor: codex. yoke/pkg/secrets + bashy/examples/google, small. The hosted call runs the verb under bashy secret exec --no-cache --token <per-call secrets:read token> so the caller's vault env reaches gh, aws, gcloud; one file-typed mapping: google/<account>/credentials -> $GWS_CONFIG_ROOT/<account>/credentials.json (0600, in scratch, removed with it); bashy google auth-status reads vault presence when GWS_CONFIG_ROOT is empty; new bashy google auth-export --to-vault [account=...] pushes a locally obtained credential to the vault (secret set from file, never argv); the account list derives from vault names (google/*, github/*, aws/*); naming table added to the bashy secret doc. Accept: fake-vault test with env present during the call and gone after; the Google file lands 0600 in scratch and is gone after; auth-export --to-vault round-trips through the fake vault; a missing secret yields one error naming the vault path to set; SECRET_VIA_ARGV guard holds. Depends on H1. Spec: docs/sprint-691-master-execution-plan.md
