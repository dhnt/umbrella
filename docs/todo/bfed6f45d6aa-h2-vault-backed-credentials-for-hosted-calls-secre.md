---
id: bfed6f45d6aa
kind: feature
title: 'H2 vault-backed credentials for hosted calls: secret exec per call, Google credentials file projected into scratch, auth-export --to-vault'
seq: 664
status: done
priority: p1
labels:
    - bashy-hosting
    - secrets
created: 2026-11-23T13:18:04.15048Z
assignee: codex-gpt6.2-sol
sprint: 691
sprint_id: 2c1803fe-634b-51fb-818c-9ac8e2a5428c
sprint_title: Hosted bashy and the trove virtual drive for cloudbox users without a live outpost
closed: 2026-11-24T14:36:20.956677Z
closed_by: claude-opus5.5
---

Review 2026-11-24 (conductor, after 1306704e1): the yoke projection (529c5d3b) is accepted as is. Rework: (1) auth-status default must stay local (spec corrected above; the earlier wording caused a regression for local users), vault presence only with --vault, plus a regression test for the default-root path; (2) a test wrote google/alice@example.com/credentials to the operator's real vault (deleted by the conductor): add the fail-closed hermetic guard; (3) the 2 auth-import NameError failures already fail on main (bashy todo 06938b9a), out of scope; (4) the per-call wiring still waits for H1.

Staffing 2026-11-24: codex, started in parallel with H1: pkg/secrets file-typed mapping, google auth-status from vault presence, auth-export --to-vault, fake-vault tests. The wiring into the H1 per-call scratch lands after H1 merges, rebased onto it. Start from current heads.

Planned vendor: codex. yoke/pkg/secrets + bashy/examples/google, small. The hosted call runs the verb under bashy secret exec --no-cache --token <per-call secrets:read token> so the caller's vault env reaches gh, aws, gcloud; one file-typed mapping: google/<account>/credentials -> $GWS_CONFIG_ROOT/<account>/credentials.json (0600, in scratch, removed with it); bashy google auth-status --vault reports vault presence (default auth-status keeps checking the local default root ~/.config/bashy/google unchanged: local and outpost users must see no change); new bashy google auth-export --to-vault [account=...] pushes a locally obtained credential to the vault (secret set from file, never argv); the account list derives from vault names (google/*, github/*, aws/*); naming table added to the bashy secret doc. Accept: fake-vault test with env present during the call and gone after; the Google file lands 0600 in scratch and is gone after; auth-export --to-vault round-trips through the fake vault; a missing secret yields one error naming the vault path to set; SECRET_VIA_ARGV guard holds; tests are hermetic: the secrets client points at the loopback fake and fails closed if the default vault endpoint is reachable. Depends on H1. Spec: docs/sprint-691-master-execution-plan.md

Merged 2026-11-24 by the conductor after review of the rework: yoke d069a0f5 (from 529c5d3b + 6cb88979), bashy 884901c4 + 9c79957d (from e7f7e1a2 + 83616ae9) + d69d9e95 (yoke pin to the pushed commit). auth-status stays local by default (auth-status --vault for vault presence, regression test added); tests fail closed against the real vault (dead loopback endpoint, isolated HOME); hosted per-call projection lists the caller vault with the signed token and runs the child through RunProjected; the token reaches only vault-aware children (trove). Conductor reruns: yoke go test ./pkg/secrets/... ok; bashy GOWORK=off go test -run MCPHosted|MCPOutpost|Gateway ./internal/agentos ok. Nits for later: the trove name special case in mcp_registered.go and the no-such-secret string match.
