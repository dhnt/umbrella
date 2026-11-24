# Sprint 675 POSIX certification preparation and readiness

Checked 2026-11-24. **Status: preparation reviewed; external submission NO-GO.** The S575 and separately authorized post-repair S675 runs are engineering evidence. Neither is the uninterrupted formal single-journal test report. Applicant manual decisions have been recorded for the S675 candidate, but required external rulings, registrant/license confirmation, formal evidence and fee authorization remain open. No certification or release claim follows from this document.

## Candidate, scope and evidence

| Evidence | S575 baseline | S675 post-repair engineering candidate |
| --- | --- | --- |
| Source | `posix-baseline/s575-2026-11-19`; umbrella `295cd32d032fb94dda2c032c26109032bd5af4b8`, Bash `7855c2f038f2c8ccba1baf8478b0b8fb3dcd8cd2`, Coreutils `c656935287fa4bff4920b08e41156d13d7c5702f`, shared CLI `4141cc07cfdc6c0a838825485ef41e54a55fa9a0` | Umbrella `33d0c714250e5807f94b443f4788a742b55a9fbb`, Bashy `532a316aaa8865984841cc7cab1a23491cbb6a0d`, Bash/sh `5c52281f7136ecef072e75e34156e11b5652a931`, Bashsharp `08fabb33d718db648a80478fc992c13105eed122`, Coreutils `f9833f726fac84def34e8ec521e6d50c6bf7e467`; shared CLI unchanged |
| Build | Go 1.27.2; static split-role artifacts; builder image digest `sha256:c99fcb7318b23ed06b3775368ee3966795a5498fb9a050a92d6f21866680b7ba`; manifest SHA256 `6dde18df80537f6c4be1596222683d69c8a98c660a117474844d1530f1891138` | Go 1.27.4; builder image digest `sha256:1171628e07d3e7490458d9b0b484e689fee56c4a739e3f8ad577188eceece2ff`; manifest SHA256 `1991e820972b3857363ac84879a88b984385267d4e8280f408e7b65911866328`; Coreutils payload SHA256 `484e4318ee03bbf6e333d3446eafbcfb9e300c100a055a90bdab62d5d5dc08c3` |
| Private evidence | Sealed full-run archive SHA256 `63cd77b944361e999652210f30c39d5f74e5785921b6df2384b6d7c721405fe1` | Sealed full-run archive SHA256 `d324b62fcdb8f5fd05369f580298a4b7ca0447aa8eab64cc0e1d1cb3df4e9bf6` |
| Full diagnostic results | 117 journals; 9,337 execution TPs; 9,270 PASS-group; 4 FAIL; 54 UNRESOLVED; 9 INSPECT; zero UNINITIATED, UNREPORTED or caps | Same 117 journals and raw outcome counts. Independent D16 comparison of all 9,337 result identities and raw codes: PASS, zero changes and zero regressions. Only `df:7` live disk figures differ. |

The declared base provider scope is **102: 92 Go utility providers, 10 shell commands, zero external utility providers**. Fourteen optional targets retain their declared applicability. Native build and test helpers have separate infrastructure roles. The public [S575 baseline](../bashy/docs/s575-posix-engineering-baseline.md) describes the original engineering run. Exact fixture, harness and raw-journal identities remain in the private certification evidence store.

R1 established the 67-row identity ledger; R2, R3 and R4 refreshed the existing authority questions; R5 prepared nine individually reviewed inspection packets; R6 identified one S575 Coreutils defect and 66 no-repair-needed dispositions. Under separate authorization, R8 repaired the `stty:32` prevalidation defect by exact matching of the 17 delay-mode names. Focused failing-first tests, the full Coreutils suite, both Bash 86/86 gates, a suite-free PTY probe and the S675 full engineering run passed. The patched `-cread` reaches `TCSETS`; the Linux PTY still preserves CREAD, so `stty:32` remains a raw INSPECT. The old S575 result and cause remain historical facts.

## Result disposition ledger

