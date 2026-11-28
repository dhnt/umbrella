---
id: 3a25d5ece9bd
kind: task
title: 'U3 bashsharp decoupling: move bashy/yoke/ycode-coupled cli tests to bashy; drop yoke from bashsharp go.mod'
seq: 866
status: todo
created: 2026-11-28T18:32:15.544644Z
sprint: 746
sprint_id: d7955ade-9943-51b0-b95d-d19b22e3b547
sprint_title: 'Utils vs tools: minimal bashy built-in set (MVP)'
---

Root cause by name: cli/main_test.go:20 blank-imports yoke/cmds/all; agent_tui, bashpp_interactive, noexec_sh, gosource_environment, owned_exec + bashy sub-cases of posix_contract/option_visibility build bashy/ycode/yoke (carried over in bashsharp 4295cf1). Move to bashy/cmd/bashy unchanged; drop yoke require + yoke-only replaces; ratchet no yoke/bashy/ycode in module graph or test imports. Verify GOWORK=off on gate host, by test name.
