# Sprint 573: Windows, C# and PowerShell fence validation

Created at the operator's direction as an explicit scope split from Sprint 562.
Manager: `codex-gpt6-sol`. Sprint UUID: `a5f60348-0dc8-5af7-80aa-9dffe2c745ea`.

## Outcome and acceptance

Complete the outstanding Windows platform, C# language and PowerShell language
coverage from Sprint 562 without changing source inventories, expected outputs,
per-case deadlines or required modes. An obligation transferred here is deferred,
never reported as passed by Sprint 562. Historical passing Linux evidence remains
valid only when its exact inputs are unchanged.

## Carried work

The existing dedicated stories retain their IDs, body, assignee and evidence:
`5e925b5d1d84`, `5f1ecbdd16bd`, `f3ae837ba6dd`, `dc1e8ca9c503`,
`759e75a52741`, `093a8fc1a2f3`, `a437de22974a`, `d73d4ea89087`,
`f37513c7b9c1`.

The mixed E4 parent remains in Sprint 562 for C/C++. Its C# and PowerShell
obligations are carried here explicitly: Linux C# 510 and PowerShell 1920
previously recorded modes require input-bound reuse or rerun, Windows C# 510
still requires a full run, and the full Windows PowerShell 400-case obligation
inventory must remain reconciled. The current 31-case safe batch yields 62
product modes and is a subset, not a replacement denominator. Counts describe
prior evidence or obligations and are not fresh acceptance claims.

## Execution

1. Finish the already running read-only batch and independently adjudicate all
   native/run/compiled captures against source and provider identities.
2. Complete Windows C# provisioning/launch controls and the full corpus.
3. Resolve PowerShell source-version, timeout, fixture, provider and context
   obligations individually. Review found no blanket disposable-machine
   requirement among the 74 previously labelled cases. Designated test hosts may
   run bounded reversible changes with observed state restoration.
4. Integrate fixes at their owning layer. Review and push subproject changes
   before umbrella pin bumps. Keep raw failures and exact frozen identities.
5. Run the final scoped gate with every required case accounted for and no
   unexplained skip, prerequisite gap or missing mode.

Old test binaries must receive explicit telemetry suppression in each child
process, with an owned spool as defense in depth; record the actual environment.
New test environments start smaller than and never exceed 20 GB. Shared-host
claims and private operational access details stay outside this public plan.

C++, Rust, Bash, Python, Go, TypeScript and the non-Windows shared corpus
infrastructure remain in Sprint 562. Its closure cannot imply acceptance of this
follow-up's deferred coverage. No release is authorized.