The following 67 `target:tp` identities are from the raw S575 ledger. The S675 D16 comparison found the same identities and raw codes. Each derived disposition sits beside, and does not replace, the raw verdict. The two `test:84` and `leftbrack:84` results are distinct identities in one journal.

| Identity | Raw verdict in both runs | Derived disposition / decision status |
| --- | --- | --- |
| `awk:543` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `bc_03:48` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cat:25` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cd:41` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `chgrp:53` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `chmod:57` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `chown:56` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cksum_03:15` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cmp:26` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `comm:32` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cp:97` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `cut:43` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `dd:61` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `df:7` | INSPECT | Portable form checked; S675 applicant manual ACCEPT; raw 102 unchanged |
| `df:30` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `diff:64` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `du:43` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `ed_14:47` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `env:27` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `file:64` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `find:142` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `fold:46` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `grep:139` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `head:41` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `iconv:28` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `join:47` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `leftbrack:84` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `ln:59` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `locale:17` | INSPECT | Charmap wording O1 reviewed; S675 applicant manual ACCEPT; raw 102 unchanged |
| `localedef:52` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `ls:107` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `m4:101` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `man:4` | UNRESOLVED | Strict command-count precondition; authority ruling pending; no product repair supported |
| `mkdir:60` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `mkfifo:48` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `more:130` | FAIL | Optional target; helper failure without inner pager trace; authority scope/ruling pending; no repair proven |
| `more:132` | FAIL | Optional target; helper failure without inner pager trace; authority scope/ruling pending; no repair proven |
| `more:133` | FAIL | Optional target; helper failure without inner pager trace; authority scope/ruling pending; no repair proven |
| `more:134` | FAIL | Optional target; helper failure without inner pager trace; authority scope/ruling pending; no repair proven |
| `mv:87` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `od:64` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `paste:43` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `pax:242` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `pr:56` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `pwd:17` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `rm:56` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `rmdir:30` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `sed:272` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `sh_03:163` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `sort:86` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `split:42` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `stty:13` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `stty:17` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `stty:18` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `stty:19` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `stty:32` | INSPECT | S575 product defect repaired separately in R8; S675 applicant manual ACCEPT for fixed candidate only; raw 102 unchanged |
| `stty:85` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `stty:86` | INSPECT | PTY driver limitation; S675 applicant manual ACCEPT; raw 102 unchanged |
| `tail:48` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `test:84` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `touch:63` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `tsort:20` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `uniq:58` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `uudecode:34` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `uuencode:25` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `wc:32` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |
| `xargs:44` | UNRESOLVED | Setup blocked by empty-target symlink; authority ruling pending; no product repair supported |

For the 53 empty-target symlink UNRESOLVED results, setup stops before utility assertions because the Linux venue refuses an empty target; the product passes the target to the operating system unchanged. `man:4` stops on its strict greater-than-109 precondition at 109. Four optional `more` purposes report an outer locale-helper failure, but no retained inner pager trace proves a product fault. These 58 results require version-applicable authority treatment. Existing sent questions have acknowledgments only; the R2-R4 refresh packets are prepared and unsent. There is **no substantive ruling on record** for them, and an acknowledgment is not a waiver.

The nine S675 code-102 INSPECT results have nine individual **applicant-side ACCEPT decisions**, recorded by the delegated supervisor on 2026-11-24 after independent review of the new journals. Six `stty` results use measured PTY driver limitations; `stty:32` uses that rationale only for the fixed S675 candidate; `df:7` has a correct portable header and checked numeric rows; `locale:17` resolves the charmap wording judgment O1 for the S675 output. These are manual dispositions, not official rulings or raw-code edits. The S575 inspection packets remain criteria and historical evidence; no S575 manual PASS is claimed.

## Current official program check

The following public sources were fetched on **2026-11-24**. This is a check of the published program, not verification of the local countersigned license or a product registration.

| Requirement | Official source and checked rule | Remaining action |
| --- | --- | --- |
| Authorized kit | [Test suite catalogue](https://posix.opengroup.org/testsuites.html), Current Test Suites: **VSC-PCTS2016 3.1** is authorized for 1003.1-2016 Shell and Utilities; only current authorized releases are valid for formal registration. The catalogue offers a twelve-month no-fee OSS kit route. | Registrant confirms actual licensed kit version and license status. |
| Product profile and scope | [1003.1-2016 Shell and Utilities Product Standard](https://posix.opengroup.org/docs/su-2016.html), Description, Conformance Requirements and Indicators of Compliance: mandatory requirements and current authorized VSC reports. [Product Standards index](https://posix.opengroup.org/prodstandards.html) lists the matching questionnaire. | Confirm configuration and scored applicability of optional targets. |
| Conformance statement | [PX2_2016 questionnaire](https://posix.opengroup.org/docs/PX2_2016.html), opening instructions and §1: product/version/supplier, exact hardware/software environment, suite/version and optional features; statement is part of registration and becomes public. Platform-specific registration uses one report; a binary-compatible family requires two distinct reports. | Registrant fixes product, version, supplier, claim level and environment. |
| Non-pass handling | [Certification Guide issue 1.06](https://posix.opengroup.org/certification_guide.html) §§3.7.1-3.7.2 and [Certification Policy revision 1.1](https://posix.opengroup.org/docs/POSIX_Certification_Policy_v1.1.pdf) §2.4: FAIL and UNRESOLVED need valid, granted, version-applicable Interpretation, Test Suite Deficiency or Certification System Deficiency references; INSPECT needs manual PASS resolution. | Obtain substantive authority rulings for the 58; retain the nine applicant manual decisions for the selected formal journal. |
| Formal journal | Guide §§3.7.1-3.7.2 requires full TET output from an uninterrupted applicable VSC-PCTS run. | Qualify and execute the existing single-`tcc -ep` formal driver with `vrpt`; the 117-journal engineering runs do not satisfy this step. |
| Kit terms | [OSS time-limited agreement v1.4.OSS](https://posix.opengroup.org/docs/VSC-PCTS2016-TestSuite-TimeLimited-License-Agreement-OSS-v1.4.pdf), notes, §1 and Schedule 1: authorized signatory, product and site, countersignature before effect, nontransferable use, twelve months from access notice, limits on copying and public result/pass claims, no trademark grant. | Operator confirms actual countersigned agreement, specified product/site, dates and any written publication consent. |
| Registration and fees | Guide §§3.4-3.8 and [POSIX FAQ](https://posix.opengroup.org/posixfaq.html): product registration, conformance statement, journal upload, result resolution and payment; processing waits for fee receipt. Kit access and certification fee are separate. | Operator authorizes any application, transmission and fee separately. |
| Operating systems | [PX2_2016 Environment Specification](https://posix.opengroup.org/docs/PX2_2016.html) and [FAQ](https://posix.opengroup.org/posixfaq.html) define a precise environment or binary-compatible family. They do not publish a blanket Linux/macOS/Windows approval list. | The measured evidence covers one Linux x86_64 venue. Any macOS or Windows claim needs a separately defined eligible configuration and evidence. |

## Remaining blockers and owners

| Blocker | Owner by role | Next action |
| --- | --- | --- |
| 53 symlink, `man:4`, four `more` raw non-passes; optional scoring | Certification authority via operator-controlled channel; operator chooses claim scope | Obtain and record granted, version-applicable rulings or official report treatment. Review the prepared R2-R4 packet updates before any separately authorized send. |
| Actual kit license and claim identity | Operator/registrant | Verify countersigned license, term, product/site, kit 3.1, selected product/version, platform claim and PX2_2016 answers. |
| Formal single-journal evidence | Operator-authorized licensed run manager | Qualify the frozen candidate and run one uninterrupted formal `tcc -ep`/`vrpt` campaign; preserve full TET journal and hashes. |
| Manual resolution entry | Operator/registrant | Carry the nine documented S675 applicant decisions onto the selected formal journal, checking its exact outputs and identities; do not assume decisions transfer to new bytes or venue. |
| Registration, payment and certification grant | Operator/registrant; certification authority | Authorize submission and fee separately, then await audit and grant before any certification or trademark claim. |

No external send, fee, source edit, tag, release or official claim is authorized by R7.
