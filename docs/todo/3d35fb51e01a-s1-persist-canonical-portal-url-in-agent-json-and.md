---
id: 3d35fb51e01a
kind: feature
title: S1 Persist canonical portal_url in agent.json and unify Outpost server discovery
seq: 69
status: assigned
priority: p0
labels:
    - satellite
    - outpost
    - fleet
    - satellite-cli
created: 2026-11-10T01:43:06.701041Z
assignee: codex-gpt5.6-sol
sprint: 606
sprint_id: ebee3343-b774-520a-9d53-b57b306f4210
sprint_title: Streamline Cloudbox master, satellite, and outpost relationships
---

Sprint 606 (ebee3343-b774-520a-9d53-b57b306f4210).
Dependencies: None.

Scope
- Persist canonical portal_url (https://...) in Outpost agent.json during portal.Exchange, Reattach, and Recover (outpost/internal/agent/portal/).
- Update yoke/pkg/fleet.PairedServer and yoke/pkg/accounts/adapters/cloudbox to prefer portal_url directly rather than heuristically reconstructing URLs from protocol/server_addr/server_port (tunnel port 7000 vs HTTPS 443) or reading profiles/<name>/server sidecars.
- Preserve backward-compatible fallback for existing agent.json files that lack portal_url.
- Also covers the shared-LLM door: yoke/pkg/broker/share.go (satelliteAppURL / satelliteHTTPBase, used by `bashy llm share --via cloudbox --satellite NAME`) reads the outpost-profile profile's portal_url when present, with the current protocol/addr/port rule as the fallback. One helper serves fleet, the accounts adapter and the broker.

Acceptance
- Newly paired, reattached, or recovered Outpost configs contain portal_url.
- PairedServer() and cloudbox.Adapter.Discover resolve the exact portal URL without sidecar files, while legacy agent.json fixtures continue to pass.
- `llm share --satellite` resolves the same door URL as before for an existing profile (fixture without portal_url) and the exact portal_url for a new one.
