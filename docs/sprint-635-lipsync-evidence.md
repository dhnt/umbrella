# Sprint 635: lip-sync proof on a rented GPU — evidence

Story M8 (`efd9bc004b56`), carried from Sprint 627. Conductor
`claude-fable5.1-s635`, 2026-11-13 16:00 to 20:50 PST. Plan: the Sprint 635
card's continuity record; rules: the M8 story (AWS recipe, one instance at a
time, cap USD 50 carried from S627, report at 40).

## Result

**Visible lip sync achieved at 2026-11-14 04:43Z (20:43 PST)**, attempt 12, on a rented GPU; and
**again locally at zero cost at 14:30Z (06:30 PST)** on the first Windows test host (see
"Local venue" below).
EchoMimicV3 Flash animated Nova's locked shot-03 still to the first 5.0 s of
the locked song's sung segment: lips open and close through distinct shapes,
head turns, blinks. Review files on the dev box in the umbrella's gitignored
`.agents/s635-review/echomimicv3-flash-12/` and the viewer book
`s635-lipsync-proof`.

| Artifact | Value |
|---|---|
| `proof.mp4` | 5.000 s, 125 frames, 512x512, H.264 + AAC; sha256 `c2312788776f7fdc2937a920e5f95c5f39c858e6b2992ef892e31c96665b25f7` |
| Mouth-region motion (ffmpeg `tblend=difference` + `signalstats` YAVG, 124 frame pairs) | **1.64 mean, 6.80 max** vs **0.12 mean, 0.49 max** for the S627 TBDub clip |
| Generation time | 3350 s on the A10G (the 16 GB host streamed weights through swap) |
| Instance | `i-05b0700ef40098833`, g5.xlarge, us-west-2b, 03:36:06Z to 04:43Z, self-terminated; about USD 1.15 |

## Pinned recipe (attempt 12)

- Model: EchoMimicV3 (Ant Group, Apache-2.0), source `7e89489ca51c0d008fc1963ec6c03fc5bd0b9397`;
  weights `BadToBest/EchoMimicV3` rev `311e176905a8c4c24b240b530488fe636ce4d249`
  (flash-pro transformer); base `alibaba-pai/Wan2.1-Fun-V1.1-1.3B-InP` rev
  `fc913c34361f4ec879e2f9c78b4f11ae50a937d1` (Apache-2.0); audio encoder
  `TencentGameMate/chinese-wav2vec2-base` rev `3991242c806928916fff4a8c0e4f76acf661b743` (MIT).
- Inputs in the runner bucket under `sprint-635/inputs/`: `nova.png` (first frame of the S627
  shot-03 source clip, sha256 `29b2785d…e1fd`) and `nova-sing.wav` (6.52 s cut from the locked
  film at 11.087 s, sha256 `9201b173…dfca`), trimmed to 5.0 s on the host.
- Host: the approved deep-learning AMI (public SSM parameter), g5.xlarge, 150 GB gp3 root,
  32 GB swap file, instance profile `dhnt-gpu-runner`, no key pair, default no-inbound
  security group, tags `dhnt:managed=true` + `sprint=635` on instance and volume,
  `instance-initiated-shutdown-behavior=terminate`, in-guest `shutdown -h +90`.
- Python stack, pinned after verifying each at source: torch 2.6.0+cu124, diffusers 0.33.1,
  transformers 4.51.3, accelerate 1.6.0, numpy 1.26.4, huggingface_hub 0.30.2, plus `pyloudnorm`;
  downloads over classic HTTP (`HF_HUB_DISABLE_XET=1`) with retries; `USE_TF=0`.
- Two patches to `infer_flash.py`: `low_cpu_mem_usage=False` (plain load), and the authors' own
  low-VRAM path from `app_mm.py` in place of `pipeline.to(device)`:
  `mmgp.offload.profile(pipeline, LowRAM_HighVRAM, budgets 85 % of VRAM)`.
