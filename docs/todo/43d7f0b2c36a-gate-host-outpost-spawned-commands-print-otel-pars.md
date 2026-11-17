---
id: 43d7f0b2c36a
kind: task
title: 'gate host: outpost-spawned commands print OTel ''parse url 127.0.0.1:31416'' — root-cause the env source and fix the venue'
seq: 424
status: done
priority: p1
created: 2026-11-17T19:25:28.625058Z
assignee: claude-opus5.5-s656-gate
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
closed: 2026-11-17T19:49:16.238317Z
closed_by: claude-opus5.5-s656
---

Seen 2026-11-17 while staging the rc.37 tier kit: every outpost ssh command to the gate host (the big Windows host that runs the rc gates and the linux tier lane in WSL Ubuntu-24.04) prints 'internal_logging.go:50 parse url' for OTEL_EXPORTER_OTLP_ENDPOINT=127.0.0.1:31416 (host:port, gRPC form). Same symptom as outpost todo c84bb044 on the first Windows QA host 11-15 (cause there: a USER-level registry env var inherited by the daemon). Do: (1) prove where the value enters the gate host daemon env (registry user/machine, launcher script, scheduled task, service, upgrade re-exec, WSL interop); (2) record what set it (yoke otel stack bridge?); (3) fix in the VENUE (clear the source, restart the daemon cleanly), never in product code; (4) verify: outpost ssh to the native shell and to WSL root shows zero stray stderr lines; (5) sweep the other fleet hosts (second Windows host, macOS QA host, dev box) for the same var. Do not touch the gate host's default podman or the gate image. Hosts by role in all public text.

## ROOT CAUSE 2026-11-17

Emitter: the bashy.exe that the gate host's outpost daemon spawns for every session (`bashy.exe -c "<cmd>"`, and the login shell on the daemon's own ssh unit on 2222, which is the same outpost process). Its OTel SDK uses HTTP exporters; envconfig cannot parse the host:port value ("parse url ... first path segment in URL cannot contain colon"), falls back to https://localhost:4318 and also prints "traces export: ... refused". Not the dev box (no OTEL_* in its env or launchd), not WSL: inside `wsl -d Ubuntu-24.04 -u root` the vars are absent (WSLENV empty); the WSL-route lines come from the native bashy.exe wrapper that launches wsl.

Where it enters: the gate host's USER-level registry environment (HKCU\Environment) holds three values: OTEL_EXPORTER_OTLP_ENDPOINT=127.0.0.1:31416, OTEL_SERVICE_NAME=outpost, OTEL_RESOURCE_ATTRIBUTES=host.name=<gate host>. Machine level (HKLM) is clean; no WSLENV; no launcher/service override (daemon runs from the per-user scheduled tasks `outpost` (logon) and `outpost-boot` (boot), action `outpost.exe supervisord`, no env). The current daemon (`outpost supervisord` -> `outpost start`) was started 2026-11-16 20:01 UTC and inherited the values; every spawned shell shows the same three vars. HKCU\Environment key last write 2026-11-13 12:31 UTC (last edit of any value in the key, not necessarily these).

What set it: a deliberate operator configuration from Sprint 563 Phase 0 (bashy docs/plan-s563-master-execution.md, step 2): "outpost's own OpenTelemetry export is enabled on [the gate host] (user environment OTEL_EXPORTER_OTLP_ENDPOINT=127.0.0.1:31416, the local `bashy otel serve` gRPC port; OTEL_SERVICE_NAME=outpost)" to make Klatch app-entry changes searchable in the local OTel store. 31416 is the yoke otel-stack gRPC bridge (yoke pkg/fleet/baseline/services/otel-stack.yaml: `otel serve --port 31415 --otlp-grpc-port 31416`). Outpost's own exporter is gRPC and strips any scheme, so the value is correct FOR OUTPOST; the defect shows only in children that inherit it (product gap already filed: outpost c84bb044 / bashy SDK diagnostics on the user's stderr, todo 89a3f6f8).

Classification: environment (venue configuration), with the known product gaps above as the reason it is noisy.

