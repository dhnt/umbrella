# Sprint 627 M3b: native Windows animate spike

Story `6bde7278808d`, 2026-11-13. **Blocked: no MP4 was produced, so no
`animate route=oss` rod was registered.** The Windows test host claim was held
for the entire spike and released afterward. This is a bounded experimental
command, not a production service route.

## M3 post-denoise stall

The M3 WSL log ended after four denoise steps and before Wan's "Saving generated
video" line. In the pinned Wan source, `WanTI2V.generate` offloads the denoiser,
then calls `self.vae.decode(x0)` before returning to `generate.py` for
`save_video`. The VAE is constructed with `device=self.device`, which was the
ROCm GPU. A short instrumented WSL replay could not reach inference because
the WSL runtime now reports `RuntimeError: No HIP GPUs are available`; that is
the recorded reason for using WSL only to inspect the existing M3 source and
hash the staged source files. The original WSL process was not sampled inside
the VAE, so its exact stack is inferred from source and its last log boundary.

The native replay instrumented the same source commit
`1ea34ff48f87168174e12956e200b1d908b1c5ff`. After denoise it logged
`VAE_DECODE_START device cuda:0 parameter_device cuda:0 latent_device cuda:0`.
It logged neither `VAE_DECODE_END` nor "Saving generated video" before the
600-second bound. **The stalled substep is GPU VAE decode, before video
encoding.** This also happened outside WSL's 31 GiB memory cap, so that cap is
not a sufficient explanation for M3's timeout. No OOM was reported in either
run; this does not establish the VAE kernel's specific internal bottleneck.

## Native setup and reuse

- Native `bashy.exe` ran the unregistered
  `examples/oss-rods/animate-wan-spike.bsh` custom command with a PowerShell
  fence. The host had no native `uv` or Python initially. The command obtained
  pinned `uv` 0.13.7, installed Python 3.12.10, then AMD's official Windows
  ROCm 7.2.0 SDK and Torch 2.9.1 wheels. The GPU probe returned
  `TORCH 2.9.1+rocmsdk20260116 GPU True AMD Radeon(TM) 8060S Graphics`.
  Driver version was `32.0.22040.7`. AMD's `rocm` source metapackage failed
  under `uv` with a Windows invalid-handle error; installing its binary SDK
  wheels with `uv` and the small Python metapackage with pinned Python's pip
  succeeded. The native Torch build lacks FSDP, so the single-GPU probe
  supplies an import shim that rejects FSDP calls. It also imports only Wan's
  TI2V task to avoid unused S2V/Animate dependencies. Both FSDP flags were
  false. Wan's existing PyTorch SDPA fallback replaced its FlashAttention
  import in the copied local source; no upstream source was changed.
- Native C: had 863,765,278,720 bytes free at preflight, above the command's
  100 GiB floor. The 34,179,993,972 bytes of existing Wan weight files were
  copied from the host's WSL M3 directory into the native cache. **No model
  weights were fetched.** The source was hashed inside WSL because Windows
  hashing through the WSL file bridge was prohibitively slow; native
  destination hashes matched all five source hashes. The separate M2b rod
  caches were not copied or downloaded. C: had 807,776,219,136 bytes free
  after the spike.

| Existing weight | Source and native SHA-256 |
|---|---|
| Wan2.2 VAE | `20eb789667fa5e60e7516bf509512f6cb61f01b0aa0695eadaea930c13892b36` |
| T5 encoder | `7cace0da2b446bbbbc57d031ab6cf163a3d59b366da94e5afe36745b746fd81d` |
| Diffusion shard 1 | `720b06c4ade5e87c1246bba8ac95b664c638749cd9b102cf84d823bb44c026a1` |
| Diffusion shard 2 | `09ec5ef720d8396f6cfa51fbdcbdb2327e37722afd6e89fd38f1e7e5e782c283` |
| Diffusion shard 3 | `6306f7894c345de9093ad588771c2abfaeb668a81f7a6d9a918bd26ba3568e49` |

The [Wan2.2 model card](https://huggingface.co/Wan-AI/Wan2.2-TI2V-5B)
and [Wan source license](https://github.com/Wan-Video/Wan2.2/blob/main/LICENSE.txt)
say Apache-2.0. The installed Torch wheel metadata says BSD-3-Clause. AMD
lists [Windows PyTorch wheels for gfx1151](https://rocm.docs.amd.com/projects/radeon-ryzen/en/docs-7.2/docs/install/installryz/windows/install-pytorch.html),
but the installed ROCm SDK wheel metadata did not declare a license. AMD's
[Windows SDK documentation](https://rocm.docs.amd.com/projects/install-on-windows/en/develop/about/release-versioning.html)
also says not all Windows build inputs are available under a permissive open
source license. This spike verifies local availability and execution; it makes
no claim that every Windows runtime binary is permissively licensed or
redistributable.

## Bounded render and decision

The native command ran offline with 17 frames at 1280×704, 24 fps, four
sampling steps, CPU text encoder, model offload, and SDPA. Denoising finished
in about 73 seconds. GPU VAE decode started and did not finish within
600.72 seconds of process wall time. There was no MP4, no save/encode log,
and no surviving probe process after timeout. Observed process working set
reached at least 37,288,620,032 bytes while loading and later fell below
15 GiB during decode; a full peak memory value was not captured because the
timeout terminated the process. Completed clip throughput is 0 clip-seconds
per wall-second. The conditional 14B lip-sync run was skipped because TI2V-5B
did not render. No WSL configuration, shutdown, Podman machine, AWS resource,
or development-host GPU was used.

Next investigation, if authorized separately: profile the VAE's GPU decode
kernel and try a smaller frame size or tiled VAE decode. The current result
does not justify registering an OSS animate route.
