# Sprint 627 M8: oss drafts — blocked by a GPU hang that rebooted the test host

Story `efd9bc004b56` (#188). This run had one scope: produce the two oss drafts
with `examples/film/film.bsh` on the Windows test host, then stop before the
commercial final. **Result: no draft completed.** Draft 01 rendered its song,
then hung in GPU VAE decode of its first 1280×720 portrait. A bounded
diagnostic probe of the same decode then coincided with an unexpected reboot
of the whole Windows host. Draft 02 was not started, and the storyboard was not
locked: `film lock` needs a successful draft. The commercial `--final` was not
attempted, and `--yes` was never passed. Cost was zero: no browser, api or
paid route ran, and nothing was downloaded.

## Venue

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

## Storyboard

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

## Draft 01

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

## Root cause: GPU VAE decode hang → TDR → host reboot

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

## Options (operator decision; not implemented)

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

## Remaining checks

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
