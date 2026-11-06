---
id: 9aed6f2424ad
kind: task
title: Recover Linux test guest readiness after backing storage exhaustion
seq: 21
status: done
priority: p1
created: 2026-11-05T20:08:37.473611Z
assignee: codex-gpt6-sol
sprint: 562
sprint_id: 2e8945a5-d199-539c-aaea-321a738ab9df
sprint_title: 'Fence corpora: complete required coverage and repair current failures'
closed: 2026-11-06T04:06:51.661781Z
closed_by: codex-gpt6-sol
---

The telemetry repair is live and storage is bounded on the Windows test host, but the existing Linux test guest was stopped after read-only filesystem and I/O errors interrupted full C++ and Rust runs. Inspect host/guest metadata and available recovery routes without modifying the original virtual disk or restarting unrelated containers. Preserve all source, unique corpus receipts and original guest disk. Prepare a concrete recovery plan and rollback/backup evidence before any filesystem repair; prefer validation on a preserved copy. Re-establish a healthy isolated Linux test route, recover interrupted raw evidence and exact identities, then resume only the outstanding corpus work with unchanged denominators. Never count interrupted runs as passing; do not widen deadlines or discard unique fixtures. Record temporary recovery storage and owned cleanup. This follows the emergency telemetry prerequisite and serves the sprint primary Bash# goal.

Latest operator direction (supersedes full-image preservation/recovery): discard the failed test environment and rerun rather than copying the574GB disk merely for incomplete test logs. The redundant completed recovery clone was deleted after exact identity/closed-handle checks. Preserve unrelated work and existing containers; do not blindly delete an original shared distro before ownership/source safety is established. Fresh validation must not wait for whole-guest restoration. New owned Linux test storage has a kernel-enforced8GB initial cap and must never exceed20GB; expansion needs measured requirement, not host capacity. Suppress test telemetry explicitly in every child, monitor space, retain only useful proof artifacts and repair disposable compiler-cache retention. Interrupted cases never count as PASS.

Readiness verification (2026-11-06): fresh isolated Linux route is operational. Fixed backing and block device are exactly 12,000,000,000 bytes; kernel allocation control returned ENOSPC, and autogrow is disabled. Initial 8 GB grew only after measured compiler/source demand; the operator maximum remains 20 GB. Container root is read-only; temporary files, shared memory, compiler caches and per-case evidence bind to the capped filesystem. Child telemetry is explicitly disabled. All required frozen source/corpus/provider inputs are recovered and hash-bound locally. A fresh serial Bash run completed 86/86 PASS, zero skips/timeouts, with all 738 fixture files unchanged; suite SHA256 1f4e1ccc0d6e655684ec077e8a259b1e8af4cb89c863dfbe3047d65ba7597b67 and tested lean artifact 1ff2473c82299ff466e59b651906c201ea0c21e230c6fce679b164f4cb90eb3e. Rust readiness independently verified successful child reaping with no signals or leak-check exemptions. Interrupted C++/Rust results remain unaccepted and full final-artifact gates remain separate open stories. Redundant recovery clone cleanup reclaimed 573,675,929,600 bytes; unrelated container state and the original stopped guest are preserved pending ownership-safe disposal. No filesystem repair or whole-image recovery is required for ongoing validation.
