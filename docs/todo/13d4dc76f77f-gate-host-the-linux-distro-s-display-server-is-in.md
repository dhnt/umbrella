---
id: 13d4dc76f77f
kind: bug
title: 'Gate host: the Linux distro''s display server is in a crash loop (a segfault every 35 to 70 seconds)'
seq: 800
status: todo
priority: p2
labels:
    - venue
created: 2026-11-26T14:40:48.043583Z
---

Found 2026-11-26 while root-causing a grader timeout in Sprint 731 (story a9e27a3da490). On the Windows test host's Linux gate distro, the system log shows the display server (the compositor behind the exported DISPLAY) segfaulting every 35 to 70 seconds since at least 05:30 local time. Effect: any program that queries the desktop while a display is exported can hang for 15 to 45 seconds until the display server restarts; measured with 'xdg-settings get default-web-browser', 3 of 123 calls in 150 seconds. Python's webbrowser module makes that query. Contained for the spec2src grader by hiding the display from candidate phases (grader v2.3). Not contained for other suites on the lanes: a gate lane should be headless (no DISPLAY or WAYLAND_DISPLAY) unless a test needs one; consider unsetting both in the gate-lane environment script. The crash loop itself needs its own root cause on the host; do not restart host services without the operator.
