# Shapeable apps: worker brief (Sprint 631)

This brief is for every worker on a Sprint 631 story. Each story names one job, its base and its demo. Everything else is here.

## Rules
1. **Scope:** Linux plus the web UI only. No macOS or Windows native work in this sprint.
   **Venue:** never run containers, VMs, podman or model servers on the dev box. Container and Linux runtime proofs go on the claimed gate host (`bashy claim host:<gate host>`). If you have no gate host, stop at unit tests and say in your evidence that the runtime proof is still open. Evidence from a container on the dev box does not count.
2. **License (hard rule, no exceptions):** the base must be MIT, Apache-2.0, BSD or ISC. Read the actual LICENSE file before you start and record its SPDX id and star count in your evidence. Never vendor or link `ee/`, `premium/`, `enterprise/` or any other non-permissive directory. If the license is not what the story says, stop and report it instead of picking something else.
3. **Custom command, never core:** the deliverable lives in `bashy/examples/<job>/` as a `.bsh` custom command, using a Go or other fence only where needed. Follow the existing examples (`examples/desk`, `examples/vlog`). Do not change the bashy core to make it work. If something core is missing, file a todo and stop at the boundary.
4. **Wording:** public files describe the job (form, board, table, site...). Never name a commercial product the job replaces.
5. **Fork targets:** fork the base under the `qiangli` GitHub account, and pin an exact commit or tag. The custom command installs, starts, stops and reports status of that pinned build as a managed app. Any language works (Bash# fences), so build or run it however is simplest on Linux. Keep our patches small and on a named branch.
6. **Build targets:** extend the existing example named in the story.

## No hidden phone-home (hard rule)
These are "just for me" apps, so nothing leaves the owner's machine unless the owner turns it on.
- Remove every outbound call the owner did not ask for: analytics and telemetry SDKs (PostHog, Segment, Sentry, Plausible, Google Analytics, Mixpanel, Amplitude and the like), crash reporters, update and version checks, and OTel or other exporters pointed at vendor endpoints. Bundle remote fonts and CDN scripts locally.
- **Replace them with bashy OTel:** standard OTel (OTLP) to the owner's own trace, log and metrics store, exporting only when `OTEL_EXPORTER_OTLP_ENDPOINT` is set and doing nothing when it isn't, plus W3C trace propagation so traces stitch across the bashy console and outpost. Where the app has none, add it where it helps (server request spans, key jobs). Pattern to copy: `filebrowser/telemetry` (`provider.go` and `handler.go`) and the `cmd/root.go` wiring.
- **bashy OTel belongs to the owner.** It exists for the owner's own convenience (debugging, usage, cost), never for dhnt or anyone else to collect data. Never hard-code or default an endpoint, never point it at a dhnt or vendor host, and never send anything unless the owner set the endpoint to a store they run.
- **Only exception: generic machine status for monitoring and alerting.** For example, whether an outpost or satellite is up or down, or a health check. It must be non-sensitive (no content, file names, user identities, usage or behavior), cover only the minimum needed to alert, be documented where the owner can see it, and be used for monitoring only, never for collection or analytics. It belongs to the platform (outpost, satellite), not to the app forks in this sprint, which send nothing.
- Default is off. Any network feature the job needs (an LLM call, cloning a site, a share link) is opt-in and named in the command's help.
- Evidence: the output of the S11 scrub gate (`script/no-phone-home.sh <dir>`) with zero unexplained hits, plus a run of the app with outbound traffic logged or blocked showing no unexpected destinations.

## Make it shapeable
Every job must earn the **Shapeable** badge: registered, declared checks, scoped activation, and undo.
- Contract and lifecycle: `bashy/docs/software-shaping.md`
- Engine: `yoke/pkg/shape`
- Reference app, registration and checks: `bashy/examples/shaping/hello-world` (`register.sh`, `contract.bsh`, `checks/`)

## Done means
- **Shaping demo:** run the demo named in the story through wish → candidate → verify → preview → approve → undo, and show that the change is visible only to the requester.
- **Tests:** unit tests for the command (targeted tests only, no full or remote gates; QA is a separate pass).
- **Evidence:** the license SPDX id and star count with their source, the pinned fork commit, the commands you ran, and the results, all recorded on the story.
- **Commits:** every commit carries `Sprint: #631`, `Story: #N`, `Story-ID: <id>` and `Agent: <your agent name>`.
