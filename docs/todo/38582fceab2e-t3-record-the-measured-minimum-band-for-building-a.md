---
id: 38582fceab2e
kind: doc
title: T3 record the measured minimum band for building and for operating in SKILL.md
seq: 798
status: done
priority: p1
labels:
    - shapeware
created: 2026-11-26T12:56:51.922341Z
assignee: claude-fable5.2
sprint: 731
sprint_id: 88c254ad-f4a4-5c54-a0fd-ac469894c684
sprint_title: 'The full shaping trip on form: spec to source to artifact to install to run and serve, with the band needed at each stage'
closed: 2026-11-26T15:15:27.445358Z
closed_by: claude-fable5.2
---

Two values with the bindings and the date: the lowest band observed to build form from its spec (Sprint 723 and T1) and the lowest observed to operate it (T2). State them as bounds where the ladder was not exhausted. Plan: umbrella docs/plan-reverse-sdlc-workflow.md, section 'The full trip' (operator 2026-11-26). Reuse agent-bench packs/spec2src with venue/, the Sprint 723 grader and kb runbook spec-to-source-drill. Operator review before start.

## Done (conductor, 2026-11-26)

Code inspected: bashy `examples/desk/form` (`SKILL.md`, `form.bsh`, `dag.md`), `server/form_test.go` (`TestSKILLMdMatchesEmbeddedFence`: `SKILL.md` must equal the skill fence inside `form.bsh`), `skills/managed_skills_test.go`.

Recorded in bashy `4b8cc25f`: a section "Measured bands (bounds, 2026-11-26)" in `SKILL.md` and, byte for byte, in the skill fence of `form.bsh`. Two bounds with bindings and date: building from the spec (Sprint 723 and T1) and operating a built folder (T2), each stated as a bound because no ladder was exhausted, and by binding name because registry bands are still seeded.

Decisions: the frontmatter `min-band: "L2"` is left as it is and called out in the section as declared, not measured; changing it is the owner's call. The `Band:` lines of the folder's own `dag.md` stay `unmeasured`: those steps run through bashy and were not what the drills ran. The measured lifecycle is the spec's `sh` lifecycle in the agent-bench fixture.

Gate on lane 2 at `4b8cc25f`: form server tests ok, `--bashsharp --check form.bsh` exit 0, `conform spec check` reports nothing, skills test ok, acceptance checks 11 PASS and 4 TBD (unchanged). Umbrella pin bumped.
