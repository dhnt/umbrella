---
id: d7933b7cddd7
kind: feature
title: S7 Share an app with a member over Bearer + bashy paired-host share/unshare/shares
seq: 75
status: assigned
priority: p1
labels:
    - satellite
    - cli
    - parity
    - satellite-cli
created: 2026-11-10T14:21:32.52111Z
assignee: codex-gpt6-sol
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Closes the UI-CLI parity gap parity-share-grant (bashy todo 9bbbed028aa2, docs/ui-cli-parity.md): owners share an app with a member only in the web console today. Agent-first rule (operator): every console action has a bashy verb.
CONTRACT (owner Bearer, master and standalone; add to yoke docs/cloudbox-members-attach-wire.md as section 2b and to pkg/fleet/cloudboxfake):
- GET /api/v1/hosts/:host/shares  (scope hosts:read or hosts:write) -> 200 {"shares":[{"id","host","app","email","created_at"}]}; 404 not_found when the host is not the caller's.
- POST /api/v1/hosts/:host/shares (scope hosts:write) body {"app":"board","email":"bob@example.com"} -> 201 {"share":{...}}; an existing identical share -> 200 unchanged; 422 not_mutual_member unless the email is an ACTIVE MUTUAL member of the caller (same rule as the console share and the host-share reads); 422 invalid_email; 404 not_found (host not yours).
- DELETE /api/v1/hosts/:host/shares/:id (scope hosts:write) -> 204, idempotent.
- Same HostShare table and semantics as the cookie /api/hosts/:host/shares; never the bottom-up host:grants path (that one deliberately skips the member list).
Verbs: bashy paired-host share HOST --app APP --email EMAIL [--dry-run] [--json]; bashy paired-host unshare HOST ID|--app APP --email EMAIL [--dry-run]; bashy paired-host shares HOST [--json].

Design correction (manager, 2026-11-10): shares live where the host row lives (standalone/satellite), never on the master (identity-only hosts, no share sync). Server on standalone+satellite builds; auth = owner Bearer OR the host's own token for its own host. Verb = outpost apps share|unshare|shares (bashy outpost apps ...) using the attachment endpoint+token; satellite-member publish can then complete the share. The paired-host share verb is dropped.
