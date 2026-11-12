---
id: 01a1d223-a439-734b-a94d-5e3babc32d4e
seq: 4
form: page
type: lesson
title: 'Burn subtitles without libass: agg GIF overlays plus a muxed mov_text track'
description: 'WHEN burned subtitles must render identically on macOS, Windows and Linux but the host ffmpeg lacks the subtitles/ass/drawtext filters (stock Homebrew ffmpeg 9 has no libass or libfreetype): render each cue as an agg .cast GIF with the bundled font and overlay it with enable=between(t,s,e), then mux the .ass/.srt itself with -c:s mov_text. WHEN this applies it beats requiring a libass ffmpeg build on every OS; verify timing by extracting the soft track (exact) plus frame-diffing banner pixels at cue edges.'
status: candidate
source:
    tool: muse-conductor-g
    episode: ep-b3037240f41048c4
    parent_episode: ep-09abc2249dbaeef7
created: "2026-11-12T23:41:53Z"
---
