---
id: 08ee6df70b5d
kind: bug
title: Pass the adapter cache location to the ycode knowledge-base command
seq: 690
status: todo
priority: p1
labels:
    - ycode
created: 2026-11-24T10:52:07.697277Z
sprint: 703
sprint_id: 21bfcc03-ecb2-50e9-84ae-d33c01f54b40
sprint_title: 'Group shaping follow-ups: agent kb context, test hygiene, kit handler lift, board and fleet gaps'
---

Run 220 at ycode 8ad8cd19: TestHarnessStreamWaitsForAppendNotifications fails 5/5 with the gate runner at 9db42aa8 and passes 3/3 with the older Step 0 runner. The kb command now uses a Go adapter. The command environment in examples/agent.yaml omits its cache location and the Go build cache. The adapter cannot find its binary or compile it in that environment, returns empty knowledge through the fallback, and adds 1.19–1.26 seconds before provider start. Required repair: pass only the necessary cache location variables, retain the one-second test deadline, prove real kb context reaches the command caller, and pass all 83 ycode short-test packages on the gate. Supervisor approval recorded on Sprint 684 at 10:51. Keep the fix in ycode.

Run 223 tested the unchanged one-second assertion on the gate. An adapter-cache-only allowlist, XDG-cache-only, the four cache-location variables together, and HOME alone each failed (1.07–1.12 seconds). The default adapter and XDG cache variables were unset. The fixture also replaces HOME with a temporary directory. Keeping the effective adapter cache across that fixture change allowed the assertion to pass with a cache-only allowlist (V5, 1.38 seconds total test time).

With the cache resolved and a known page in a disposable repository ring, the real command returned the page in JSON but exited 1 because the required agent ring lacked YCODE_DATA_DIR. The harness consequently selected empty knowledge. Providing a store location to a shared command policy requires an operator decision about least privilege. Run 223 is reference evidence. The supervisor deferred the product repair for a separately planned story. Keep this bug open at p1.

## Sprint 703 review 2026-11-24 (operator)

Operator ruling (F1): the kb command may receive only the adapter's cache location and the Go build cache variables (the minimum to find or build its binary); nothing else from the parent environment. Unblocked for code.
