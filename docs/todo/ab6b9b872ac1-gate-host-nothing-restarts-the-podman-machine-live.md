---
id: ab6b9b872ac1
kind: task
title: 'gate host: nothing restarts the podman machine (live Klatch) after a reboot — add an autostart'
seq: 437
status: todo
priority: p1
labels:
    - venue
created: 2026-11-17T21:03:06.369091Z
sprint: 656
sprint_id: b220aade-5c96-5625-9a68-a0b7619c418a
sprint_title: 'rc.37 QA venue: gate-host OTel env leak + macOS QA host ssh auth'
---

Root cause 2026-11-17 (read-only investigation): the gate host reset abruptly at 2026-11-16 05:44:54Z (and again 07:31:15Z); podman-machine-default stopped at the first reset and never restarted; Klatch (inside the machine, auto-starts there) was down ~39 h until noticed. NOT an upgrade gap: all outpost upgrades (11-16 10:29Z, 19:54Z, 20:01Z; 11-17 rc.37 20:14Z) came after the stop. On that host only the scheduled tasks \outpost and \outpost-boot run 'outpost.exe supervisord'; no unit/task/service starts the machine; outpost's ensurePodmanRuntime only runs for the vk-podman cluster runtime (this host is vk-native). Fix (venue): a per-user autostart after logon that runs 'bashy oci machine start podman-machine-default' and probes 127.0.0.1:7100 — preferably a bashy-supervisord process unit with a start-and-probe check (ensurePodmanMachineWith in bashy), so it is visible in 'outpost services'. Operator owns Klatch: confirm before starting the machine. Host resets themselves: Sprint 652 b3580b97 (LiveKernelEvent 141 GPU timeouts recur every 3-4 h).
