# Sprint 635: lip-sync proof on a rented GPU — evidence

Story M8 (`efd9bc004b56`), carried from Sprint 627. Conductor
`claude-fable5.1-s635`, 2026-11-13 16:00 to 20:50 PST. Plan: the Sprint 635
card's continuity record; rules: the M8 story (AWS recipe, one instance at a
time, cap USD 50 carried from S627, report at 40).

## Result

**Visible lip sync achieved at 2026-11-14 04:43Z (20:43 PST)**, attempt 12.
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

## Also this sprint

- `animate-prerendered` rod + `film --takes` (story `4981fca468a1`, merged into bashy main at
  `2c172931`): returned clips assemble as ordinary animate takes with provider, model, cost and
  sha256 recorded; shots without a take keep the still-pan fallback, marked degraded.
- Google's current API video model (Gemini Omni 1.2 Flash; the Veo 3.1 previews were shut down
  2026-10-22) accepts no audio input, so it cannot lip-sync to the locked song.
- LatentSync 1.6's code is Apache-2.0 but its weights are OpenRAIL++; not used.

## Remaining

1. Full-length performance shots (six close-ups, about 26 s of singing) with this recipe; per-shot
   inputs are already in the runner bucket under `sprint-635/inputs/shots/`. At attempt 12's speed
   that is several hours on g5.xlarge, chunked to the 90-minute in-guest limit; a g6e would be
   several times faster when capacity returns.
2. Assembly through `film draft --takes`, EN + ZH subtitles, operator review.
3. The commercial final (Kling API + Suno browser route) after the operator creates both accounts.
