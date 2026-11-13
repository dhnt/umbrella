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
| narrate-local / Chatterbox | `5bb1f6ee58e50c3b8d408bc82a6d3740c2db6e18` | `narrate-local/models/chatterbox/conds.pt` | 107,374 | `6552d70568833628ba019c6b03459e77fe71ca197d5c560cef9411bee9d87f4e` | 37 s for snapshot |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/s3gen.pt` | 1,057,165,844 | `9b9ff07e60b20c136e2b1b3d7563a24604e8d2c4c267888d1ee929dd0151d2a3` | included above |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/t3_cfg.pt` | 1,064,892,246 | `0b2dd5439fe7e94f379561419847a45bf2c79d0e8ea751c6bbe947ce337789cc` | included above |
| narrate-local / Chatterbox | same | `narrate-local/models/chatterbox/ve.pt` | 5,698,626 | `4b16d836bc598509860f6fa068165a8bb5e9ac84f05582dfcf278a5a372879f1` | included above |

Kokoro's other voice files and configuration, and Chatterbox's tokenizer,
were downloaded in their respective snapshots. ACE-Step, Qwen Image and
Whisper large-v3 remain to be staged and verified. These local snapshots
are staged bytes; the rods need explicit local model/cache binding before a
future render to guarantee they use the same revisions without downloading.
