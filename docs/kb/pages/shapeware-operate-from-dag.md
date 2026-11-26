---
id: 01a2186e-40e2-73d8-9e80-2d5795636b18
seq: 29
form: page
type: runbook
title: 'Operate a shapeware folder: build, test, install, run and serve from its dag.md'
description: 'WHEN an agent is asked to take an already built shapeware app folder to an installed command or a running service (operate, install, deploy, serve; dag.md lifecycle; conform against the installed app; the operate drill): run each lifecycle step exactly as dag.md writes it, gate on exit codes and on the contract against the installed app, with the traps found in Sprint 731 (an app that starts its own server, a shell that shadows the judge, a display on a headless host, step limits, leftover processes, quota)'
tags:
    - shapeware
    - conform
    - operate
    - dag
    - drill
status: candidate
evidence: 'Sprint 731 stories T1 and T2 (umbrella docs/sprint-731-report.md); agent-bench packs/spec2src/t2-operate at 3972d8e: no-model control PASS, codex-gpt6-luna 3 of 3, opencode-glm-5.3-flash 3 of 3'
source:
    tool: claude+2
created: "2026-11-26T15:16:48Z"
---

Goal: take a shapeware folder that is already built from its spec to an installed command and a running service, by carrying out its lifecycle exactly. Measured on bashy's `form` in Sprint 731 (`docs/sprint-731-report.md`): a plain script with no model passes, and two lower-tier agent bindings passed 3 of 3 cold. The drill that measures a binding at this is agent-bench `packs/spec2src/t2-operate`. Building the folder from its spec is a different job: [[shapeware-source-from-spec]].

## Steps
1. **Read `dag.md` first, and only `dag.md` for the commands.** Each step is a `### name` heading with a purpose line, `Effects:`, `Band:` and one code block. Run the code block of a step with `sh` from the folder, exactly as written (with bashy: `bashy dag -f dag.md <step>`). Never replace a step with commands of your own, and never change a file that came with the folder.
2. **Consent before the first step that writes or runs anything on a machine.** The person who answers for the machine sees the effects of each step and says yes. This gate is a rule of the workflow standard; it is not yet a tool.
3. **`build`.** Exit status 0 is the gate. A build with nothing to compile still says so.
4. **`test`.** It runs the judge on the contract against the fresh build, before anything is installed. Read only the PASS and FAIL lines. Any FAIL: stop and report it; do not go on to install.
5. **`install`.** Use the default place unless told otherwise. When the step installs a launcher, check that its directory is on the PATH.
6. **`run`.** Pass the app's arguments as one value, `ARGS='...'`; the step splits them and never evaluates them. Keep the output when a later step needs a value from it (an id, a URL).
7. **`serve`.** It runs in the foreground: start it in the background of your shell, keep its process id, use the service, then stop it with TERM. A stopped service reports the signal's status (143), not 0.
8. **Check the installed app, not the folder.** Run the contract again with the installed command first on the PATH (`conform run CONTRACT.md --path <bin dir> --fresh-home`). This is the only run that proves the trip.
9. **Report** each step with its exit status, and leave nothing running that you started.

## Traps (each one cost a wrong verdict or a rerun in Sprint 731)
- **An app that starts its own background server.** `form add` starts one, so the page answers before `serve` is run, and `serve` may then return at once or fail on a busy port, depending on the build. If `serve` exits early, read its output before calling the step failed; the spec has to say what `serve` does in that case, and whether the app has a stop.
- **A shell that shadows the judge.** In a bashy shell `conform` is a built-in for other suites. Run the steps under a plain system shell, or call the judge binary by its path.
- **A display on a headless machine.** With `DISPLAY` set and no working display server, a desktop query (Python's `webbrowser` makes one) can hang for tens of seconds and the judge reports a timeout. Unset `DISPLAY` and `WAYLAND_DISPLAY` on a test host, and set `BROWSER` to a no-op where no window should open.
- **Step limits.** The judge's default limit is 30 seconds per command. A first command that compiles or waits can exceed it; that is a venue condition to state, not an app failure to hide.
- **Leftover processes.** Stop what the steps started, by the folder's path, never by a broad name. The agent-bench runner does this with `scripts/reap.py`.
- **Quota.** A provider refusal at the first command is a venue fault: nothing was measured. Defer and rerun.
