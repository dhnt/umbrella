# Media, PDF, Video, and Desk Collaboration Reference

Reference inventory and verification guide for `bashy`'s **PDF**, **drawing/whiteboard/charts**, **image**, **audio**, **video**, and **Desk team-collaboration** capabilities across `bashy`, `yoke`, and `filebrowser`. Designed to support authoring technical reports/books, producing demo videos, and running human-agent team workflows (including the Presidential Superintelligence Competition).

---

## 1. Architectural Layers

Media and document tooling in the umbrella is organized across three layers:

1. **Layer 1 — In-Process Pure-Go Userland (`yoke/pkg/lens`, `filebrowser/img`)**
   - Zero external binary dependencies.
   - `yoke/pkg/lens` extracts Markdown and plain text from `.pdf`, `.docx`, `.xlsx`, `.html`, `.csv`/`.tsv`, `.sqlite`, and renders `bashy-graph-v1` streams to Graphviz `dot` and `mermaid`.
   - `filebrowser/img` (`fbembed` in `yoke/pkg/webconsole/panel_files.go`) resizes, fits, and fills raster images (`jpeg`, `png`, `gif`, `tiff`, `bmp`) and parses EXIF orientation and thumbnails in pure Go.

2. **Layer 2 — Desk Collaboration Suite & Skill-Tier Pipelines (`bashy/examples/*`, `bashy transcribe`)**
   - Loopback/LAN web apps and CLI pipelines sharing one Desk kit (`bashy/examples/desk/kit`) and one CLI/HTTP action contract (`add | open | show | set | list | share | close | export`; see `bashy/docs/plan-desk-cli-api-conformance.md` and `bashy/docs/plan-desk-family-look.md`).
   - Includes `notepad`, `viewer`, `chart`, `form`, `replyform`, `whiteboard`, `tutor`, `record`, `video`, `vlog`, and the built-in `bashy transcribe` 4-stage pipeline (`bashy/internal/agentos/transcribe.go`).

3. **Layer 3 — Managed External Creative Binaries (`yoke/external/*`, `yoke/pkg/binmgr/pins.go`)**
   - Provisioned on demand via `pkg/binmgr` with fail-closed SHA-256 supply-chain pins.
   - Executed strictly as bounded, typed, non-resident batch children (no arbitrary script pass-through, no resident daemons, no linked GPL code).
   - Shipped wrappers in `yoke/external/`: `gimp` (3.2.6), `audacity` (3.7.3), `blender` (4.2.3), and `kitsu` (CGWire Kitsu/Zou production tracker client).
   - *Mounting status*: `gimp.NewCmd()`, `audacity.NewCmd()`, and `blender.NewCmd()` exist as tested Cobra packages in `yoke/external/*`; mounting them onto `yoke/cmds/all` and the top-level `bashy` CLI/MCP surface is a separate integration step when needed.

---

## 2. Capability Matrix by Media Domain

### 2.1 PDF Reading, Authoring & Book Generation

| Capability | Surface & Source | Details |
| :--- | :--- | :--- |
| **PDF -> Markdown / Text Extraction** | `bashy lens -t md\|txt <file.pdf>` (`yoke/pkg/lens/pdf.go`, `yoke/pkg/lens/lens.go`) | Pure-Go per-page text extraction (`github.com/ledongthuc/pdf`). When `markitdown` or `docling` are registered as external commands, `DefaultRegistry()` routes `pdf -> md` through them first. |
| **Import -> Edit -> Export PDF (Single Note)** | `bashy notepad` (`bashy/examples/desk/notepad/convert.go`, `export.go`) | `notepad add -f paper.pdf` converts PDF into an editable Markdown note via `bashy lens`. Humans and agents edit via web UI or `notepad set <id>`, and `notepad export <id> --to pdf` renders an A4 PDF in pure Go (`github.com/go-pdf/fpdf`). |
| **Multi-Page Books & Dossier PDF Export** | `bashy viewer` (`bashy/examples/desk/viewer/page.go`, `pdf.go`, `templates.go`) | Compiles multi-page books from Markdown (`--body` / `-f`) or schema-validated JSON templates (`status`, `standup`, `incident`, `test-run`, plus custom `<data>/templates/*.md.tmpl`). `viewer export <id> --to pdf -o out.pdf` inlines CSS and assets into self-contained HTML and prints a paged PDF via headless Chrome/Chromium/Edge (`--print-to-pdf`). |

