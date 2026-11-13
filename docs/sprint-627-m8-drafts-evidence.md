# Sprint 627 M8: two oss drafts and the storyboard lock

**Current state (2026-11-13 20:05Z):** by the operator's r3 review decision,
the storyboard is now locked on draft 09 (project `lanterns-r3`, render `04`),
with the same 15 shots and cut times. An English + Simplified Chinese revision
of that render is in the dev-box review directory; the song, images, cards,
shot assembly and cue times are byte-for-byte the render-04 sources. The
approved AWS lip-sync proof slice rendered and was returned from the sole
allocated fallback instance. Frame inspection found almost no mouth motion,
so the visible lip-sync bar remains open. See
[Render-04 lock and EN+ZH revision](#render-04-lock-and-enzh-revision-2026-11-13).

Story `efd9bc004b56` (#188). Scope: the two free oss drafts with
`examples/film/film.bsh` on the Windows test host, the storyboard lock, then
stop. The commercial `--final` stays an operator-approved remaining check.

## Render-04 lock and EN+ZH revision (2026-11-13)

The operator reviewed r3 render `04` and accepted its 15-shot list as the
contract. `film lock lanterns-r3 --draft 04` produced `lock.json` SHA-256
`3b8ea8cb3cf22e15d8397f3869fc9e33e339b9391975b261674e88ac1555c869`.
The locked storyboard SHA-256 is
`63163131961c38ce5e2eb04bbf87c10a36122737bcb6044532a0c2e2f342beae`;
the locked cut list and timing SHA-256 values are `3f971767...` and
`7d2c5dc4...`. This replaces the stale render-03 lock label below; that
earlier lock remains historical evidence.

For English above Simplified Chinese, `media subs` was run against render
`04`'s clean `assembly/joined.mp4`, retaining its exact audio and numbered
shots. The English `assembly/subs.srt` timestamps were copied exactly, and
the eight translated lines use those same timestamps. The revision required
14.40 s wall time, 626,700 KiB peak RSS, and cost USD 0. The `media` gate
passed (`ALL MEDIA TESTS PASSED`). The subtitle renderer now pins Noto
Sans SC under the SIL Open Font License, verifies its SHA-256 on first-use
cache fetch or from an offline staged copy, and declares that family for the
secondary `.ass` style (bashy `f31b01ee`). The offline missing-font path
fails with a prefetch command; a first-use fetch succeeded and passed the
hash check. Spot frames at 20 s and 28 s were inspected: both
lines and Chinese glyphs are visible, with shot numbers `05` and `10`.

| Review artifact (`.agents/s627-m8-review/draft04-en-zh/`, gitignored) | SHA-256 |
|---|---|
| `film.mp4` (81.139 s, 1280x720 H.264/AAC, soft subtitle track) | `65ee6d791c131a99f5b5fc4d798408ddbaf580630249192bb8dec203a50aa4fa` |
| `contact.png` (all 15 numbered shots) | `5cac56c9d27631ba72cabb12061bf791eb4640a6f10207ae8ed282c173dfa38b` |
| `looksheet.png` (Nova, Ash and four set/inserts) | `f20ac72b226134f5343dba4b3b87a8d35f70cbeb9d5b5a9d61a793e6b8c4797d` |
| `storyboard.md` (shot/time/lyric/prompt/seed) | `44762fc64aa104e0b1a41aad3886cfa7db5fc1a2df14414e665e3ae646836525` |
| `spot20.png` / `spot28.png` (glyph checks) | `9ba9b740...` / `12f54ba3...` |

WhisperX had recognised only one group of sung lyrics in render `04`, so
the eight cue times after that group remain extrapolations; the ±150 ms
vocal timing requirement is not verified. The proof slice will use a locked
close-up with clear vocals. No browser/API/vendor stage or commercial final
was run for this revision.

### AWS proof slice preflight (blocked before launch)

The approved source is locked close-up shot `04` (Ash). Its portrait is
`a8479458e036ca4d69e481458b1a77732b6c53342670012095157af764eb3a02`.
A 5.000 s, 16 kHz mono audio slice, with the shot's 2.609 s of vocals and
silence padding, has SHA-256
`df627c449bca4dc73ab933d57035f44abead5d8143f470f6942a0bc565521738`.
Both are in the gitignored review directory beside the film.

The vault automation user authenticated to AWS. `sprint-627-gpu-cap-50`
reported actual USD `0.36` against USD `50.0` (hard stop USD 40); there were
no running EC2 instances in the target region, and `g6e.xlarge` was offered.
The planned launch used one instance, tag `sprint=627` and
`instance-initiated-shutdown=terminate`. **It was not launched:**
`ec2:RunInstances --dry-run` returned `UnauthorizedOperation` because the
automation user has no identity-based `ec2:RunInstances` permission on
`instance/*`. `ec2:CreateKeyPair` and `ec2:CreateSecurityGroup` dry-runs
were also denied. No instance ID, proof clip or incremental AWS cost exists.
The conductor was notified. The next run needs an IAM grant and a clip-return
path before attempting the one allowed instance; this run did not consume an
instance attempt.

### AWS proof slice after the IAM grant (2026-11-13)

The operator's grant made the exact launch request pass EC2 `--dry-run`. Its
AMI came from the approved public SSM parameter. The request specified one
`g6e.xlarge` in the approved region, the approved instance profile, no key
pair, the default no-inbound security group, a 180 GB gp3 root volume, both
required tags on both the instance and volume, and
`instance-initiated-shutdown-behavior=terminate`. User-data had an 85-minute
shutdown timer and a 78-minute work bound, with an output/log upload and
shutdown on exit. Its script passed `bash -n` before launch. The input was
the locked shot `04` portrait and its exact 5.000 s audio slice, with the
SHA-256 values above. The script selected the published InfiniteTalk
single-person image-to-video route at 480p, with a single locked seed. This
route did **not** run because no instance was allocated.

At approximately 19:36Z, the **one** live `RunInstances` request returned
`InsufficientInstanceCapacity` (the AWS CLI reports two internal retries).
There is no instance ID or start/stop time, no generated clip and no clip
SHA-256. A subsequent `describe-instances` found no pending, running or
stopping instances. The budget's reported actual spend was USD 0.36 before
and after the request, below the USD 40 stop threshold. No second live
launch was attempted. The AWS resource claim was released and the conductor
was notified. The conductor then authorized a bounded capacity search.

The ignored dev-box review directory was restored from the Windows-side
staging path for this workspace, and local SHA-256 checks matched the prior
record: `film.mp4` `65ee6d79...aa4fa`, `contact.png` `5cac56c9...3dfa38b`,
`looksheet.png` `f20ac72b...6b8c4797d`, and `storyboard.md`
`44762fc6...836525`. The shot-04 portrait and audio hashes also match the
prior proof preflight. The commercial final remains deferred.

### Conductor-authorized capacity search and fallback launch

The conductor authorized one further launch sequence after the first capacity
error, with at most **one allocated instance**. All four default availability
zones returned `InsufficientInstanceCapacity` for `g6e.xlarge`; a regional
`g6.xlarge` request returned the same. The subsequent regional `g5.xlarge`
request succeeded at **2026-11-13 19:42:53Z**, allocating instance
`i-0f2e89d5d03f13090` (initial state `pending`). The launch kept the
approved role, no key pair, default no-inbound security group, termination
on in-guest shutdown, both required tags on instance and volume, and a
100 GB gp3 root volume. No other instance was allocated.

On the conductor's instruction, this attempt uses locked **shot 03**. The
shot-04 still has a microphone covering Ash's mouth; Nova's mouth is visible
above the microphone in shot 03, making lip sync review possible. A 5 s,
512×512 still-derived source video and an exact 5 s audio slice (1.956 s of
the shot's vocals plus silence) were staged. Their SHA-256 values are
`f3bf6247773bdf0df560b2eccf443da6cd56829665bf914b0845cee8c4686ae8`
and `e6bfa573d7dc8fb2437fc9b63546752cb6c8f08f538c8833b7c4f173e421138b`.

The fallback model is **TBDub Student**, source revision
`19e18e4ba8e2a19e6716cb38110ee2de1dae9bb3`, with its model and auxiliary
weights pinned to specific Hugging Face revisions. Its code and weights,
and the required X-Dub VAE and HuBERT weights, declare Apache-2.0. The
weight revisions are `TaoLiveAIGC/TBDub` `b1ac43698859d35bca475301834be9d6133472e2`,
`KlingTeam/X-Dub` `c84e9612b7c1160f06ea609882e12efd83cacbbe`, and
`facebook/hubert-large-ll60k` `ff022d095678a2995f3c49bab18a96a9e553f782`.
The [TBDub source](https://github.com/TaoLiveAIGC/TBDub/blob/19e18e4ba8e2a19e6716cb38110ee2de1dae9bb3/README.md)
documents its license, checkpoint list and measured memory use. The
published Student configuration uses two diffusion steps; the run requests
CPU offload at 512×512 and seed `7011`. It is visual dubbing of the locked
still as a 5 s video with the locked audio. The model's published measured
GPU peak with offload is about 15 GiB on a 512×512 workload. This was chosen
because InfiniteTalk's official low-VRAM mode does not document a 24 GB
configuration for this host and requires about 94 GB of downloads. The
user-data has an 85-minute shutdown timer, a 78-minute worker bound and
uploads the clip or failure logs before shutdown. At launch, budget reported
USD 0.36 actual against USD 50, below the USD 40 stop threshold.

### Proof result and visual check

The user-data returned `exit=0` at **2026-11-13 19:59:58Z**, 17 minutes
5 seconds after launch. The clip is 5.000 s, 125 frames at 512×512,
H.264 video with AAC audio. Its SHA-256, verified after download, is
`b2cc55d9e2d14bc5b6c52a631ed768a389e065c93cc21b164da5cf69fb091740`.
The ignored review directory contains `proof-shot03.mp4`, the render log,
status, and the kept `proof-frames.png` and `proof-mouth-grid.png` frame
grids alongside the draft review files. The model log confirms MediaPipe
landmarks on all 125 source frames, two Student clips at two steps each,
and a successful output save.

| Kept proof artifact | SHA-256 |
|---|---|
| `proof-shot03.mp4` | `b2cc55d9e2d14bc5b6c52a631ed768a389e065c93cc21b164da5cf69fb091740` |
| `proof-frames.png` | `ebaa17e0667ccf13d6612ff4e8acc1326a5b655fe4767c87fb8e7e8d29b35683` |
| `proof-mouth-grid.png` | `f7251bdd70c790d70de2859e3167c5e9a7b6a8fec4e9e0fb3bbfdf02af25ff9d` |
| `proof-run.log` / `proof-status.txt` | `38e3ccf79b855003a76a015982cddde663887a4a862a2305851ecb6dafa13920` / `3500ff521bbfbb2ad06397aed3993437eb0282f268de6b5ea25276e1ebeeccf8` |

The 0.2 s mouth-region frame grid shows Nova's lips staying essentially
in the same open shape across the 5 s output. The source is a held still;
its consecutive mouth-region luma difference is zero. The generated clip's
mean consecutive difference in that region is only 0.174 on an 8-bit
0–255 scale (maximum 0.710). Thus the generated clip demonstrates a real
audio-driven model run and output return, but **does not demonstrate visible
lip sync**. The 1.956 s source vocal segment is non-silent; the rest is
padding. No second model run was attempted under the one-instance limit.
The operator's side-by-side review against reference frames and the ±150 ms
subtitle check remain open.

User-data requested immediate shutdown after upload; the EC2 state became
`shutting-down`. A direct `terminate-instances` call was also made in that
state to enforce cleanup. **Terminated** state was verified by
2026-11-13 20:05:19Z; AWS did not expose a more precise stop timestamp in
`describe-instances`. The budget service still reported USD 0.36 actual
after the run (delayed billing). The AWS Price List API returned USD 1.006
per hour for Linux `g5.xlarge` in the target region; 17 minutes 5 seconds
to completed user-data and at most 22 minutes 26 seconds to the termination
verification bound imply approximately **USD 0.29–0.38 EC2 compute**, plus
a small gp3 storage charge. The reported actual charge must be reconciled
when billing updates. The hard stop at USD 40 was never approached.

**Result (retry after the GPU fix, 2026-11-13 14:30–15:45Z):** the GPU
verification passed, and two oss drafts rendered successfully (renders `05`
and `06`). The storyboard is locked against draft `06`. The Windows System
and WER logs show no Event 141, no TDR and no new WATCHDOG dump during the
run, and the host did not reboot. Cost was zero. No browser, api or vendor
stage ran, `--yes` was never passed, and no model weights were downloaded.
The first attempt, earlier the same day, was blocked; its record is kept
below under [First attempt](#first-attempt-blocked-by-a-gpu-hang-that-rebooted-the-host).

## Revision run (2026-11-13 16:30–17:50Z): product fixes, drafts 07–09, re-lock

Brief: operator review of drafts 05/06. Fix the two product defects (card
video too short; one overflowing single-language subtitle cue), then draft
07 as an animatic with a real shot list, shot numbers, a look sheet, a
contact sheet and a storyboard table, then re-lock. Zero spend: no browser,
api or vendor route, no `--yes`, no weights downloaded.

### Product changes (bashy, branch `agent/weave-issue-59-film`, not pushed)

| Commit | Change | Test |
|---|---|---|
| `9c078226` | `media cards` holds the card frame for the full `--secs` (`tpad` clone). Root cause, measured before the fix: a 3 s card had 30 decoded video frames (1 s) and 3.02 s of audio | `examples/media/test.sh` counts decoded frames (about 120 for two 2 s cards); all media tests pass |
| `328453f2` | film keeps the rod's transcript as `transcript.srt`. When its cue count differs from the lyrics, film times each lyric line to the sung words, using a semi-global word alignment and interpolating the lines it cannot match. `media subs` wraps each language to the frame (at most 46 columns) and sizes the banner to its rows | `TestDraftTimesLyricLinesToTranscript` (one merged cue → two bilingual cues) |
| `31178155` | animatic drafts: `stills[]`, `shots[].still` / `kind` / `beat`, `song.bpm` beat grid, `draft.still_size`, burned `SHOT NN \| KIND \| still` (draft default), plus `storyboard.md`, `contact.png` and `looksheet.png` written for every render; the lock keeps every still | `TestDraftAnimatic`; the whole film suite (6 tests) passes |

### Venue

- **Same host, same native image path:** the Windows test host was claimed
  for the run. The elevation cookie was refreshed from the vault with
  `bashy secret exec --stdin`; its value was never printed. The draft
  reused the previous run's isolated area. It used the same `bashy` binary
  (SHA-256 `1d37d58c…`), the same native ROCm 10 shim (`ae878007…`), the
  pinned `image-klein.py` (`24ebedae…`) and the same staged weights. The
  film/media/door tree is new: the `examples/` tar of bashy `31178155`,
  SHA-256 `49ce608f…f795f7`.
- **WSL reason (unchanged):** ACE-Step and WhisperX are staged only in the
  WSL distro, and both run on the CPU there. Only `image.generate` uses the
  GPU, and it runs in the native venv. One GPU job runs at a time: the
  ACE-Step server is stopped as soon as the song envelope lands.
- **GPU gate before work:** the System log had no new 41/6008/4101 events,
  and `LiveKernelReports\WATCHDOG` held only the two old dumps (the first
  attempt's and the previous day's). Two WER 1001 `LiveKernelEvent 141`
  records appeared at the moment of elevation. Both reference those old
  dump files and carry "Response: Not available". They are queued reports
  being re-submitted, not new TDRs.
- **Run 1 of draft 07 lost to a venue defect (environment):**
  `outpost ssh exec` caps a remote command at 1 minute by default (10 min
  server-side maximum). The keepalive client therefore ended after about
  55 s, and WSL powered the distro off 15 s later. That stopped the film
  unit during the song (journal: unit `Stopping` at 16:52:27Z, then
  `System Power Off`). A detached `cmd start` keepalive also failed to start
  from this session. Fix in the venue: a chain of overlapping keepalive
  sessions, each 10 minutes (`--timeout 10m`), a new one every 9 minutes,
  bounded to 90 minutes. The failed render is `lanterns-r3/drafts/01`
  (no manifest).

### Draft 07 (project `lanterns-r3`, render `02`)

Storyboard v3 (SHA-256 `63163131…c2e2f342beae`): the same characters,
bibles and seeds as before. It adds `song.bpm` 92, `draft.still_size`
768×432, four reusable stills (`harbor` wide set, `duet` two-shot,
`lanterns` and `boats` inserts) and a 15-shot list: 3 wide, 5 insert,
2 ensemble, 5 close.

| Measure | Value |
|---|---|
| Film wall time (`/usr/bin/time -v`) / manifest `elapsed` | 8:32.18 / 512 s, outcome success |
| Peak RSS | 4,009,196 KiB |
| `song` (song-acestep, oss, CPU) | 234 s |
| 6 stills at 768×432 (image-klein, oss, native GPU) | 46 + 28 + 28 + 29 + 28 + 28 s |
| `transcribe` (whisperx, oss, CPU) | 25 s |
| 15 still-pan shots + numbering + assembly + sheets | about 70 s |
| Render/runtime ratio | 512 s / 81.1 s ≈ 6.3 |
| `cost_classes` | `local`, `oss` (zero cost) |
| `film.mp4` | 1280×720 h264, AAC, mov_text. Video 81.133 s and audio 81.130 s: the card fix holds (draft 06 had 79.07 s video against 81.06 s audio) |

| Artifact | SHA-256 |
|---|---|
| `film.mp4` | `9619010b3ff74ea021b795db53ce1ea0ed3411ff2156b88ef7d5f56556f3bf8f` |
| `contact.png` (15 shots, numbered) | `5987b0ce011e2c71ec85965bef9202653e908079f36264752b8c5e2c66879f65` |
| `looksheet.png` (6 stills) | `f20ac72b226134f5343dba4b3b87a8d35f70cbeb9d5b5a9d61a793e6b8c4797d` |
| `storyboard.md` | `09ca26ecc918855053dbcfc8c3d802f1521eb49e346c47bae8b748d0463a9060` |
| `timing.srt` / `transcript.srt` | `1ca41c46…` / `03a16b8b…` |
| `manifest.json` | `eecd835aa69188bc4b8288ba89573a4ea9bf67e889a0bb3dbb307d40986182ff` |
| `lock.json` (re-lock on this render) | `decf1ba25a7afc0814dce517969c0d49a8bc752b595dc681c8696a4e56e375ce` |

**What draft 07 fixes:** a burned shot number and kind on every shot; a
varied shot list that reuses its stills; a look sheet and a numbered contact
sheet; a storyboard table; bilingual subtitle events, one per lyric line
(eight); card video at full length.

**Defect found in draft 07 (product, in `328453f2`):** WhisperX returned two
cues. The first ran from 0.031 s to 29.8 s but held only lines 5–6 ("Paper
boats…"): the VAD folded the intro into the segment. Interpolating by
character offset placed "Paper" at 0.03 s, which squeezed lyric lines 1–4
into 0–31 ms, so they are invisible. Because those line anchors were then not
increasing, `shot_bounds` fell back to even shots. The cuts are beat-snapped
(8 and 7 beats at 92 bpm), but the lengths are near-equal. Being fixed next
(draft 08).

### Draft 08 (project `lanterns-r3`, render `03`): timing fixed, storyboard re-locked

Commit `4c17f122` fixes the timing defect: a cue more than twice as long as
its words take to sing holds them at its end, and every cue lasts at least
1 s. `TestDraftTimingIntroFoldedIntoCue` covers it. Replayed on draft 07's
transcript, the fix gives eight visible lines of 3–3.5 s each. Draft 08 ran
the same storyboard and venue from the `examples/` tar of `4c17f122`
(SHA-256 `aee1957c…a2bcf`). The System and WER logs showed no new entries
after draft 07's GPU work.

| Measure | Value |
|---|---|
| Wall / manifest `elapsed` | 8:19.33 / 499 s, success; peak RSS 4,009,056 KiB |
| Stages | song 234 s (CPU); 6 stills 29–30 s each (native GPU); transcribe and assembly as in draft 07 |
| Render/runtime ratio | 499 / 81.1 ≈ 6.2; cost zero (`local`, `oss`) |
| Stills | byte-identical to draft 07 (same seeds, same native path) |
| Transcript | 2 cues (0.74–25.8 s "Hold the light and singing low"; 36.6–53.0 s, three lines) |
| Timing | 8 cues, one per lyric line, 09.06–53.02 s, 4.5–6.5 s each, all visible |
| Shot list | line anchors valid, so cuts land on the lyric lines, snapped to the 92 bpm grid. Shot lengths vary from 2.6 s to 9.1 s (4–14 beats) |
| `film.mp4` | 1280×720, video 81.133 s, audio 81.139 s, mov_text with 8 bilingual events |

| Artifact | SHA-256 |
|---|---|
| `film.mp4` | `97c2e19012444dd862972010157fcf902920985b0ee2f0eecda0c15dc62b9613` |
| `contact.png` | `1eda30e8604c026a330f923794a135a1039b05cfdeaad4496ebb54e21300352d` |
| `looksheet.png` | `f20ac72b226134f5343dba4b3b87a8d35f70cbeb9d5b5a9d61a793e6b8c4797d` (same stills as draft 07) |
| `storyboard.md` | `c6899a34beeabb06466281a81565a50a0b18c41d920a82e291b7172139ebbbb3` |
| `timing.srt` / `transcript.srt` / `subs.ass` | `e8306beb…` / `17310a3a…` / `5a6224bf…` |
| `manifest.json` | `d87cac791d61ff46d472f8c1fbc5bcefa7064a21196797981bca91b75dcbc447` |
| **`lock.json` (storyboard re-locked on draft 08)** | `8b3f45570f33ca27dc820fd647e01c48306cb1dd725e33ca9b763f119b0e7d8b` |

The lock holds `storyboard.json` `63163131…`, the six stills, `shots.tsv`
`6dd59ecd…` and `timing.srt` `e8306beb…`.

**Defect found in draft 08's burn-in (product, pre-existing in
`media subs`):** the burned banner shows only the second-language (Spanish)
line. `burn_cues` writes each banner cast with a trailing CRLF, in a
terminal exactly as tall as its lines. That last newline scrolls the first
line off the top. It was never visible before, because film fell back to
single-language subtitles (one line plus a blank row). The soft mov_text
track and `subs.ass` are bilingual and correct.

### Draft 09 (project `lanterns-r3`, render `04`): bilingual burn-in fixed

Commit `3695ae31` drops the trailing newline from the banner cast, and
`examples/media/test.sh` now requires a white first-language line in the
burned banner. Draft 09 ran from the `examples/` tar of `3695ae31`
(SHA-256 `89642673…f6bb185`); the GPU gate was again clean beforehand.

| Measure | Value |
|---|---|
| Wall / manifest `elapsed` | 8:09.96 / 489 s, success; zero cost (`local`, `oss`) |
| Stages | song 234 s; 6 stills 28–31 s each, byte-identical to drafts 07/08; transcribe 21 s |
| `film.mp4` | 1280×720, video 81.133 s, audio 81.139 s; burned banners show English (bold white) above Spanish (yellow), checked on a frame at 22.5 s |
| Transcript | **1 cue** (10.1–18.8 s, lyric lines 1–3); the new CPU song differs from draft 08's |
| Timing | 8 cues, but lines 4–8 have no transcript words. They are extrapolated at the singing rate, so all eight lines fall in 11.1–31.3 s, and the unanchored shots 13–15 run about 15 s each |

| Artifact | SHA-256 |
|---|---|
| `film.mp4` | `afac15ab4664097dfb2a5c27bc204dce968a8c839ad2f29fe0731083a4b4c074` |
| `contact.png` | `5cac56c9d27631ba72cabb12061bf791eb4640a6f10207ae8ed282c173dfa38b` |
| `storyboard.md` | `44762fc64aa104e0b1a41aad3886cfa7db5fc1a2df14414e665e3ae646836525` |
| `timing.srt` / `transcript.srt` / `manifest.json` | `7d2c5dc4…` / `9a13c915…` / `b5ac91d5…` |

### The lock: draft 08

Draft 08 has the timing and cut distribution that best fit its song: eight
lines spread across 9–53 s, and cuts from 2.6 s to 9.1 s on the lyric lines.
Its only defect is the burned-in banner, which a final re-renders with the
fixed media. The collect script first locked draft 09 automatically. The
storyboard was then re-locked on draft 08 with
`film lock lanterns-r3 --draft 03`, which reproduced `lock.json` byte for byte
(SHA-256 `8b3f45570f33ca27dc820fd647e01c48306cb1dd725e33ca9b763f119b0e7d8b`).
The operator can switch to draft 09 with `--draft 04`.

### Delivered for review (dev box, gitignored `.agents/s627-m8-review/`)

Each `draftNN/` holds `film.mp4`, `contact.png`, `looksheet.png`,
`storyboard.md`, `timing.srt`, `transcript.srt`, `subs.ass`, `shots.tsv`,
`manifest.json` and the run's `stderr.log`, `timeline.txt` and `time.txt`.
`draft08/lock.json` is the lock. The files were fetched from a Windows-side
staging directory with `outpost ssh sftp get`, and the SHA-256 values on
the dev box match the host's.

| Path | SHA-256 |
|---|---|
| `draft07/film.mp4` | `9619010b…6bf3bf8f` |
| `draft08/film.mp4` | `97c2e190…dcbc9613` |
| `draft09/film.mp4` | `afac15ab…4b4c074` |
| `draft0{7,8,9}/looksheet.png` | `f20ac72b…c4797d` (identical) |
| `draft07/contact.png` / `draft08/contact.png` / `draft09/contact.png` | `5987b0ce…` / `1eda30e8…` / `5cac56c9…` |
| `draft08/lock.json` | `8b3f4557…7e7d8b` |

### Cleanup

- **Host state:** the System and WER logs held no new entries during the
  whole run. The newest System 41/6008 events are still those of 11:05Z,
  and the newest WER 1001 records are the two re-submissions seen at
  elevation. `LiveKernelReports\WATCHDOG` still holds only the two old
  dumps. The boot time is unchanged (12:06:36Z). No native python process
  remained, and no film unit was loaded.
- **Keepalive:** the chain was stopped. Its last WSL client outlived its
  ssh session, so it was killed by its recorded pid; a check then found no
  keepalive process left. The host claim was released.
- **Not touched:** WSL configuration and the default podman machine.
- **A wrong claim, corrected:** a different Windows resource was claimed
  briefly by mistake and released before any use; it was never contacted.

### Remaining checks

- **Operator review** of drafts 07–09 and acceptance of the lock on draft
  08; side-by-side against the reference frames.
- **Subtitle timing ±150 ms: not met.** WhisperX without an alignment model
  recognises only part of the sung lyrics (2, 2 and 1 cues in drafts
  07/08/09). Lines it misses are interpolated or extrapolated. Meeting the
  bar needs word-level timing: either the WhisperX alignment model (staging
  it needs approval) or a corrected timing via `film lock --timing`.
- **The beat grid is the requested tempo** (`song.bpm` 92, downbeat at 0).
  It is not detected from the audio.
- **The ACE-Step song on the CPU is not reproducible with the same seed**,
  so each draft has a new song, transcript and timing. The stills are
  reproducible.
- **AWS lip-sync proof slice (step D): not started.** The run time went
  into the defects above. It needs a relaunch under the AWS rules.
- **Commercial final:** operator-approved; never run with `--yes` by an
  agent.
- **bashy branch** `agent/weave-issue-59-film` (`9c078226`, `328453f2`,
  `31178155`, `4c17f122`, `3695ae31`) is committed in the workspace's bashy
  checkout and is **not pushed**. The umbrella pin names `3695ae31`, so the
  conductor must push that branch before the pin is usable.

## Step 1: native ROCm 10 GPU verification

The operator installed AMD driver 26.10.1 and a native ROCm 10 venv on the
Windows test host (torch `2.13.0+rocm10.0.0`, HIP `7.15.26333`, device
gfx1151, 107 GB visible). The venv carries no diffusers stack and no pip. The
agent installed `diffusers==0.43.0` (the rod's pin), `transformers 5.23.0`,
`accelerate 1.15.0` and `safetensors 0.8.0` with their pure dependencies into a
separate target directory beside the native image-klein cache, using
`bashy uv pip install --target` with an overrides file so that torch, numpy,
pillow and the venv's other packages were not reinstalled. The operator's venv
was not modified. This fetched about 25 MB of Python packages from PyPI in
27 s; it fetched no model weights.

One verification job ran alone on the GPU. It made the same calls as
`image-klein.py` (bf16, model CPU offload, 4 steps, guidance 1.0) against the
staged native FLUX.2 klein-4B snapshot, at 1280×720:

| Measure | Value |
|---|---|
| Total (imports, load, generate, save) | 47.2 s |
| Generate (denoise + VAE decode) | 30.1 s |
| VAE decode alone | 12.5 s |
| CUDA max allocated / reserved | 8,449,714,176 / 9,017,753,600 bytes |
| Process peak working set | 17,926,537,216 bytes |
| PNG | 1280×720, SHA-256 `12526c6fc618411b2b3e1c5444eb242da1d4a8f3b6ec04321cb4d00c48d61146` |

The event log was read through `wevtutil` before the job (14:31Z) and after
it. There were no System 41/6008/4101 events, no WER `LiveKernelEvent` and no
new `LiveKernelReports` dump. The newest 141 reports are from 12:06–12:12Z,
around the operator's driver install and reboot, before this run. **Step 1
passed**; the conductor was told on the board.

## Venue for the drafts

- **Host claim:** the Windows test host was claimed for the whole run and
  released after cleanup. Access used the direct outpost ssh form; the
  expired elevation cookie was refreshed from the vault with
  `bashy secret exec --stdin`, value never printed.
- **Native first:** the only GPU stage, `image.generate`, ran in the native
  ROCm 10 venv. `song` and `transcribe` have staged environments and weights
  only in the WSL `Ubuntu-24.04` distro (from M2b); re-staging them natively
  would mean copying and re-provisioning both rods, so film itself ran in WSL.
  Neither of those stages uses the GPU: the ACE-Step env is
  `torch 2.10.0+cu128`, which sees no GPU in WSL and runs on the CPU (this was
  also true in the first attempt), and WhisperX runs with `--device cpu`.
- **Image bridge (venue adapter):** `IMAGE_KLEIN_PY` pointed at a small WSL
  shim. It runs the pinned, unmodified `image-klein.py` (SHA-256
  `24ebedae360e0ab96bd975d7c611735200b42cc0cfa549011a85a5c3a4572169`, the same
  file at the current pin) in the native venv through WSL interop, then copies
  the PNG into the rod's output directory. Shim SHA-256
  `ae8780076365a2896956b592cc5a4c96b288006a19738473f214a33a3bf47883`.
- **One GPU job at a time:** film runs its stages sequentially, and the run
  script stops the ACE-Step server as soon as the song envelope lands, before
  the portraits start.
- **Candidate:** the first attempt's linux/amd64 `bashy` built from bashy
  `b1208d71` (SHA-256
  `1d37d58ceaae7fd63c84d6449b99cd7ece55966732ab9135fda1aeaa14d1a394`) and its
  `examples/` tar (SHA-256
  `03408e4692fb5b91be95a213946ee50dbe0d45e3041ab8acf9de7c96baa56922`). This is
  reuse of unchanged inputs, not a fresh build: the ten bashy commits between
  `b1208d71` and the current pin `6ecfa8c9` touch nothing under
  `examples/film`, `examples/oss-rods`, `examples/media` or
  `examples/defaults`.
- **Isolation:** the first attempt's isolated `BASHY_HOME`, command ring and
  offline flags were reused. A new project directory held a copy of the
  storyboard, SHA-256 unchanged
  (`484ff3f588df5c749e6f6e4b1137307f1ebe2b3952e64cb63d3bc2fb6797e737`).
- **Not touched:** no WSL configuration, the default podman machine (running
  throughout) and no dev-box model. QA ran off (`--no-qa`): the QA door's
  default provider is not an oss route.

## Render attempts and their root causes

Film numbers renders by the first free directory, so the two drafts are `05`
and `06`. Renders `01`–`04` failed, each from a venue or run-script defect.
Each was root-caused before the next run and fixed in the venue. No product
code was changed.

| Render | Outcome | Root cause (class) | Fix |
|---|---|---|---|
| 01 | stopped 7 s into the song | WSL stops an idle distro about 15 s after its last `wsl.exe` client exits; a transient systemd unit is not a client, so systemd shut the unit down with the distro (journal: distro boot at launch, unit `Stopping` 15 s later). **Environment** | A bounded keepalive client (`sleep 9000`, pid recorded, stopped by that pid at the end) started detached with `cmd start`; no WSL config change |
| 02 | `portrait: unbound variable` at shot 2 | WSL interop relays stdin to the Windows process. The shim's native call drained the stdin of film's `while read … < <(jq …)` character loop, so `portrait:ash` never ran. **Venue (agent shim)** | `</dev/null` on the interop call |
| 03 | song refused: no offline server | The run script's watcher looked at the newest existing render (`02`, which had a song envelope) and stopped the server before the new song stage. **Venue (agent run script)** | Watch only the render id that film's `next_id` will take |
| 04 | `media cut failed`: `PowerShell runtime unavailable: neither $XDG_CACHE_HOME nor $HOME are defined` | A transient systemd unit has no `HOME`; media's PowerShell fence finds its cached runtime from it. **Environment** | Set `HOME` to the WSL root user's home in the run script (runtime already cached; nothing downloaded) |
| **05** | **success** | — | — |
| **06** | **success** | — | — |

## Drafts

Both drafts used the same storyboard, `film draft <project> --no-qa`, route
oss, and the same staged weights.

| | Draft 05 | Draft 06 |
|---|---|---|
| Film wall time (`/usr/bin/time -v`) | 6:07.26 | 5:58.58 |
| Manifest `elapsed` / outcome | 367 s / success | 358 s / success |
| Peak RSS (largest process) | 4,011,824 KiB | 4,014,028 KiB |
| ACE-Step server start → healthy (before the film) | 10 s | 5 s |
| `song` (song-acestep, oss, CPU) | 240 s | 234 s |
| `portrait:nova` (image-klein, oss, native GPU) | 34 s | 37 s |
| `portrait:ash` (image-klein, oss, native GPU) | 33 s | 34 s |
| `transcribe` (transcribe-whisperx, oss, CPU) | 19 s | 14 s |
| `animate:1`–`8` | oss `unavailable` → labelled still-image slow pan, about 14 s for all 8 | same, about 15 s |
| Assembly (cut, mux, cards, subs, burn) | about 23 s | about 25 s |
| `cost_classes` | `local`, `oss` | `local`, `oss` |
| `degraded` outputs | 8 ("still image with a slow pan") | 8 |
| `film.mp4` | 1280×720 h264 30 fps, AAC, mov_text; 81.055 s; 11,296,931 bytes | same format; 81.055 s; 11,669,040 bytes |

The animate door listed only `animate-kling` (route browser),
`animate-replicate` (route api) and `replicate-media:animate` (route vendor)
as unavailable under `--route oss`; none of them ran.

### Artifacts (SHA-256)

| Artifact | Draft 05 | Draft 06 |
|---|---|---|
| `film.mp4` | `836ee4486a57e783902a4f5053e993648e8046b1ce569e888fa459f990e35ac6` | `36517202f5a8aa565518a6d96ba0c0d4d2a7fe354c3cf398711f6f1e089d16e3` |
| `song/song.wav` (75.000 s, 14,400,078 bytes) | `ca7d900a93e8d362ddfe24b6f7da2ca3d34e3400ffaee2d3267c86ed008f996d` | `4a3e6d8ac1c21c8adaf6459a396e94de560f9a2e9cfb5f665a4b232f124fac82` |
| `portraits/nova.png` | `96c33d79ea7788adac2ab38943c8ead88a8ecbdbd481b0ba442248b1c26c8e3e` | identical |
| `portraits/ash.png` | `01ef3a087f3f25f56bd5544336311464260331ad027cfcd0f2a5e50e2d0ba0e3` | identical |
| `timing.srt` | `67b56c8a8361158a17c3c727b9b8a8d27b9f4534da0caffb24c691b1955861a6` | `2707db09adef81f97b801ca3232dffd537cc2ca5f0cc2eb6d51b627aaa57ab34` |
| `subs.ass` | `0d2937ba97ca8c0a04f7062050dc4d40db88ccee417f3c9f89ffac801b38e1a5` | `d8189e7b6eeb4c33bef437950923b7d3bfead9197399b874bc51bcdd4fb79f55` |
| `shots.tsv` | `579eac16a03b30778240e6242f3beecfbd4b22839673ea4f1dc51e0f920792e9` | identical |
| `manifest.json` (`bashy-film-render-v1`) | `748b7d80a01a07fc1c3b055a59ae2f2967e612f32b7cf8e543edc19b5a869866` | `e9de74a686ff0b212be546c8df221e92ac978b912c76a19f4fccf7fb3af76aa7` |
| Frame grid (12 frames, 4×3, kept on the host) | `45ceb7e81e8906948a11a6bbdd2f605670caec1a76327e51d4f97462b46e5eaf` | `7feafcaeebc147b52c9adf8d58a7f4580f271e151f01caa35a8407b4ed97c9f2` |

Media files stay in the host work area and are not committed here.

**Reproducibility.** With identical inputs the native portraits are
byte-identical across both drafts and the earlier failed renders. The
ACE-Step song is not: the same seed (627) on the CPU gave different audio, so
the transcript, timing and film differ between drafts.

### What the drafts show

The frame grids and spot frames were checked by the agent; the operator
side-by-side is still a remaining check.

- **Characters and stills:** both original fictional characters stay
  consistent across their four shots each, on one shared stage set, at
  1280×720. The shots are still images with a slow push-in, and the manifest
  labels each one "still image with a slow pan".
- **Cards:** the title card ("characters are fictional") and the end card
  ("AI-generated: song, voices, images and video are synthetic" and "Nova
  Quill and Ash Marlowe are fictional characters") are present.
- **Card video is short (product defect, M6 `media cards`):** each 3 s card
  carries 1.0 s of video against 3.02 s of audio, so the film's video stream
  is 79.07 s against 81.06 s of audio, and players hold the last frame. Cause:
  `media cards` renders each card from an agg GIF made with
  `--last-frame-duration 1 --no-loop`. ffmpeg's `-t $secs` only trims, so the
  video ends at 1 s while `anullsrc` fills the audio to `--secs`
  (`examples/media/media.bsh`, `card_gif` and `cmd_cards`). Not fixed here;
  a small follow-up repair should hold the last frame (for example
  `tpad=stop_mode=clone`, or a looped GIF input).
- **Subtitles do not meet the bar:** WhisperX (`--no_align`) returned a
  single cue per draft, 39.4–58.8 s in draft 05 and 26.9–39.9 s in draft 06.
  Each cue merges several lyric lines and mis-hears words ("sing it loud",
  "strangers after love"). The cue count (1) does not match the eight
  translation lines, so film fell back to **single-language** subtitles as
  designed. The single long line also runs past both frame edges. The ±150 ms
  bar and the bilingual requirement are therefore not met by these drafts.

## Storyboard lock

`film lock <project> --draft 06` succeeded. `lock.json`
(`bashy-film-lock-v1`, SHA-256
`6b768891345873b9ac9bca02a495a4b853f71c409129fc5c0388c18adf767ccb`) records:

| Locked file | SHA-256 |
|---|---|
| `storyboard.json` | `484ff3f588df5c749e6f6e4b1137307f1ebe2b3952e64cb63d3bc2fb6797e737` |
| `portraits/nova.png` | `96c33d79ea7788adac2ab38943c8ead88a8ecbdbd481b0ba442248b1c26c8e3e` |
| `portraits/ash.png` | `01ef3a087f3f25f56bd5544336311464260331ad027cfcd0f2a5e50e2d0ba0e3` |
| `shots.tsv` | `579eac16a03b30778240e6242f3beecfbd4b22839673ea4f1dc51e0f920792e9` |
| `timing.srt` (draft 06's single cue) | `2707db09adef81f97b801ca3232dffd537cc2ca5f0cc2eb6d51b627aaa57ab34` |
| `duration` | `dc1aec72f0dd044d4430a9c92acc02313cd9e5d741a1fbaa4910dca02f08a6c4` |

The lock was taken without `--timing`, so it carries the draft's coarse
timing. Re-running `film lock --timing FILE` with a corrected eight-cue timing
replaces it, and the final uses the corrected timing.

## Cleanup

The keepalive was stopped by its recorded pid, and no film, rod or native
python process and no transient unit remained. The temporary scheduled task
(created in a launch attempt that never ran, since the user was not logged on
interactively) was deleted. The local cookie keep-alive was stopped and the
host claim released. At 15:45Z the host had the same boot time (12:06:36Z)
and no System, WER or dump entries since 14:30Z.

## Remaining checks

- **Operator side-by-side** of the drafts against the reference frames
  (portraits and frame grids are kept on the host), and acceptance of the
  locked storyboard.
- **Subtitle timing:** a corrected eight-cue timing within ±150 ms, then
  `film lock --timing`. That gives bilingual subtitles. The WhisperX alignment
  model is not staged, and staging it needs approval.
- **Lip sync:** not possible on still-pan drafts. No oss `animate` route
  exists (M3/M3b). The native ROCm 10 stack now decodes FLUX at 1280×720, so
  re-probing Wan2.2 on it is a candidate follow-up.
- **`media cards` short video** (above): a small product repair, follow-up.
- **Narrate:** `film.bsh` has no narrate stage, so `narrate-local` is unused
  by a film draft.
- **Commercial final:** operator-approved; never run with `--yes` by an
  agent. Not attempted.

## First attempt: blocked by a GPU hang that rebooted the host

Kept as recorded. The operator later chose the GPU fix (driver plus native
ROCm 10 venv); the options and remaining checks below are superseded by the
retry above.

Story `efd9bc004b56` (#188). This run had one scope: produce the two oss drafts
with `examples/film/film.bsh` on the Windows test host, then stop before the
commercial final. **Result: no draft completed.** Draft 01 rendered its song,
then hung in GPU VAE decode of its first 1280×720 portrait. A bounded
diagnostic probe of the same decode then coincided with an unexpected reboot
of the whole Windows host. Draft 02 was not started, and the storyboard was not
locked: `film lock` needs a successful draft. The commercial `--final` was not
attempted, and `--yes` was never passed. Cost was zero: no browser, api or
paid route ran, and nothing was downloaded.

### Venue

- **Host claim:** the Windows test host (AMD Strix Halo iGPU gfx1151) was
  held for all host work and released after a read-only
  artifact sweep.
- **Native first:** native Windows has `bashy.exe`, but no `uv`, `ffmpeg` or
  `jq`, and `python` is only the Store alias. No native GPU inference
  environment is staged. Same finding as M2b-image, narrate and transcribe.
- **Why WSL:** the run used the `Ubuntu-24.04` WSL distro, because the staged
  rod environments and caches from M2b already live there. Model weights were
  not copied again.
- **Not touched:** no WSL configuration, no default podman machine, no AWS
  resource and no dev-box model. Access used the direct outpost ssh form. The
  expired elevation cookie was refreshed from the vault non-interactively
  (value not printed).
- **Candidate:** a linux/amd64 `bashy` built from the pinned bashy `b1208d71`
  with `GOWORK=off CGO_ENABLED=0 go build ./cmd/bashy` (SHA-256
  `1d37d58ceaae7fd63c84d6449b99cd7ece55966732ab9135fda1aeaa14d1a394`). It was
  plain `go build`, not `scripts/go-product.sh`, so the startup-signal overlay
  is absent; film does not depend on it. The pinned `examples/` tree went to
  an isolated host area as a `git archive` tar (SHA-256
  `03408e4692fb5b91be95a213946ee50dbe0d45e3041ab8acf9de7c96baa56922`).
- **Isolation:** `BASHY_HOME` and `BASHY_COMMANDS_DIR` pointed at a fresh area
  and ring. `bashy-defaults apply` from the pin populated the ring, and
  `bashy media doctor` registered ffmpeg, ffprobe and agg. `film doctor`
  reported ready.
- **Offline weights:** `BASHY_OSS_CACHE` reused the M2b staged cache.
  `IMAGE_KLEIN_MODEL_DIR` pointed at the M2b native FLUX.2 klein-4B snapshot
  through `/mnt/c`. The Hub, Transformers, Datasets, ModelScope, uv and pip
  offline flags were set.
- **oss selection** (`bashy providers select ROLE --route oss`):
  - `song` → `song-acestep`
  - `image.generate` → `image-klein`
  - `transcribe` → `transcribe-whisperx`
  - `animate` → none. Only `animate-kling` (browser), `animate-replicate`
    (api) and `replicate-media` (vendor) exist, so film would have used its
    labelled still-image slow-pan fallback.
- **QA off:** drafts were run with `--no-qa`. The QA door's default provider
  (agy) is not an oss route, and this run was scoped to zero cost.

### Storyboard

The storyboard is *Lanterns on the Harbor*, SHA-256
`484ff3f588df5c749e6f6e4b1137307f1ebe2b3952e64cb63d3bc2fb6797e737`.

- **Characters:** two original fictional characters, Nova Quill and Ash
  Marlowe. Each has its own bible and seed, and they share one stage set.
- **Lyrics and subtitles:** eight English lyric lines, with Spanish
  translations line for line for the bilingual subtitles.
- **Shots:** eight shots, anchored to the lyric lines.
- **Format:** 1280×720. A 75 s song plus 3 s title and end cards gives about
  81 s.
- **Disclaimer:** the end card reads "AI-generated: song, voices, images and
  video are synthetic" and names both characters as fictional.

The file stays in the host work area and is not committed here.

### Draft 01

`film draft <project> --no-qa` ran under a transient systemd unit inside WSL.
A detached `nohup setsid` launch did not survive the ssh session's end, and
nothing was created, so the unit was used instead.

| Stage | Result | Time |
|---|---|---|
| ACE-Step server start (`song-acestep.bsh --serve`) | healthy | 15 s (10:32:08Z–10:32:23Z) |
| `song` (song-acestep, oss) | **success**: 75.000 s, PCM s16le, 48 kHz, stereo, 14,400,078 bytes, SHA-256 `0526ca870d8c42d028fd0f52e87a2f4212145b92566e298fae0ff7b754bf4fc5` | 240 s (envelope) |
| `portrait:nova` (image-klein, oss, 1280×720) | **error**: denoise 4/4 in 49 s, then GPU VAE decode never returned; process stopped by the agent at 10:56:46Z | 1,222 s (envelope) |
| transcribe, portrait:ash, shots, assembly | not reached | — |

The render manifest is `bashy-film-render-v1`. It records `outcome: error`,
`elapsed: 1464`, `cost_classes: ["oss"]` and both stage envelopes.
`/usr/bin/time -v` measured 24:24.70 wall time and 16,938,800 KiB peak RSS;
the film exited with status 1.

The ACE-Step server log has 200 lines (SHA-256
`010cefecdfc88c0d1522598b6fc9e895bf3d4a15c33e22357256c124c8c0808a`). It
contains zero `Downloading`, `snapshot_download`, `fetching` or `transfer`
lines; there are only the two `[Model Download] ... already exists` checks,
and `Default LM Init: False`. The film stderr has SHA-256
`47454930b296ab2c419a03e6355a88f6cecd42b67bdf79b8416c82ece0ecaa42` and also
contains zero download markers.

**Memory pressure (fixed in the venue for this run).** WSL sees about 31 GB.
The ACE-Step server, at 13.3 GB RSS, stays resident after the song stage,
while FLUX needs about 17 GB. With both loaded, available memory was about
1 GB. The agent stopped the server at 10:44:08Z, after the song had finished,
which left 14 GB available. Film needs the song server only for its first
stage. This is a venue issue, not a film defect, but a host runner should stop
the server after `song`.

### Root cause: GPU VAE decode hang → TDR → host reboot

| Time (UTC) | Event |
|---|---|
| ~10:41 | `portrait:nova` denoise finishes (4/4 in 49 s); VAE decode starts at 1280×720 |
| 10:42:07–10:42:11 | Windows `LiveKernelEvent` **141** (video engine timeout) ×3; `WATCHDOG-20261113-0242.dmp` written |
| 10:42–10:56 | the image process keeps three CPU threads at 100 %. Windows GPU engine counters show **no** engine above 0.5 % utilisation, so the process is spinning on a GPU context the TDR reset |
| 10:44:13 | later recorded by event 6008 as the time of the "unexpected" previous shutdown (the last system-time heartbeat) |
| 10:56:46 | agent stops the image process; film records the failed render |
| 10:57:35 | bounded diagnostic probe starts: the same pipeline and weights with `vae.enable_tiling()` at 1280×720, capped by `timeout 420` (script SHA-256 `0cf1e283ca9e8fc3b9287d2662723bc7d752ba9d29a541b1a24e9a86995d73c0`) |
| ~11:01:21 | probe denoise ends at t+225.7 s; tiled VAE decode starts and never logs completion |
| 11:05:17 | **Windows boots** after an unclean shutdown (Kernel-Power 41; event 6008) |
| 11:05:35, 11:08:30 | further `LiveKernelEvent 141` reports filed after boot |
| 11:10:30 | the host enters Modern Standby; every WSL distro, including `podman-machine-default`, is Stopped |

**Classification: environment.** This is a GPU driver/runtime hang on
gfx1151 under WSL ROCm (`HSA_ENABLE_DXG_DETECTION=1`, PyTorch
`2.9.1+rocm7.2.1`), triggered by FLUX.2 klein VAE decode at 1280×720.

- **Prior decodes:** the same rod decoded 512×512 successfully in M2b-image.
  M3b recorded the same class of stall in Wan2.2's VAE decode.
- **Tiling:** tiled decode did not avoid the hang. The probe ran after an
  unrecovered TDR, which the agent had not yet seen in the event log, so this
  is not a clean negative for tiling.
- **Earlier TDRs:** the host logged `LiveKernelEvent 141` TDRs at 03:06Z,
  04:08Z and 08:47Z, during earlier sprint GPU runs. Those did not reboot it.
  The only unexpected shutdown in the 36 h window is the one above.
- **Cause of the reboot:** the agent's GPU work caused it. The second decode
  hit a GPU that was already hung.

The operator was notified on the message board (announce, plus a direct
message) that the podman machine was stopped by the reboot and was not touched
by this run.

### Options (operator decision; not implemented)

Each option crosses this run's scope or needs approval.

1. **Portrait size decoupled from video size.** Generate portraits at the
   512×512 size known to decode, and have film's still-pan crop to 16:9
   instead of stretching. This changes `film.bsh` (a portrait size, and an
   aspect-correct `still_pan`). The output is still 1280×720; the source
   resolution is lower.
2. **CPU VAE decode in `image-klein.py`.** Decode the latents on the CPU,
   with the transformer staying on the GPU. This is a small rod change; decode
   will be slower but avoids the GPU path that hangs.
3. **Another image host.** The plan names Mac hosts for light image models.
   This needs a claimed Mac that is not the operator's workstation, with
   FLUX.2 klein staged.
4. **Driver-level investigation** of the gfx1151 WSL TDR (the WATCHDOG dump
   is on the host) before any further GPU decode on this host.

Until one is chosen, no further GPU work should run on this host for M8.

### Remaining checks

- Two oss drafts (wall time, per-stage time, artifacts and SHA-256, zero
  cost), then `film lock`.
- The bars in the plan: lip sync (not possible on still-pan), subtitles within
  ±150 ms, and the operator side-by-side with a kept frame grid.
- The subtitles carry an extra risk. WhisperX runs with `--no_align`, and the
  M2b transcript put nine sentences in one 28.9 s segment. Film builds
  bilingual subtitles only when the cue count equals the translation line
  count; otherwise it falls back to a single language. Expect coarse timing
  and possibly single-language subtitles until the timing is corrected with
  `film lock --timing`.
- **Narrate:** `film.bsh` has no narrate stage, so the `narrate-local` rod is
  unused by a film draft.
- **Final:** the commercial `--final` remains operator-approved; it is never
  run with `--yes` by an agent.
