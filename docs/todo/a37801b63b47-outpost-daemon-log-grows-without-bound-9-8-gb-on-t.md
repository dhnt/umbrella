---
id: a37801b63b47
kind: bug
title: outpost daemon.log grows without bound (9.8 GB on the second build host) and filled the system drive, wedging the podman VM
seq: 678
status: todo
priority: p1
labels:
    - outpost
    - windows
created: 2026-11-23T14:36:13.062087Z
---

Found 2026-11-23 while freeing space on the second build host (Windows, the host's own user profile): $HOME/.cache/outpost/daemon.log was 9.8 GB and still being written (last write 2026-11-23); the drive was at 0 GB free, and the podman WSL distro on that host stopped creating processes (getpwnam failed / I/O errors) until space was freed. The log was truncated with Clear-Content as the immediate relief (the daemon kept running). Expected: size- or time-based rotation with a bounded number of files, or a cap, and a daily sweep of stale cache dirs. Root cause before fix: check how the daemon opens daemon.log on Windows and what floods it (the same log on other hosts for comparison). Not gating.
