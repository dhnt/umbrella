# SDLC for hardware, firmware and software, mapped to the shapeware lifecycle

*Reference and information only, written 2026-11-28. It is not a plan or a standard and changes no rule. It compares the usual hardware, firmware and software lifecycles, especially QA, test and acceptance, and maps them to the shapeware workflow (`shapeware-workflow-standard.md`, `shapeware-spec-v0.md`). Those two documents are authoritative. Where this note disagrees with them, they win.*

## Part 1. A typical SDLC: hardware, firmware and software


### Lifecycle stages side by side
| Stage | Hardware | Firmware | Software |
|---|---|---|---|
| Requirements | Electrical, mechanical, thermal and regulatory specs; cost and BOM targets | HW/SW interface spec, timing, memory budget, boot and update needs | User stories, features, NFRs |
| Design | Schematic, PCB layout, mechanical CAD, DFM/DFT reviews | Architecture on target MCU/SoC, drivers, RTOS, bootloader | Architecture, APIs, data model |
| Build | Prototype spins (EVT → DVT → PVT), weeks per spin, costly | Cross-compile and flash; depends on board availability | Compile/deploy in minutes, cheap |
| Iteration cost | Very high: a respin costs $$ and weeks | Medium: reflash, but a bricked device or field update is risky | Low: patch and redeploy |
| Release | Mass production (MP) after PVT sign-off | Signed image, locked version per HW revision | Continuous or train releases |
| Maintenance | ECOs, revision letters, recalls | OTA/field updates, must stay compatible with old HW revisions | Patches, feature updates |

### QA / test / acceptance: where they differ most
| Aspect | Hardware | Firmware | Software |
|---|---|---|---|
| Unit-level test | Board bring-up, power rails, signal integrity | Unit tests on host plus HIL (hardware-in-the-loop) | Unit tests in CI |
| Integration | Subsystem and system test on prototypes | HW/FW integration on real boards, timing and interrupts | Integration and e2e in staging |
| Verification focus | Physics: thermal, EMI/EMC, shock and vibration, drop, lifetime (HALT/HASS) | Real-time behavior, power states, fault recovery, boot and update robustness | Functional correctness, performance, security |
| Regulatory | FCC/CE, UL/IEC safety, RoHS: external labs, mandatory | Often bound by the HW cert; safety standards (IEC 61508, ISO 26262, DO-178C) when relevant | Usually none; domain-specific ones (HIPAA, SOC 2, PCI) |
| Production test | Every unit: ICT, functional test, burn-in | Factory provisioning and flashing, per-unit self-test | None (identical copies) |
| Acceptance | Gate reviews per phase (EVT/DVT/PVT exit criteria), first-article inspection, customer qualification | Release qualification on every supported HW revision; sign-off with the HW team | UAT or product owner sign-off, often automated; feature flags or canary |
| Defects after release | Recall, rework, or a firmware workaround | Field update; a failed update can brick devices | Hotfix in hours |
| Automation level | Low to medium (fixtures, test jigs) | Medium (HIL rigs, flashing farms) | High (CI/CD) |

### Takeaway
- Hardware: get it right before you build. Testing is physical, statistical and per unit, and acceptance is phase-gated and regulatory.
- Firmware: the bridge between the two. Testing needs real or simulated hardware, and acceptance is per HW revision because updates are risky.
- Software: build, test and fix cheaply in a loop. Acceptance is continuous and mostly automated.


## Part 2. Mapped to the shapeware lifecycle

Sources: umbrella `docs/shapeware-workflow-standard.md` (v0 draft, Sprint 731) and `docs/shapeware-spec-v0.md`. The **State** column copies the standard's own proven / partly proven / not yet proven marks.

### The one-line framing
In shapeware **the spec folder is the product** and every build is a fresh *manufacture* by an agent that may not behave the same way twice. So shapeware **iterates like software** (minutes, cheap, repeatable) but **accepts like hardware**: the same contract judges every build and every install, the way each unit coming off a line gets tested.