- Inference: `--num_inference_steps 8 --sampler_name Flow_Unipc --video_length 125 --sample_size 512 512
  --fps 25 --guidance_scale 6.0 --audio_guidance_scale 3.0 --seed 7011 --enable_teacache`.
- The script writes its log to S3 every 60 s; the local script's md5 was compared with the
  instance's stored user-data at launch.

## The twelve attempts

| # | Instance | Outcome | Root cause | Fix carried forward |
|---|---|---|---|---|
| 1 | g5 2a | `ModuleNotFoundError: pyloudnorm` | imported by the inference script, absent from `requirements.txt` | pip it |
| 2 | g5 2b | process killed after 878 s | pip-latest diffusers lacks `load_model_dict_into_meta`; full-size load on 16 GB RAM | pin diffusers 0.33.1, add swap |
| 3 | g5 2b | download crash | Hugging Face Xet backend "Background writer channel closed" | classic HTTP + retries |
| 4, 5, 6 | g5 2b | no upload / FLAX import error / no upload | **tooling**: in-shell patches inside background commands never persisted, so attempt 3's script re-ran; 5 reached the transformers 5 vs diffusers 0.33 mismatch | write scripts with the file tool; md5 check at launch; log pump |
| 7 | g5 2b | `Cannot copy out of meta tensor` after 1254 s | low-memory meta-device load leaves tensors empty under diffusers 0.33.1 | plain load |
| 8 | g5 2b | CUDA out of memory at 22.00 of 22.06 GiB after 2880 s | the whole pipeline resident on the A10G; load thrashed swap | g6e or offload |
| 9 | g6e, 4 zones | `InsufficientInstanceCapacity` | no 48 GB capacity in us-west-2 | fall back to g5 + offload |
| 10 | g5 2b | my patch assertion | `infer_flash.py` moves the pipeline twice | replace first, neutralise second |
| 11 | g5 2b | segmentation fault in the import preflight | TensorFlow (via retina-face) registered CUDA plugins next to torch | `USE_TF=0` |
| 12 | g5 2b | **success** | | |

Spend: sprint-635 attempts about USD 4.4 by runtime and on-demand price (billing lags; the
budget showed USD 0.36 billed throughout); about USD 5.05 against the carried USD 50 cap including
Sprint 627. No instance left running; every one self-terminated or was verified terminated.

## Local venue (zero spend)

The same model, revisions and inputs ran natively on the first Windows test host (AMD unified-memory
GPU, ROCm 10, 128 GB) on 2026-11-14 and produced the 5 s shot-03 clip: 125 frames at 384x384,
25 fps, 2541 s of generation, exit 0, no GPU timeout or reset events in the system log; sha256
`4c7f835c898bce0a6f99995f9772bc7f40526349d20b87b2cafd5b498f930371`; mouth-region motion 2.06
(rented GPU 1.64, TBDub 0.12). Review files on the dev box: `.agents/s635-review/echomimicv3-local-01/`,
viewer book `s635-lipsync-local`.

Host recipe, all inside an isolated `C:\s635` folder, Python packages provisioned through `bashy uv`:

- The operator's ROCm 10 venv supplies torch (2.13 rocm); the pinned model stack (diffusers 0.33.1,
  transformers 4.51.3, accelerate 1.6.0, numpy 1.26.4, scipy 1.13.1, huggingface_hub 0.30.2,
  pyloudnorm) lives in a side directory on `PYTHONPATH`. `uv pip install --target` installs torch
  into the side directory even with `--override`; delete torch/torchvision/torchgen/functorch there
  after every install, or the CPU torch shadows the ROCm one.
- `low_cpu_mem_usage=False`; no offloader (the whole pipeline fits unified memory, 28.7 GiB resident).
- `--sample_size 384 384` and `pipeline.decode_latents` overridden to run the Wan VAE on the CPU in
  float32. Both because the Windows HIP driver caps a single allocation at about 2.5 GiB on this host
  (adapter reports 4 GB dedicated, 64 GB shared; torch sees 99.7 GiB): the VAE encoder's conv
  activation is 5.06 GiB at 512 and the decoder's 2.85 GiB at 384. 512x512 needs a larger UMA frame
  buffer in the host BIOS or VAE tiling in the model code.
