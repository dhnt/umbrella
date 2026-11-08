# Sprint 597 — Klatch participant CLI MVP

## Outcome

Provide a scriptable CLI for a human's existing Klatch account through the Bash# Klatch example. Make `bashy/examples/klatch/klatch.bsh` the primary command and shaping entrypoint, with routing and composable workflows in the script. Keep any Klatch Node helper limited to protocol, crypto, sessions, and file work using existing SDK and APIs. Do not add a server feature unless a demonstrated API blocker requires it.

## Delivery order

1. **Klatch helper:** implement the smallest Node TypeScript helper needed for account sessions, protocol calls, sealing, and files. Support login/status/logout with existing MFA; contacts list/invite/accept; conversations list/show/create/rename/leave and members list/add/remove; messages list/show/send/edit/delete; attachment upload/download; and foreground watch using SDK sync. JSON output, stable IDs, stdin/file input, prompt/stdin/secret refs for secrets, and client-side seal unlock are required. Prefix assistant-authored text `[Assistant: NAME]` before send. No automatic replies, daemon, durable replay, or automatic retry of uncertain sends. The helper is an internal mechanism, not the canonical user interface.
2. **Bash# integration:** extend `bashy/examples/klatch/klatch.bsh` as the primary participant command surface. Put command routing and composable workflows in Bash#, preserve setup/provision/status, update registration, skill metadata, help, and concise usage docs including the shaping entrypoint. Treat Node as an explicit MVP runtime dependency. Begin after the helper contract is fixed.
3. **Sandbox e2e tests:** extend the existing public `bashy/tests/klatch-e2e` harness and its sandbox lifecycle to exercise the participant CLI, sealed messaging and attachments, and the bashy wrapper as appropriate. Acceptance is runnable tests and measured results. Keep code review as an ordinary manager responsibility.

## Coordination and closure

Use isolated worker workspaces and the sprint assignment ladder. The manager owns integration, gate runs, story acceptance, and sprint continuity. Run **all** builds and tests on the shared test host after taking its advisory hold; the development host is for editing and coordination only. Coordinate with any holder. Commit and push producer changes before any umbrella pin bump. Preserve unrelated dirty pins and source edits. No deployment or release.