Venue fix: NOT APPLIED — stopped per the story rule. The value is in active use: the otel stack (otel.exe serve, 31415/31416, up since 2026-11-16 07:31 UTC) is running and the outpost daemon holds an ESTABLISHED connection to 127.0.0.1:31416, i.e. outpost's own telemetry export on the gate host depends on exactly this variable. Clearing it would silently end that export. Operator decision needed, options:
  (a) end the S563 experiment (sprint is done): delete the three HKCU values and restart the daemon from a clean environment (11-15 recipe: script that clears the vars, launched outside the daemon tree via WMI/scheduled task);
  (b) keep outpost export and quiet the children: add HKCU OTEL_EXPORTER_OTLP_PROTOCOL=grpc (yoke telemetry honours it, so bashy children would export gRPC to the same bridge, which accepts host:port) and restart the daemon; untested, changes every outpost-spawned process into an exporter;
  (c) leave the venue; tier kit keeps neutralising by unsetting the vars in its launcher.

Evidence (2026-11-17, dev box -> gate host over LAN): native route `outpost ssh <user>@<gate host> -- <native bashy> -c env`: env has the three vars, stderr 4x parse url + 2x traces export; plain ssh to the daemon's unit on 2222: same vars, 2x parse url + 1x traces export; WSL route `... -- wsl -d Ubuntu-24.04 -u root -- bash -s`: no OTEL_* inside WSL, stderr 2x parse url + 1x traces export (from the native wrapper).

Sweep (read-only): second Windows host: HKCU/HKLM/spawned env clean, 0 parse-url lines. First Windows QA host (the 11-15 case): HKCU/HKLM/spawned env now clean, 0 lines. macOS QA host (admin account, :22, key auth): no OTEL_* in env or launchd, 0 stderr lines. Dev box: no OTEL_* in env or launchd.

## VENUE FIX 2026-11-17 (decision: option a)

Decision (sprint manager): end the Sprint 563 setup; S563 is done and the host configuration outlived it.

Change on the gate host:
1. Backup of the three values (reg-import format) kept on the dev box in the session scratch area as `g43/otel-env-backup.reg`: OTEL_EXPORTER_OTLP_ENDPOINT="127.0.0.1:31416", OTEL_SERVICE_NAME="outpost", OTEL_RESOURCE_ATTRIBUTES="host.name=<gate host>". Restore = `reg import` of that file plus a daemon restart.
2. Deleted those three values from HKCU\Environment (HKLM untouched; was already clean).
3. Restarted outpost's init tree from a clean environment, outside the daemon's process tree: a PowerShell script in the user's TEMP (`g43-outpost-restart.ps1`, log `g43-outpost-restart.log`), launched by WMI Win32_Process Create, removed the OTEL_* vars from its own env, terminated the old `outpost supervisord` (init), its `bashy supervisord` (monitor) and `outpost start` (daemon) at 19:43:21Z, and started `outpost.exe supervisord` hidden at 19:43:24Z. The new init brought up a new daemon and monitor; the monitor replaced its unit processes (apps, meet, outpost-lern-si) with fresh ones, so the old outpost-lern-si unit process was replaced, not left running with the old env; all three units are active with new pids. The otel stack process (`otel serve` on 31415/31416, not a child of the init tree) was not touched and still listens; the monitor reports its unit `otel-stack` as failed because "port 31415 is held by a foreign listener" (that pre-existing process); the outpost daemon no longer exports to 31416 (no connection), as intended. No reboot, no `wsl --shutdown`, podman machines not touched.

Verification (dev box -> gate host over LAN, after the restart):
- native route `outpost ssh <user>@<gate host> -- <native bashy> -c env`: rc=0, 0 OTEL_* in env, 0 stderr lines;
- WSL route `... -- wsl -d Ubuntu-24.04 -u root -- bash -s`: rc=0, no OTEL_* inside, 0 stderr lines;
- plain ssh to the daemon's unit on 2222 (key auth): rc=0, 0 OTEL_* in env, 0 stderr lines;
- HKCU\Environment has no OTEL_* values; listeners back on 2222/17777 (daemon), 17779 (outpost-lern-si), 22749 (apps), 8637 (meet).

Observation (not caused by this change, not acted on): `wsl -l -v` shows podman-machine-default Stopped and nothing listens on 127.0.0.1:7100; 7100 also had no listener in the pre-change probe. Reported to the manager for whoever owns the Klatch service.
