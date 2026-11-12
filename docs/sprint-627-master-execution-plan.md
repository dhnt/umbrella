# Sprint 627 master execution plan — music-video showcase (`film`)

Status: planning only. The sprint is filed in the backlog, has not started,
and depends on Sprint 626 (the generic service door).

## Outcome

`bashy film` produces a 60–90 s music video in the same quality class as a
public commercial AI music video used as the reference. Drafts are made
locally with open-source models, as many times as the user wants. The final
is rendered on commercial services from the same locked storyboard.

## Reference

The reference is a public social-media AI music video, analysed on 2026-11-12:
- 5:08 at 1280×720, H.264 video with AAC stereo audio. The platform re-encoded
  it, so the original metadata is gone.
- Photoreal portraits in one consistent stage set.
- A lip-synced singing performance per character, plus an ensemble shot.
- Burned-in bilingual subtitles, name cards, title and end cards, and a
  watermark.

The author declared the stack as a song generator (Suno), a chat-assistant
image generator, and an image-to-performance video generator (Kling). Nothing
in the file confirms the tools: there are no vendor watermarks or C2PA data.

## Pipeline

Each stage is a service from Sprint 626, chained by `film.bsh`:

| Stage | Role | Providers |
|---|---|---|
| Concept, lyrics, shot list, character bible | `plan` | claude |
| Song with vocals | `song` | oss / browser / api |
| Character portraits, one consistent set | `image.generate`, `image.edit` | oss / codex image / browser / api |
| Lip-synced performance clips | `animate` | oss / browser / api |
| Lyric timing | `transcribe` | WhisperX (oss), muse |
| Second subtitle language | print | claude, agy, or Qwen3 (oss) |
| Assembly: cut, cards, bilingual subtitles, watermark, mux | `media cards`, `media subs`, `media cut` | ffmpeg via `bashy/examples/media/media.bsh` |
| Quality check | `video.understand` | agy |

## Economic flow

Every generative stage has three routes behind one interface:

- **`route=oss`** runs permissive open-weight models on our own hardware. It
  is the default for drafts and allows unlimited iterations.
- **`route=browser`** drives the vendor web app in the operator's logged-in
  browser (`bashy browser --mode live` with `bashy claim chrome-browser`). It
  uses existing subscriptions.
- **`route=api`** calls the paid vendor API with a key held in the vault,
  through the toolcmd `mode: http` runner.

`film --final` re-renders only the generative stages on a commercial route,
reusing the locked storyboard (lyrics, shot list, character bible, timing).
Any spending or posting step declares its effects and requires `--yes`.
Build the routes in this order: oss, then browser, then api.

## Open-source picks (permissive for commercial use)

Re-verify every LICENSE file at provisioning time. This extends the Sprint
382 baseline in `bashy/docs/local-multimodal-model-hardware.md`.

| Stage | Pick | License | Hardware | Gap vs commercial |
|---|---|---|---|---|
| song | ACE-Step 1.5 | MIT | Mac (MLX/MPS); 4–20 GB | small to medium (vocals) |
| image | Qwen-Image-2512 plus Qwen-Image-Edit-2511; light: Z-Image Turbo, FLUX.2 klein-4B | Apache-2.0 | 24 GB (FP8/GGUF); light models run on a Mac | small |
| animate | InfiniteTalk or Wan2.2-S2V-14B; Wan2.2 TI2V-5B for B-roll | Apache-2.0 | 24 GB NVIDIA | large |
| narrate | Chatterbox; Kokoro-82M | MIT; Apache-2.0 | Mac or CPU | small to medium |
| transcribe | WhisperX on Whisper large-v3; mlx-whisper | BSD-2; MIT | Mac | about equal |
| translate | Qwen3 via ollama | Apache-2.0 | Mac | about equal |

**Excluded as not permissive:** FLUX.2 dev and klein-9B, SD3.5, Hunyuan
models, LTX-2, YuE2, Sonic, F5-TTS, IndexTTS2, Higgs Audio, MusicGen and
Orpheus.

**GPL tools:** ComfyUI is GPL. Do not vendor it; drive the models through
diffusers or each model's own server instead.

**Weights** download on first use, never at install time, and only after a
disk-headroom preflight passes. Sprint 382 failed at exactly this point on a
97%-full host.

## Venue

Mac hosts can run song, light image models, narrate, transcribe and
translate. `animate` with `route=oss` needs a 24 GB NVIDIA host, and the fleet
has no confirmed one. Until there is one, `animate` drafts use the browser
route or a still image with a slow pan, and the output says so. These heavy
media runs never go on the operator's primary workstation.

## Stories and vendor lanes

| ID | Story | Lane | Depends |
|---|---|---|---|
| M1 | Rod contract for `song` / `image` / `animate` / `narrate`: inputs, outputs, envelope, effects; register at bootstrap | claude-opus5.5 | 626 F |
| M2 | oss rods: ACE-Step, Qwen-Image or light model, Chatterbox/Kokoro, WhisperX; provisioning plus disk preflight | codex-gpt6-sol | M1 |
| M3 | oss `animate`: InfiniteTalk or Wan2.2-S2V on a 24 GB NVIDIA host, or a recorded blocker | codex-gpt6-sol | M1, host |
| M4 | browser rods: song, animate, image web apps via `bashy browser --mode live` | agy-gemini3.8-flash | M1 |
| M5 | api rods: paid song, animate, image APIs via `mode: http` with vault keys | codex-gpt6-sol | M1 |
| M6 | `media cards`, `media subs` (bilingual `.ass`), `media cut` (cut to the beat) | muse-spark1.3 | — |
| M7 | `film.bsh`: storyboard lock, draft (oss) and `--final` (commercial), agy QA review | claude-opus5.5 | M2, M4/M5, M6 |
| M8 | Showcase run: 60–90 s, original fictional characters, AI-generated disclaimer; two oss drafts and one commercial final, with cost and time recorded | claude-opus5.5 (conductor) | M7 |

## Verification

The M8 demo must meet these bars:
- 1280×720 or better.
- Lip sync visibly in time; subtitles within ±150 ms.
- An operator side-by-side check against the reference frames, with a sample
  frame grid kept as evidence.

Real-person likeness is out of scope for the shipped example.
