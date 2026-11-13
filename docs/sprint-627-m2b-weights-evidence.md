# Sprint 627 M2b-w: model weight staging

Story `fb563eb23e6b`, Windows test host. No renders. Paths below are relative
to the WSL rod cache root `/root/s627-m2b/cache/bashy/oss`; no model bytes are
committed to this public repository.

## Venue and preflight

- Exclusive `host:elephant` claim held during all host operations.
- Native Windows `bashy.exe` was tried first. The native rod cache was empty,
  and `uv` was absent from its PATH. The previous M2b run had already created
  pinned package environments in the WSL rod cache. WSL was used to reuse
  those environments; no WSL configuration or Podman machine was changed.
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

Kokoro's other voice files and configuration were downloaded in the same
snapshot. Chatterbox, ACE-Step, Qwen Image and Whisper large-v3 remain to be
staged and verified.
