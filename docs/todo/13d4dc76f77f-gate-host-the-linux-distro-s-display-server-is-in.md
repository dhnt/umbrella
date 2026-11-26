---
id: 13d4dc76f77f
kind: bug
title: 'Gate host: the Linux distro''s display server is in a crash loop (a segfault every 35 to 70 seconds)'
seq: 800
status: done
priority: p2
labels:
    - venue
created: 2026-11-26T14:40:48.043583Z
closed: 2026-11-26T17:42:47.914749Z
---

Found 2026-11-26 while root-causing a grader timeout in Sprint 731 (story a9e27a3da490). On the Windows test host's Linux gate distro, the system log shows the display server (the compositor behind the exported DISPLAY) segfaulting every 35 to 70 seconds since at least 05:30 local time. Effect: any program that queries the desktop while a display is exported can hang for 15 to 45 seconds until the display server restarts; measured with 'xdg-settings get default-web-browser', 3 of 123 calls in 150 seconds. Python's webbrowser module makes that query. Contained for the spec2src grader by hiding the display from candidate phases (grader v2.3). Not contained for other suites on the lanes: a gate lane should be headless (no DISPLAY or WAYLAND_DISPLAY) unless a test needs one; consider unsetting both in the gate-lane environment script. The crash loop itself needs its own root cause on the host; do not restart host services without the operator.

## Root cause and state (2026-11-26, Sprint 731 conductor)

**Root cause (environment).** The host's built-in Linux GUI layer is in a restart loop. Its supervisor log shows the same cycle every 35 to 105 seconds: the display server starts, the host-side remote-display client connects and reports one monitor of width 0 and height 0, the client exits with status 0, and the display server then dies with a segmentation fault in its remote-display backend. The host has no usable desktop display for that client, so the loop never settles. The loop was already running at the oldest entry the system log keeps.

**Contained for every lane (done).** `script/gate-lane.sh` now removes `DISPLAY` and `WAYLAND_DISPLAY` in the lane environment and its `check` fails when one is exported. A lane is headless. Deployed to the gate host (the previous copy is kept beside it), `check` passes, and under `run` the desktop query that hung for 15 to 45 seconds returns in 0.06 seconds. The spec2src grader also hides the display on its own (v2.3).

**Not done: stopping the loop itself.** The clean fix is to switch the GUI layer off for the Linux subsystem (one line in the host user's subsystem settings file: `guiApplications=false`), which takes effect only after a full shutdown of the subsystem. That shutdown stops every distro on the host, including the machine that runs the live service, so it needs the operator's go and a moment when a short outage of that service is acceptable. Until then the loop only writes log lines; nothing on a lane can reach the display.

## Fixed on the host (2026-11-26, 9:40 AM PST)

With the operator's approval and after the other managers confirmed the host was free: the GUI layer was switched off in the host user's subsystem settings (`guiApplications=false`) and the Linux subsystem was shut down and started again. The live service answered again about 30 seconds later. After the restart the gate distro exports no display, the system log shows no display-server crash, and `gate-lane.sh check` passes. The restart also emptied the distro's `/tmp` (about 44 GB of leftovers from earlier test runs). One message to look at later: the distro prints "Failed to start the systemd user session for 'root'" when a command is started in it; commands run normally.
