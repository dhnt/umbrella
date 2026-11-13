# Sprint 627 M2b-w: model weight staging

Story `fb563eb23e6b`, Windows test host. No renders. Paths below are relative
to `$BASHY_OSS_CACHE/bashy/oss` in the existing WSL M2b workspace; no model
bytes are committed to this public repository.

## Venue and preflight

- Exclusive Windows test host claim held during all host operations.
- Native Windows `bashy.exe` was tried first. Its rod cache was empty and
  `uv` was absent from its PATH; both can be provisioned, so neither alone
  justifies WSL. The previous M2b run had already created pinned package
  environments in WSL. GPU PyTorch ROCm was verified in WSL by M3, while
  native Windows GPU support remains unverified pending M3b. Staging the
  song, image and narration models beside those existing environments avoids
  a second package/weight transfer before GPU rendering. WhisperX's rod is
  CPU-bound on both venues; its WSL placement reuses the previous run's
  WhisperX environment and avoids provisioning a second Torch stack.
  No WSL configuration or Podman machine was changed.
- Native C: free space: 924,795,293,696 bytes (861.2 GiB). WSL root free
  space before downloads: 264,452,880 KiB (252.2 GiB). This exceeds the
  rods' 25/35/12/10 GiB individual preflight thresholds.
- Hub revisions are immutable commit IDs resolved before downloads. Files
  below were fetched into their rod cache via `hf download --revision ...
  --local-dir ...` and checked with `sha256sum` on the Windows test host.

## Verified files

| Rod / model | Hub revision | Relative path under rod cache | Bytes | SHA-256 | Wall time |
|---|---|---|---:|---|---:|
| narrate-local / Kokoro-82M | `f3ff3571791e39611d31c381e3a41a3af07b4987` | `narrate-local/models/Kokoro-82M/kokoro-v1_0.pth` | 327,212,226 | `496dba118d1a58f5f3db2efc88dbdc216e0483fc89fe6e47ee1f2c53f18ad1e4` | 19 s |
| narrate-local / Kokoro default voice | same | `narrate-local/models/Kokoro-82M/voices/am_fenrir.pt` | 523,430 | `98e507eca1db08230ae3b6232d59c10aec9630022d19accac4f5d12fcec3c37a` | included above |
| narrate-local / Chatterbox | `5bb1f6ee58e50c3b8d408bc82a6d3740c2db6e18` | `narrate-local/models/chatterbox/conds.pt` | 107,374 | `6552d70568833628ba019c6b03459e77fe71ca197d5c560cef9411bee9d87f4e` | 37 s for snapshot |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/s3gen.pt` | 1,057,165,844 | `9b9ff07e60b20c136e2b1b3d7563a24604e8d2c4c267888d1ee929dd0151d2a3` | included above |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/t3_cfg.pt` | 1,064,892,246 | `0b2dd5439fe7e94f379561419847a45bf2c79d0e8ea751c6bbe947ce337789cc` | included above |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/ve.pt` | 5,698,626 | `4b16d836bc598509860f6fa068165a8bb5e9ac84f05582dfcf278a5a372879f1` | included above |
| transcribe-whisperx / faster-whisper large-v3 | `edaa852ec7e145841d8ffdb056a99866b5f0a478` | `transcribe-whisperx/models/faster-whisper-large-v3/model.bin` | 3,087,284,237 | `69f74147e3334731bc3a76048724833325d2ec74642fb52620eda87352e3d4f1` | 4 s |
| song-acestep / ACE-Step 1.5 | `19671f406d603126926c1b7e2adc169acbcade22` | `song-acestep/models/Ace-Step1.5/Qwen3-Embedding-0.6B/model.safetensors` | 1,191,586,416 | `0437e45c94563b09e13cb7a64478fc406947a93cb34a7e05870fc8dcd48e23fd` | 133 s for snapshot |
| song-acestep / ACE-Step 1.5 | same | `song-acestep/models/Ace-Step1.5/acestep-5Hz-lm-1.7B/model.safetensors` | 3,708,521,528 | `f161689da73e5ecefa28ff780d51c2d92a00f056d021d7933c779ed5c6cd7db8` | included above |
| song-acestep / ACE-Step 1.5 | same | `song-acestep/models/Ace-Step1.5/acestep-v15-turbo/model.safetensors` | 4,787,825,604 | `3f6e0797fad420a39bd33979eb6e840e30989e34a3794e843d23b60ec6e422d7` | included above |
| song-acestep / ACE-Step 1.5 | same | `song-acestep/models/Ace-Step1.5/vae/diffusion_pytorch_model.safetensors` | 337,431,388 | `da17edb604c40deaf09e9b24974e590d1ca83a374070e5d0884cfa4bed9a99b0` | included above |

Kokoro's other voice files and configuration, and Chatterbox's tokenizer,
were downloaded in their respective snapshots. Qwen Image remains to be
staged and verified. These local snapshots
are staged bytes; the rods need explicit local model/cache binding before a
future render to guarantee they use the same revisions without downloading.

## Reuse on native Windows

If M3b establishes a native GPU path, copy the model directories from the
existing WSL cache through `\\wsl.localhost\Ubuntu-24.04\<WSL-cache-root>\bashy\oss`
to the native rod cache selected by `BASHY_OSS_CACHE` (the default is under
`LOCALAPPDATA`). Keep each relative path in the table unchanged. Use a copy
that preserves files without contacting the Hub, then run native
`bashy sha256sum` on each listed checkpoint and compare both byte count and
SHA-256 with this table before any render. Point the rod at the copied local
model files (or populate a Hugging Face Hub cache and bind `HF_HUB_CACHE`);
a plain rod invocation currently uses its default Hub model ID and can fetch
again. The specific WSL cache root is recorded in
the host-local M2b workspace, not this public repo.