### Lifecycle stages mapped
| Shapeware stage (`dag.md` step) | Hardware analog | Firmware analog | Software analog | State |
|---|---|---|---|---|
| 1. Instructions → spec. Open questions; **gate 1: owner review** | Requirements and spec freeze; design review sign-off | HW/SW interface spec sign-off | PRD / story grooming | partly proven |
| 2. Compile the spec (`conform spec check`, no model, seconds) | DRC/ERC: design-rule check on the schematic and layout | Static analysis, MISRA lint | Lint, type check | partly proven (lint only) |
| 3. Spec → source (builder agent in a work copy) | Build-to-print from a technical data package by a contract manufacturer | Port to a board from the interface spec | Implementation | proven on `form` |
| 4. Source → artifact (`dag build`) | Prototype spin / assembly | Cross-compile, sign the image | Compile / package | proven on `form` |
| 5. End-to-end test (`dag test`: the contract, by name) | DVT verification against the spec | HIL test on the board | CI e2e suite | proven on `form` |
| 6. Install (`dag install`). **Gate 2: consent** to the effect cap | Site installation permit; regulatory / safety approval to operate | Provisioning onto a device; per-revision qualification | Deploy approval / change ticket | partly proven (no consent gate) |
| 7. Run / serve. The **contract runs again on the installed app** | Production test on every unit; site acceptance test (SAT) | Factory self-test after flashing | Smoke test in production | proven on `form` |
| 8. Field shaping (work copy → `candidate.bsh` → owner keeps it) | ECO through a change control board; **errata sheet** | OTA update with backward-compat checks | Hotfix / feature PR | partly proven |

### QA / test / acceptance mapped
| Concern | Shapeware mechanism | Closest analog | Why it's that analog |
|---|---|---|---|
| Who writes the tests | The **contract** (`CONTRACT.md` assertions) *is* the spec; there is no separate suite | HW: the spec and its test procedure ship as one package | The acceptance criteria travel with the design, not with the code |
| Test that the test is good | Spec certified only when the reference passes 3/3 with nothing noisy **and every seeded mutant is killed** | HW: golden unit plus fault injection to validate the test fixture | Proves the judge catches real defects, not just the happy path |
| Qualifying who builds | **Hidden cases** + bands L1–L5 per binding, measured by drills | HW: supplier qualification / first-article inspection with independent tests | The builder is untrusted until measured; the claim is per binding, n=3, a bound |
| Environment matrix | **Venue** written into the spec (OS, toolchain, network, what's absent) | FW: supported hardware-revision matrix | A pass counts only on the stated venue; venue faults are fixed in the venue, never scored |
| No-regression | Work copy may only *add* features/examples; installed folder's `candidate.bsh` grades it; `dag.md` and checks are protected | FW: must still pass on all old HW revisions; HW: form-fit-function rule for an ECO | The installed checker grades the change, and the change can't weaken it |
| Failure analysis | Every non-pass classified: **spec gap / agent defect / judge defect / venue fault** | HW failure analysis: design / manufacturing / test fixture / environment | Classification is what improves the spec, and the same four buckets exist in hardware |
| Maturity / release level | **Release class**, computed and fail closed: blocked → requirements release → verified with tbd → verified with known issues → verified | HW: EVT → DVT → PVT → MP | A maturity label you compute from evidence, never write by hand |
| Known defects shipped | `known issues` in SKILL.md (open / workaround), with `resolves:` features | Silicon **errata** with workarounds | You ship with documented defects plus a workaround, never hidden ones |
| Final acceptance | Two **human gates** only: owner approves *what the app is* (gate 1); the person answering for the machine consents *that it runs here* (gate 2). Owner keeps or rejects candidates | HW: phase-gate reviews + customer qualification; SW: UAT / PO sign-off | Everything between the two gates is mechanical (the `conform` judge, no model) |

### Where shapeware differs from all three
- **The builder is nondeterministic.** Neither hardware, firmware nor software assumes the *compiler* might produce a different program each time. Shapeware does, so it re-judges every build and qualifies builders. That's closer to manufacturing yield than to software CI.
- **Iteration stays software-cheap.** A "respin" is a new work copy in minutes, not a board spin in weeks. Effort is in Fibonacci points, with minutes per point measured per band.
- **The spec can ship alone.** A *requirements release* (spec with no verified feature) is a valid release: the user's agent builds it behind the consent gate. Hardware's nearest equivalent is shipping a build-to-print package; firmware and software have none.
- **No separate QA phase.** The same contract runs at stage 5 (fresh build) and stage 7 (installed app). There's no hand-off to a QA team. QA is the judge plus failure classification.

### Gaps, read against the analogs (from the standard's own state marks)
- Gate 2 (consent) exists only in parts (effect cap, computed class). Hardware would not run a site install without it.
- Spec author and judge roles are **unmeasured**; the conductor filled both. In hardware that would be an unqualified supplier writing its own test fixture.
- No dry run after the lint (stage 2), so DRC exists but simulation doesn't yet.
- Bands on `form` are per-binding bounds, not measured L values.
- The field loop (issues in, shaped fixes out) is not built, so there's no ECO pipeline yet.
