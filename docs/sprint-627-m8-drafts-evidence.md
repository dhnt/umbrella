# Sprint 627 M8: two oss drafts and the storyboard lock

Story `efd9bc004b56` (#188). Scope: the two free oss drafts with
`examples/film/film.bsh` on the Windows test host, the storyboard lock, then
stop. The commercial `--final` stays an operator-approved remaining check.

**Result (retry after the GPU fix, 2026-11-13 14:30–15:45Z):** the GPU
verification passed, and two oss drafts rendered successfully (renders `05`
and `06`). The storyboard is locked against draft `06`. The Windows System
and WER logs show no Event 141, no TDR and no new WATCHDOG dump during the
run, and the host did not reboot. Cost was zero. No browser, api or vendor
stage ran, `--yes` was never passed, and no model weights were downloaded.
The first attempt, earlier the same day, was blocked; its record is kept
below under [First attempt](#first-attempt-blocked-by-a-gpu-hang-that-rebooted-the-host).

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