### 2.2 Drawing, Whiteboard & Diagrams

| Capability | Surface & Source | Details |
| :--- | :--- | :--- |
| **Interactive Freehand Canvas & Sticky Notes** | `bashy whiteboard` (`bashy/examples/whiteboard/server/main.go`, `desk.go`) | Multi-participant 1600×1000 canvas supporting freehand strokes (`stroke`, `delete-stroke`, color + pen width 1–30), sticky notes (`note`, `move-note`, `edit-note`, `delete-note` with Markdown/chart rendering), facilitator lock/clear/invite controls, and export to JSON or rasterized PNG (`renderPNG`). |
| **Data Charts (Server-Side SVG)** | `bashy chart` (`bashy/examples/desk/chart`, `bashy/examples/desk/kit/render/fences.go`) | Generates sanitizer-safe SVG charts (`line`, `bar`, `gauge`, `counter`, `histogram`, `table`, `stat`) from JSON, CSV, NDJSON, or OTLP input; embeds into Desk Markdown via ```` ```chart ```` fenced blocks. |
| **Graph Projections (`dot`, `mermaid`)** | `bashy lens` (`yoke/pkg/lens/graphview.go`) | Projects `bashy-graph-v1` JSON streams (from `sprint`, `todo`, `agent`, `claim`, `mb`, `meet`) into Graphviz `dot` or `mermaid` diagrams. |
| **2D Animation (OpenToonz)** | `yoke/external/opentoonz/EVIDENCE.md` | Evaluated and marked **UNSUPPORTED** (installer-only `.pkg`/`.exe` distributions, no publisher checksum manifest, no bounded CLI contract). |

### 2.3 Image Viewing, Batch Editing & 3D Rendering

| Capability | Surface & Source | Details |
| :--- | :--- | :--- |
| **Headless Batch Image Editing (GIMP 3.2.6)** | `yoke/external/gimp/gimp.go` (`EVIDENCE.md`) | One-shot headless batch wrapper (`--no-interface --batch-interpreter python-fu-eval`) over `.xcf/.png/.jpg/.jpeg/.tif/.tiff/.bmp/.gif/.webp`:<br>1. `export --input I --output O` (format conversion / XCF flatten)<br>2. `convert --input I --output O --mode rgb\|gray`<br>3. `edit --input I --output O [--scale WxH] [--rotate 90\|180\|270]` (1..16384 px).<br>Pinned in `yoke/pkg/binmgr/pins.go` (`linux/amd64`). |
| **Headless 3D & Image Rendering (Blender 4.2.3)** | `yoke/external/blender/blender.go` (`EVIDENCE.md`) | Headless batch wrapper (`-b --factory-startup -noaudio`):<br>1. `scene-inspect --scene S.blend`<br>2. `asset-import --input A --output O.blend` (`.obj/.fbx/.gltf/.glb/.stl/.ply/.usd*`)<br>3. `render --scene S.blend --output O.png [--frame N]`<br>4. `output-inspect --image I` (dimensions, channels, depth, colorspace, alpha for `.png/.jpg/.exr/.tif/.bmp/.hdr/.tga`). |
| **Pure-Go Image Resizing & Thumbnails** | `filebrowser/img/service.go`, `yoke/pkg/webconsole/panel_files.go` | `Service.Resize` supports `resize`, `fit`, and `fill` modes across JPEG/PNG/GIF/TIFF/BMP (`github.com/disintegration/imaging`) with EXIF orientation and thumbnail support. |
| **Text / Canvas to PNG Export** | `bashy/examples/desk/notepad/export.go`, `bashy/examples/whiteboard/server/main.go` | Pure-Go `image/draw` + `golang.org/x/image/font/basicfont` PNG exporters. |
| **Webcam Photo Capture** | `bashy/examples/record/record.bsh` | `record photo --prompt "..." --out photo.png` via loopback browser page. |

### 2.4 Audio Recording, Editing & Transcription

| Capability | Surface & Source | Details |
| :--- | :--- | :--- |
| **Batch Audio Editing (Audacity 3.7.3)** | `yoke/external/audacity/audacity.go` (`EVIDENCE.md`) | Drives a same-user Audacity 3.x instance over local `mod-script-pipe` FIFOs across `.wav/.mp3/.flac/.ogg/.aiff/.aup3`:<br>1. `info --input X` (tracks, channels, sample rate, clip bounds)<br>2. `trim --input X --output O --start S --end E`<br>3. `normalize --input X --output O [--level L]` (`[-60, 0]` dB, default `-3`)<br>4. `export --input X --output O [--format F]` (`wav/mp3/ogg/flac/aiff`).<br>Pinned in `yoke/pkg/binmgr/pins.go` (`linux/amd64`, `windows/amd64`). |
| **Audio Decode, Trim, Gain & Transcription** | `bashy transcribe` (`bashy/internal/agentos/transcribe.go`, `bashy/docs/transcribe-contract.md`, `bashy/docs/plan-transcribe-webm-opus.md`) | 4-stage contract (`acquire -> decode -> infer -> export` to `txt\|srt\|vtt`):<br>- `transcribe-wav`: pure-Go RIFF PCM16 decode, 1–8 ch mono mixdown, 16 kHz resample.<br>- `webm-opus`: pure-Go WebM/Opus decode (`pion/opus`) with **audio trim and gain** controls.<br>- `transcribe-whisper`: offline CPU `whisper.cpp` (`v1.9.5` pinned in `pins.go`). |
| **Mic Voice Recording with Teleprompter** | `bashy/examples/record/record.bsh` | `record audio --script script.txt --lang en-US --out voice.webm` opens a loopback browser page with scrolling teleprompter and TTS preview. |

### 2.5 Video Recording, Storyboard Assembly & Publishing

| Capability | Surface & Source | Details |
| :--- | :--- | :--- |
| **Storyboard Video Builder (1080p30 MP4)** | `bashy/examples/video/video.sh` (`README.md`, `dag.md`) | Compiles a project directory's `storyboard.txt` into a 1920×1080 @ 30fps H.264/AAC `.mp4` using `asciinema`, `agg`, and `ffmpeg`:<br>- `card <name> [secs]`: full-screen title cards (`cards/<name>.txt`)<br>- `step <name>`: single terminal session recorded under `bashy` (`steps/<name>.sh`)<br>- `pair <left> <right>`: side-by-side terminal comparison (`hstack` + `tpad`)<br>- `camera <name> <secs> [opts]`: webcam or pre-recorded `.mp4`/`.mov` with automatic speed-fit (`setpts`/`atempo`), `reframe` (`crop=iw*0.8:ih*0.8...`), `enhance-video` (`hqdn3d`, `eq`, `unsharp`), and `enhance-audio` (`highpass`, `afftdn`, `acompressor`, `loudnorm` -16 LUFS)<br>- `narration.m4a`: optional voice-over track muxing. |
| **Webcam Video Capture with Teleprompter** | `bashy/examples/record/record.bsh` (`page.html`) | `record video --script pitch.txt --max-seconds 75 --fit-seconds 60 --out takes/intro.mp4` provides countdown, scrolling teleprompter, speed-fit preview, and writes `takes/intro.mp4.json` (`{"enhance": true}`) consumed automatically by `video.sh`. |
| **Video Blog & Review Reel Publishing** | `bashy/examples/vlog/README.md` | Builds a static video showcase from a directory of `.mp4`/`.webm`/`.mov` files + Markdown notes, serves locally, or publishes via Outpost / GitHub Pages. |
| **VFX Compositing (Natron) & Shot Tracking (Kitsu)** | `yoke/external/natron/EVIDENCE.md`, `yoke/external/kitsu/EVIDENCE.md` | Natron 2.5.0 is marked **UNSUPPORTED** (no upstream SHA-256 digests). `kitsu` provides a bounded REST client for CGWire Kitsu/Zou shot/task status and comments. |

---

## 3. Desk Apps for Team Collaboration

All Desk tools share `bashy/examples/desk/kit` (`kit.css`, `kit.js`, `desk-kit/render`) and expose both a browser UI and a deterministic CLI/JSON API (`add`, `open`, `show`, `set`, `list`, `share`, `close`, `export`):

- **`notepad` (`bashy/examples/desk/notepad`)**: Collaborative Markdown scratchpad with live preview, multi-format import (`pdf`, `html`, `md`, `txt` via `bashy lens`), and export to `md`, `txt`, `html`, `pdf`, and `png`.
- **`viewer` (`bashy/examples/desk/viewer`)**: View-only multi-page books for sprint/session reports and competition dossiers, with automatic block-level diff highlighting (`Changed since pN`), single-use invite links (`viewer share <id>`), self-contained HTML export, and headless-Chrome PDF export.
- **`form` & `replyform` (`bashy/examples/desk/form`, `replyform`)**: Persistent multi-round questionnaires, rubrics, and many-respondent polls for human/agent review gates.
- **`chart` (`bashy/examples/desk/chart`)**: Offline SVG chart generator and fence renderer (`--desk-data-1..8` palette in light and dark themes).
- **`whiteboard` (`bashy/examples/whiteboard`)**: Shared freehand drawing canvas and sticky-note board for architecture sketching and brainstorming.
- **`brainstorm` (`bashy/examples/brainstorm`)**: Multi-participant LAN/Desk card ideation and voting board (`write -> discuss -> vote -> closed`) with Markdown/chart card rendering, invite-only sessions, and JSON/Markdown export.
- **`tutor` (`bashy/examples/tutor`)**: Timeboxed classroom/workshop sessions (`plan`, `apply`, `serve`, `join`, `stop`) with teacher, projector, and student views, guardrailed nudges, and tempo controls.
- **Software Shaping (`bashy shape`, `bashy/docs/shaping-trial.md`)**: Team members can customize Desk apps (`notepad`, `form`) and the launcher (`console`) in isolated per-user versions (`wish -> verify -> preview -> approve`) and share vetted versions across the team (`bashy src offer|adopt`, `bashy shape push|pull`).

---

## 4. Competition Playbook (PDFs, Videos & Team Workflows)

### Workflow A — Producing Competition PDFs & Technical Dossiers
1. **Draft & Collect**: Use `notepad` and `form`/`replyform` for collaborative human + agent drafting, evaluation rubrics, and notes.
2. **Assemble Book in `viewer`**:
   ```bash
   viewer add comp-dossier --title "Competition Technical Dossier"
   viewer append comp-dossier -f sections/01-executive-summary.md
   viewer append comp-dossier -f sections/02-architecture.md --asset diagrams/mesh.png
   viewer append comp-dossier --template test-run --data results/benchmark.json
   ```
3. **Export Self-Contained HTML & Paged PDF**:
   ```bash
   viewer export comp-dossier --to html -o build/comp-dossier.html
   viewer export comp-dossier --to pdf  -o build/comp-dossier.pdf
   ```

### Workflow B — Producing Competition Demo Videos
1. **Verify Host Tools**:
   ```bash
   cd bashy/examples/video && ./video.sh doctor
   ```
2. **Capture Presenter Takes with Teleprompter**:
   ```bash
   bashy/examples/record/record.bsh video \
     --script project/scripts/intro.txt \
     --max-seconds 60 --fit-seconds 45 \
     --out project/takes/intro.mp4
   ```
3. **Define `project/storyboard.txt`**:
   ```text
   card title 3
   camera intro 45 reframe enhance
   step demo-live
   pair agent-left agent-right
   card close 3
   ```
4. **Build 1080p30 MP4 & Generate Captions**:
   ```bash
   bashy/examples/video/video.sh build project
   bashy transcribe project/build/demo.mp4 --to srt -o project/build/demo.srt
   ```

---

## 5. Sufficiency Verification & Enhancement Backlog

### Verified Baseline
- **Desk & PDF Tests**: `GOWORK=off go test ./...` passes across `bashy/examples/desk/kit`, `bashy/examples/desk/viewer`, and `bashy/examples/desk/notepad` (including `TestExportSelfContained`, `TestExportPDF`, and `TestConvertPDF`).
- **Video Toolchain**: `bashy/examples/video/video.sh doctor` verifies `asciinema`, `agg`, `ffmpeg`, `ffprobe`, and `bashy` on `PATH`.

### High-Priority Enhancements & Known Gaps (Next Few Weeks)

1. **PDF — Fix 256 KiB Asset Truncation in `desk-kit/render/embeds.go` (Bug)**
   - *Finding*: `readAsset` in `bashy/examples/desk/kit/render/embeds.go` wraps asset files in `io.LimitReader(f, 256<<10)` (256 KiB), whereas `inlineURI` checks `len(raw) > 1<<20` (1 MiB). Any PNG/JPEG diagram or screenshot larger than 256 KiB is silently truncated at 256 KiB when base64-inlined into exported HTML/PDFs, corrupting the image.
   - *Fix*: Raise `readAsset`'s limit for binary/inline assets (e.g., to `4<<20` or `1<<20 + 1`) and return an error instead of silently truncating when an asset exceeds the cap.

2. **PDF — Wire `render.ChartSVG` Hook in `viewer` and `notepad`**
   - *Finding*: `bashy/examples/desk/kit/render/fences.go` defines `var ChartSVG func(...)`, but `viewer` and `notepad` do not assign `render.ChartSVG` at startup, causing ```` ```chart ```` blocks in `viewer` books to fall back to `"chart renderer unavailable"`.
   - *Fix*: Wire the `chart` SVG fence renderer into `viewer` and `notepad` so embedded charts render directly in browser views and exported PDFs.

