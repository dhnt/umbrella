---
id: 0bde32fb727c
kind: feature
title: S3 Support native multi-satellite tunnel and app attachments in a single Outpost daemon
seq: 71
status: todo
priority: p1
labels:
    - satellite
    - outpost
    - satellite-cli
created: 2026-11-10T01:43:06.909729Z
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210). No coding in planning turn.
Dependencies: S2.

Scope
- Add first-class satellite attachment lifecycle verbs in Outpost (outpost satellite attach, detach, list) backed by the single running Outpost daemon.
- For each attached satellite, run a lightweight secondary portal/matrix tunnel session publishing only the configured allowlist of local apps[] while sharing the host's in-memory sso_secret.
- Keep host-singleton services (port 17777 control server, sshd, shard, ollama, k3s/DKS, fleet supervise units) single-instance.
- Attach needs no pairing code: `outpost satellite attach <satellite>` uses the host's single cloudbox pairing; the master issues a satellite credential for that host when the host's account is a member of the satellite (the master already signs host-to-satellite assignments). The needed master/satellite wire (host Bearer: request attachment credential; satellite: accept it) is filed as a support ticket against the public wire contract; outpost and yoke implement the client side against a fixture.
- Existing users of outpost-profile keep working until attach is in place: `bashy llm share --satellite NAME` (yoke/pkg/broker/share.go) resolves the door URL from an attachment first and an outpost-profile profile second.
- Deprecate (do not delete in this sprint) the multi-daemon bashy/examples/outpost-profile/outpost-profile.bsh workaround (ports 17778-17797, cloned XDG_CONFIG_HOME/BASHY_FLEET_DIR, 11 disabled units, .active marker).

Acceptance
- One Outpost daemon simultaneously maintains its primary owner pairing and publishes local apps (e.g. Klatch) to one or more attached satellites without spawning extra outpost-<name> daemons.
- `bashy llm share --satellite NAME` works against an attachment and against a legacy profile; a shared member gets 200 through the satellite, an unshared member 403, no credential 401.
- Migrating an existing outpost-profile instance or a satellite-paired host to an attachment is one documented step; no satellite pairing code is used.
