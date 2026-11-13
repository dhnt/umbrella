# Shapeable apps: worker brief (Sprint 631)

This brief is for every worker on a Sprint 631 story. Each story names one job, its base and its demo. Everything else is here.

## Rules
1. **Scope:** Linux plus the web UI only. No macOS or Windows native work in this sprint.
2. **License (hard rule, no exceptions):** the base must be MIT, Apache-2.0, BSD or ISC. Read the actual LICENSE file before you start and record its SPDX id and star count in your evidence. Never vendor or link `ee/`, `premium/`, `enterprise/` or any other non-permissive directory. If the license is not what the story says, stop and report it instead of picking something else.
3. **Custom command, never core:** the deliverable lives in `bashy/examples/<job>/` as a `.bsh` custom command, using a Go or other fence only where needed. Follow the existing examples (`examples/desk`, `examples/vlog`). Do not change the bashy core to make it work. If something core is missing, file a todo and stop at the boundary.
4. **Wording:** public files describe the job (form, board, table, site...). Never name a commercial product the job replaces.
5. **Fork targets:** fork the base under the `qiangli` GitHub account, and pin an exact commit or tag. The custom command installs, starts, stops and reports status of that pinned build as a managed app. Any language works (Bash# fences), so build or run it however is simplest on Linux. Keep our patches small and on a named branch.
6. **Build targets:** extend the existing example named in the story.

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
