---
id: 01a1d40d-9801-7bb0-9930-58ff2206924f
seq: 6
form: page
type: gotcha
title: FLUX.2 klein single-file checkpoint does not complete a Diffusers draft pipeline
description: 'WHEN staging FLUX.2 klein-4B for an offline image.generate or image.edit rod: the 7.75 GB single-file checkpoint is separate from the pinned Diffusers transformer, text encoder, tokenizer, VAE, scheduler and model_index.json. Stage and hash the full pipeline once; load from a local directory with Hub/Transformers offline flags. Register only the light rod by default, since two available oss image rods make an unqualified provider selection ambiguous. Evidence: Sprint 627 M2b-image live generate/edit.'
status: candidate
source:
    tool: codex-gpt6-sol-j
    episode: ep-b8d1249c9e2a2df4
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-13T08:37:03Z"
---
