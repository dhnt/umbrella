# Sprint 627 M2b-song: live OSS render

Story `0d2e5664b05e`. **Works:** one 10-second instrumental WAV was rendered
through `bashy song --route oss --json` on the claimed Windows test host. The
artifact is retained in that host's isolated M2b work directory as
`song-final.wav`; no model or audio bytes are committed here.

## Venue and staged inputs

Native Windows was checked first in the preceding attempt: `bashy.exe` was
present, but the native song cache was empty and native AMD inference was
unverified. WSL reused the existing ACE-Step checkout, package environment,
ROCm bridge and M2b-w weights. This is the recorded reason for WSL. No default
Podman machine, WSL configuration, AWS resource, or dev-host model was used.
The host claim was held through the render and released afterward.

The WSL filesystem had 208,462,932 KiB free at retry preflight, above the
rod's 25 GiB threshold. `HSA_ENABLE_DXG_DETECTION=1` exposed `gfx1151`.
The ACE-Step checkout is pinned at `ca1e85fe9430179831e6bc6be790c332190a3866`.
Its old Python 3.11 environment had CUDA-only PyTorch `2.10.0+cu128`.
The existing host-local ROCm wheel is for Python 3.12, so a separate ACE-Step
Python 3.12 environment was built with the already staged PyTorch
`2.9.1+rocm7.2.1` and matching Triton, torchaudio and torchvision wheels.
`torch.cuda.is_available()` returned true and identified the AMD GPU.
ACE-Step's own `torchao<0.17` constraint required `torchao==0.16.0`.

All four principal M2b-w checkpoints were rechecked by SHA-256 against
`docs/sprint-627-m2b-weights-evidence.md` before inference:

| Component | SHA-256 |
|---|---|
| `Qwen3-Embedding-0.6B/model.safetensors` | `0437e45c94563b09e13cb7a64478fc406947a93cb34a7e05870fc8dcd48e23fd` |
| `acestep-5Hz-lm-1.7B/model.safetensors` | `f161689da73e5ecefa28ff780d51c2d92a00f056d021d7933c779ed5c6cd7db8` |
| `acestep-v15-turbo/model.safetensors` | `3f6e0797fad420a39bd33979eb6e840e30989e34a3794e843d23b60ec6e422d7` |
| `vae/diffusion_pytorch_model.safetensors` | `da17edb604c40deaf09e9b24974e590d1ca83a374070e5d0884cfa4bed9a99b0` |

## Render result

The isolated command registry was repaired with the pinned `bashy-defaults
apply`; both `song` and `song-acestep` then resolved. The ACE-Step server used
the staged snapshot through its checkout's `checkpoints` symlink. It ran with
Hugging Face offline flags, `ACESTEP_INIT_LLM=false` for this instrumental
clip, the PyTorch LM backend and blocked outbound HTTP. The final server log
has zero download markers. The request used seed `436`, a gentle acoustic
ballad prompt, `instrumental=true`, and `duration_s=10`.

The successful invocation started at 2026-11-13 06:39:04 UTC and ended at
06:39:17 UTC. Its measured wall time was **13.20 s** on the already loaded
server (the service envelope rounded to 12 s). Server process peak resident
memory was **15,155,696 KiB** (14.45 GiB); the model log reported 14.63 GB
peak GPU allocation. Front-door process peak RSS was 160,592 KiB. Free WSL
disk changed from 197,597,040 to 197,590,996 KiB during the final call.

```json
{
  "cost_class": "oss",
  "elapsed": 12,
  "outcome": "success",
  "outputs": [{"media_type": "audio/wav", "path": "<Windows test host M2b work area>/song.wav"}],
  "provider": "song-acestep",
  "role": "song",
  "route": "oss",
  "schema_version": "bashy-svc-v1",
  "text": "M2b song clip"
}
```

The envelope's actual output was copied to the isolated host work directory.
`ffprobe` confirms PCM signed 16-bit stereo WAV at 48 kHz, duration exactly
10.000000 s. Artifact size: **1,920,044 bytes**. Artifact SHA-256:
`ad512dab775a59f14b03b30c2837b6dd56359556a6c4c99d259879ca37886d53`.

## Retry findings and fix

The preceding run was blocked before inference: its isolated command ring was
empty, the ACE-Step environment was CUDA-only, and ROCm detection lacked
`HSA_ENABLE_DXG_DETECTION=1`. These were venue conditions.

This retry exposed two further ACE-Step venue behaviors. Its initialization
path looked under the checkout's `checkpoints` directory despite
`ACESTEP_CHECKPOINTS_DIR` pointing at the staged snapshot. It fell back from
offline Hugging Face to ModelScope and began transferring weights. The server
was stopped promptly; the approximately 412 MB partial directory was kept
separate and the checkout path linked to the verified staged snapshot. A later
run auto-selected the unstaged 4B language model, initiating a second transfer
of approximately 138 MB before it was stopped. The final instrumental run
forced `ACESTEP_INIT_LLM=false`; it made no model transfer. These unintended
partial transfers are recorded explicitly against the operator's no-redownload
instruction and were not counted as staged inputs.

The product rod driver also sent `task_ids` to `/query_result`, whereas the
pinned ACE-Step API requires `task_id_list`, and it did not parse the JSON
string in `result` to find `/v1/audio`. The server generated audio, but the
front door kept polling. The Bashy rod now uses the documented API request and
result shape and refreshes its generated driver on each invocation. The final
front-door render above verifies that fix end to end.
