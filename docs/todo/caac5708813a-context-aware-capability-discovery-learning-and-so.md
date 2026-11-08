---
id: caac5708813a
kind: feature
title: Context-aware capability discovery, learning and software shaping
seq: 52
status: todo
priority: p1
created: 2026-11-08T09:52:36.734034Z
sprint: 595
sprint_id: a8bd6c0a-b86c-5928-84b5-21c8bb2865b2
sprint_title: Yoke CLI consistency and coherence
---

Goal: make bashy all you need through rod-not-fish capability acquisition and software shaping, with minimal third-party harness setup. Connect existing install-agent, skill export, inspection, command/adapter registration, skill learn and shape mechanisms through consistent machine-readable responses.
Behavior: discover existing capabilities before suggesting extensions. For repeatedly used scripts/features, recommend bashy command add to retain a reusable discoverable capability. For a missing feature, recommend registration with a concrete implementation path when no existing command/skill fits. For unfitting behavior, invalid interfaces or reproducible implementation errors, recommend bashy shape with reproduction, expected behavior and evidence. Correct usage mistakes, missing prerequisites and transient failures before suggesting software changes. Introduce registration and shaping briefly at the point of need, with contextual deduplicated advice rather than generic promotion.
Extension order: existing composition, declarative configuration/adapter, execution-verified learned skill, then shaped implementation. Recommendations carry reason, evidence, next command and argument vector, prerequisites, verification method and authorization requirements; distinguish executable steps from proposals. Within existing authority the harness can acquire/repair support, verify, retry and retain it. Preserve approval/activation boundaries, bounded retries, rollback and released recovery controls.
Acceptance: repeated-script and missing-feature cases produce actionable registration guidance; existing capabilities are reused; unfitting behavior and defects produce actionable shaping guidance; routine errors receive corrective guidance. Verify structured output and unchanged exit semantics, human hints on stderr, suppression/deduplication, active advice policy inspection, verified capability discoverability with provenance/applicability, failed-verification nonactivation and rollback. Account for current host-kind incident-repair limitations and released shell/script entry points. Reuse existing mechanisms, not a parallel extension framework.
Naming: bashy command add is a verified frontend alias of bashy commands add; bare in-shell command retains POSIX behavior. Implementation is future sprint work; this session only records requirements.
