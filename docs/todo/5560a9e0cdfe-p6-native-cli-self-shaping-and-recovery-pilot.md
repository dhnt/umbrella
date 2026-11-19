---
id: 5560a9e0cdfe
kind: test
title: P6 Native CLI self-shaping and recovery pilot
seq: 136
status: wontfix
priority: p1
labels:
    - shaping
    - dogfood
    - shelved
created: 2026-11-11T20:10:51.048656Z
sprint: 617
sprint_id: 08692c1f-daed-5ad4-831e-c24feb4b9ac8
sprint_title: 'Bashy dogfooding: software shaping from local installations through staging to upstream'
closed: 2026-11-19T14:21:28.627489Z
---

Depends on P5. Deliver one real small bashy CLI improvement through source-backed self-shaping, side-slot preview/activation, real usage, submission and staging/upstream promotion. Coordinate existing H5/H7 and installed dogfood stories; preserve their original acceptance and unresolved failures.

Acceptance: full relevant lifecycle runs on native macOS, native Windows and Linux from one frozen source candidate; a second isolated installation receives the source change, verifies/builds locally, activates explicitly and rolls back exactly. Failed builds/tests and interrupted candidate runs never activate. A broken shaped CLI cannot disable retained status/undo/restore. Other installations remain unchanged. Existing web shaping regression remains green. Close carried stories only against their full original criteria. Then make shaping mandatory for covered CLI changes.

## Review disposition: shelved (2026-11-19)

Operator requested review only and authorized closure or shelving of this roadmap. P6 native CLI side-slot activation and exact retained undo/restore exist in bashy/internal/agentos/shape_slot.go and yoke/pkg/shape/slot/slot.go. Full one-candidate three-native-OS plus second-installation CLI pilot is not proven; H5/H7/installed dogfood remain open. Shelve the additional pilot/mandatory CLI development cutover, not accepted as fully qualified.

Review source: Bashy e53cc3a395511e1a1e87874ecf74117368976434; Yoke f4a89e592ced1b7e715184f7833eef174e7215de. Inspection and existing committed evidence only; no fresh product tests. Closed as wontfix to shelve the remaining roadmap, not accepted as delivered. Original requirements preserved above. No coding, workers, installation, promotion, migration or release. Sprint 618 and carried qualification stories unchanged; official release/POSIX gates remain binding.
