---
id: 01a1ca6a-50ae-7027-848f-3bef83c1f013
seq: 3
form: page
type: gotcha
title: Compose examples/ Bash# commands so they run the same on Windows
description: 'WHEN writing or reviewing a .bsh custom command (examples/) that must work on Windows as well as macOS/Linux: call tools only as REGISTERED commands (bashy commands add / a doctor step), never bare PATH names (a bare name found on a native PATH entry does not run); put PowerShell/C# in ~~~powershell / ~~~csharp fences (pinned PowerShell 7), never powershell.exe from PATH; run other scripts through bashy, never bash; compute the script folder with src=${BASH_SOURCE[0]//\\//} before dirname (dirname of C:\x\y.bsh is ''.''); give a stdlib-only ~~~go fence its own one-line go.mod (else it compiles inside bashy''s whole module and stalls on a fresh machine); hash with bashy''s builtin sha256sum; sandbox BASHY_COMMANDS_DIR in tests of anything that registers commands; Chrome MediaRecorder writes fragmented Opus MP4 that macOS players refuse — rewrite takes as AAC with ffmpeg. Test on Windows first, with a current bashy build (an old rc on the host masquerades as product bugs). Sources: bashsharp-tour 07-commands/04-islands/10-windows, sh/docs/bashpp-polyglot-fences.md. Learned Sprint 603 (2026-11-10/11).'
status: candidate
source:
    tool: claude-opus5.5-s603
created: "2026-11-11T11:42:07Z"
---
