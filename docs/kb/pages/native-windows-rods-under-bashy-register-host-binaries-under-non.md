---
id: 01a1d6da-690f-7422-83ac-773306935a3f
seq: 13
form: page
type: gotcha
title: 'Native Windows rods under bashy: register host binaries under non-shipped names, build with go.work, hand native paths to native tools'
description: 'WHEN running or writing an examples/ rod or service door that must work natively on the Windows test host (Sprint 634 translate live run). (1) bashy ships ''ollama'' and ''curl'' verbs: ''commands add'' under those names is refused, so film doctor registers the host binaries as ollama-host / curl-host and the rods call those. (2) ''command -v''/''type'' cannot see bashy''s in-process applets (jq, sha256sum) and a bare python3/curl found on PATH does not run under bashy on Windows: never declare has=jq in a rod''s requires (jq is always in-process), probe python3 with ''python3 -c pass'', and bashy''s jq has no --arg (bind with env). (3) The door''s ''cd && pwd'' canonicalisation renders /c/... which the Go providers selector and native curl cannot open: the door converts to a native path (native_path). (4) A GOWORK=off Windows build lacks the ''route'' command path the defaults need: cross-build with the umbrella go.work. (5) On Windows bashy-defaults apply registers whichever bashy is first on PATH and fetches the source pin into BASHY_HOME/src/bashy: put the sprint build first and extract the sprint tree over the pin. (6) Reach the host with ''bashy outpost ssh user@host -- powershell -NoProfile -Command -'' and the script on stdin; long -Command/-EncodedCommand args fail; no multi-line here-strings; set OTEL_SDK_DISABLED=true. Standalone ollama: official zip + tar.exe (Expand-Archive chokes, Inno installer refuses non-interactive, winget source broken there); a download longer than the ssh timeout truncates, resume with detached curl.exe -C -. Evidence: bashy docs/sprint-634-translate-evidence.md; shared has=jq gap = bashy todo f9e0a8bd.'
status: candidate
source:
    tool: claude-fable5.1-s634
created: "2026-11-13T21:40:00Z"
---
