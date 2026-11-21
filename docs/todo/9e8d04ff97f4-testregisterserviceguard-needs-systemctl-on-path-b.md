---
id: 9e8d04ff97f4
kind: test
title: TestRegisterServiceGuard needs systemctl on PATH before the guard (venue-dependent)
seq: 593
status: done
priority: p1
created: 2026-11-21T10:15:24.425142Z
assignee: codex-gpt6.2-sol
sprint: 652
sprint_id: 48a699fb-076f-5442-995a-b12987a45bea
sprint_title: Outpost reliability and host-offline alerting on cloudbox
closed: 2026-11-21T10:17:10.473116Z
closed_by: codex-gpt6.2-sol
---

The Linux registration guard test must exercise the fail-closed service runner in official images without a systemd executable. Provide a test-local sentinel and assert that it is never executed.

## Root cause

The WSL gate host used the official rc.39 image at digest
`sha256:c7e19f271086e3a20fd7ade71ad41afba36700cfba3c90e064117e5c0359e3a2`.
Of the 68 selected packages, 59 passed, eight had no test files, and the
Outpost CLI package failed only `TestRegisterServiceGuard` (suite log SHA-256
`8c7d83bf663d671bf79fa948b83565aa7b5488e30b7347dd1ab523973ab9ea5c`).
The attached WSL session completed normally.

The same test failed identically at the immediate pre-recovery main commit
`f066eaf` with the same image and lane. `systemctl` is absent from the
image. On Linux the registration path checks executable availability before
the guarded call. The subprocess therefore returned the missing-systemctl
diagnostic before it could exercise the guard introduced in `53b2ebc`.
Classification: pre-existing test fixture dependency exposed by the official
image. Make a sentinel executable available on the test subprocess's private
PATH and assert that the guard prevents its execution. No system package,
image, or production change is needed.

## Delivery and evidence

Outpost commit `159a4f9` changes only `service_boundary_test.go`.
The sentinel is discoverable only in the Linux guard subprocess and the
test asserts that it was never executed. The official rc.39 WSL lane 2
short suite passed with this fixture, including the previously failing
Outpost CLI package. The run used the source tree
`4457ae8888357e032ede3ce21c45c5467a5cc92e` before the commit message was
updated to point to this story. The gate log SHA-256 is
`71630a77ec2099db5cd3951e42021b9a76183b0fdec2ac18e58758f70dbc156f`.