3. **PDF — Richer Print Styling & Cover/Header Options**
   - *Finding*: `notepad`'s pure-Go `fpdf` exporter (`bashy/examples/desk/notepad/export.go`) only renders headings, bullets, and code fences in cp1252 Latin-1 (no tables, images, or full UTF-8), and `viewer`'s in-browser `Print / PDF` button prints only the currently open page (`window.print()`).
   - *Fix*: Use `viewer export <id> --to pdf` (headless Chrome) for all competition PDFs, add an in-browser "Print full book" link in `viewer`, and optionally route `notepad export --to pdf` through the shared kit HTML + headless-Chrome renderer when available.

4. **Video — Per-Step Voice-Over & Audio Mixing in `video.sh`**
   - *Finding*: In `bashy/examples/video/video.sh`, `card`, `step`, and `pair` segments generate silent audio (`anullsrc`), and if a global `narration.m4a` file is present (`-map 0:v:0 -map 1:a:0`), it overwrites the audio of all segments—including `camera` presenter clips.
   - *Fix*: Support per-step audio sidecars (`steps/<name>.m4a` or `cards/<name>.m4a`) so terminal steps can have voice-over narration while `camera` clips keep their recorded presenter audio.

5. **Video — Image/Slide Cards & Subtitle Burn-In (`srt`/`vtt`)**
   - *Finding*: `card` in `video.sh` only renders terminal text via `agg`; it cannot insert a static PNG slide, chart, or rendered PDF page, nor burn in `.srt`/`.vtt` captions produced by `bashy transcribe`.
   - *Fix*: Add a `slide <image.png> <seconds> [audio.m4a]` directive and a `--subtitles <file.srt>` option in `video.sh`.

6. **Desk `brainstorm` — Preset Seed Cards, Multi-Round Ideation/Voting, Filtering & Session Carry-Forward**
   - *Finding*: `bashy/examples/brainstorm` (`server/main.go`) currently enforces a strictly one-way phase progression (`write -> discuss -> vote -> closed`) with no preset/example cards at session start, no multi-round ideation or runoff voting, and no built-in way to filter/carry selected cards into a subsequent round or restart from a saved session's cards and votes.
   - *Fix*: Support preset/seed cards, repeatable rounds (opening another card-writing phase or skipping directly to a new voting round), between-round card filtering (by manual selection, vote threshold/top-N, column, or other fields), and saving/restarting sessions from prior session state (`8d7d48eeae63`).
