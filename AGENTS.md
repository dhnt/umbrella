# AGENTS.md

Short alias for non-Claude agents. See `CLAUDE.md` in this directory for the
full agent-facing brief — it is the one file to read; this one only redirects.

- **`bashy sprint` is the source of requests, plans and details.** Read the
  card, not the docs. Delivery commits carry `Sprint:` / `Story:` /
  `Story-ID:` trailers (the `commit-msg` guard is fail-closed).
- The umbrella tracks **commit SHAs**. Edit + commit + push *inside* the
  submodule, then `git add <subproject>` at the root and commit the pin bump.
- **Everything in this repo is public.** No machine names, OS logins,
  addresses or credentials — `script/scrub-gate.sh` refuses the commit.