- Launch the generator synchronously from the run script: PowerShell's detached launcher joins
  arguments without quoting and split the prompt; it also drops empty-string arguments.

Local attempts: 512 failed in the VAE encoder (OOM 5.06 GiB), 384 denoised fully then failed in the
VAE decoder (OOM 2.85 GiB), 384 with CPU decode succeeded. The second Windows host (8 GB GPU, 16 GB
RAM) cannot hold the 20 GB weight set and was dropped. Speed: about 8 minutes of GPU time per second
of video at 384, so the six full-length close-ups (about 26 s) are roughly 3.5 hours on this host.

## The full film, locally (zero spend)

All six singing close-ups of the locked `lanterns-r3` render 04 (shots 03, 04, 09, 10, 12, 13; 24.8 s
of singing) were rendered as EchoMimicV3 takes on the Windows test host on 2026-11-14 and assembled
into the full 81 s film with the English + Simplified Chinese subtitles of the accepted revision.
Review files on the dev box: `.agents/s635-review/film-local-02/` (film sha256 `496291fc…`,
manifest, takes.json), takes in `.agents/s635-review/takes-local/`; viewer book
`s635-film-lipsync-full` (the five-take interim cut: `s635-film-lipsync`).

- Takes come out 16:9 (512x288) when the input still is the locked 768x432 portrait: the model keeps
  the still's aspect ratio at the requested pixel budget (384x384 here). Short shots took 251 to
  789 s each.
- Shot 13 (15.65 s, 389 frames) ran out of memory in the transformer at about 31 GiB allocated
  ("expandable_segments: memory mapping failed"): this host's usable GPU budget per process is
  about 31 GiB, so long shots are chunked. Four 3.88 s chunks, each continuing from the previous
  chunk's last frame (continuity), 1586 s each, joined under the shot's own audio.
- `film draft --locked` (bashy `5c43cb08`) assembles on the lock: the locked draft's song, the
  locked timing, translation, portraits and shot bounds (what a final reuses), so takes cut from
  the locked song land on their shots in sync; only the animate stage runs a rod. Reused stages
  record provider `film-locked`, the manifest carries `lock_sha256`.
- Input defects found and fixed before the renders (both mine, both verified by RMS-envelope
  cross-correlation against the song): the per-shot audio had been cut from the review film,
  which opens with a 3 s title card, so every slice began 3 s early; and the Nova still was a
  512x512 crop instead of the locked portrait. The pipeline's own per-shot cuts
  (`drafts/04/shots/NN/audio.wav`) are the correct slices.
- Two rod findings (todo `dd8e6264`): the authors' script exits 1 on Windows at its final temp-file
  removal although the output is complete; and the 4n+1 frame rounding leaves a take up to 0.16 s
  shorter than its shot.
- Ash's locked portrait has the microphone over his mouth, so his lip motion is partly hidden by
  the still's own framing; Nova's shots show it clearly.

## Also this sprint

- `animate-prerendered` rod + `film --takes` (story `4981fca468a1`, merged into bashy main at
  `2c172931`): returned clips assemble as ordinary animate takes with provider, model, cost and
  sha256 recorded; shots without a take keep the still-pan fallback, marked degraded.
- Google's current API video model (Gemini Omni 1.2 Flash; the Veo 3.1 previews were shut down
  2026-10-22) accepts no audio input, so it cannot lip-sync to the locked song.
- LatentSync 1.6's code is Apache-2.0 but its weights are OpenRAIL++; not used.

## Remaining

1. Operator review of the local full film (viewer book `s635-film-lipsync-full`).
2. The commercial final (Kling API + Suno browser route) after the operator creates both accounts;
   it redoes exactly these six shots at full quality through the same `--takes` assembly.
