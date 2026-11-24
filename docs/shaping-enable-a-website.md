# Shaping-enable your website (owner guide)

Your site stays where it is (GitHub Pages, any static host). A small
shaping layer — its own shaped app, kept in a **private companion repo** —
fronts it through outpost as a cloudbox-public app, injects a panel into
every page, and serves callers by relationship. This guide is for the site OWNER.

Sources of truth: `bashy/examples/shaping/website/` (`README.md`,
`website.bsh`, `template/`) for the layer, `bashy/examples/shaping-host/shaping-host.bsh`
(its skill face) for the host, and `outpost/docs/cooperative-web-apps.md`
(the relationship section) for how the site knows who a visitor is.

A website is an app with sub-apps: for shaping-enabling any single app for
its consumers (the `shaped.json` manifest, `bashy app add --type shaped`,
CLI address handoff, member wish → undo), follow the bashy KB runbook
`enable-an-app-for-consumer-shaping` (`bashy kb search "enable an app for shaping"`).

## What you get: the four relationships

| Relationship | Gets | Your site learns |
|---|---|---|
| anonymous | the page as today, and a sign-in hint | nothing |
| account (not a member) | views open to `account` (today `signed_in`; e.g. a recruiter summary) | a per-site pseudonym, never the email |
| member of a circle | also the fields whose audience admits that circle | email and circle |
| owner | everything; shapes the layer with `bashy shape` | everything |

Identity is outpost's signed relationship stamp (`X-Outpost-Relationship`,
`-Circle`, `-Groups`, `-Visitor`, `-Relationship-Sig`; see the
cooperative-web-apps relationship section). Unsigned, stale, or forged
headers are anonymous. Outpost never forwards a non-member's address: an
`account` caller (wire alias `signed-in` during Sprint 706 R1) who is neither
the owner nor a member reaches the app as a stable per-site pseudonym,
unlinkable across sites.

## What you need

- Your site: any static site at a public URL (e.g. `https://example.com`).
- A GitHub account (for the private companion repo and the free Codespace
  host, if you use it).
- A cloudbox account (for the one-time pairing code).
- A satellite to attach the host to.
- One OpenAI-compatible route for the generated views: a free Gemini API
  key from Google AI Studio (the default), Groq or OpenRouter free models,
  or `bashy llm` on your own machine.
  Views call it with only the caller's own data (public page text plus
  admitted fields). No anonymous model calls; a per-caller and a total
  daily cap protect the free quota.

## Steps

All commands run with `bashy --bashsharp`. The script orders existing
verbs (`curl`, `go build`, `outpost apps add/secret`, `bashy app add`);
every step accepts `--dry-run` to print the calls first.

### 1. Assess your site

```bash
bashy --bashsharp website.bsh assess https://example.com
```

Reports whether the site is reachable, what generated it, whether it
uses root-absolute links (rebased automatically under the mount prefix),
and whether it sends a CSP.

### 2. Enable into a private companion repo

```bash
bashy --bashsharp website.bsh enable ~/my-site-shaping --site https://example.com --title "My Name" --contact mailto:me@example.com
```

This writes the shaping layer into the directory: the stdlib-only Go
server, `site.json`, `fields/`, `public/shaping.{js,css}`, `shaped.json`,
`contract.bsh`, `checks/`, plus `.devcontainer/` and `bin/` copies of the
two skill-scripts. Push it as a **private** repo: `fields/*.md` hold
private facts and must never reach the static build. The site repo stays
public and unchanged except for the one link in step 6.

### 3. Edit `site.json` and `fields/*.md`

- `site.json`: title, contact, the AI route (`base_url`, `model`,
  `key_env` — `SITE_AI_KEY` by default), daily caps, and views with
  their prompts and audiences. The default route is Gemini's
  OpenAI-compatible endpoint with `gemini-flash-lite-latest` (free tier;
  prompts may be used for training, and only the caller's allowed data is
  sent). GitHub Models was tried first and did not serve completions
  during the first live run (every path answered a plain "OK").
- `fields/*.md`: one private fact per file. Audience is the front matter
  — `circles:`, `groups:`, `emails:`, `account:` (today `signed_in:`) — using the cloudbox
  rule grammar plus `account` (circles AND (group OR email); a group
  never widens across circles). A field with no audience is owner-only:
  audience fails closed.

### 4. Bring up the shaping host

Two options.

**A free Codespace (session-scoped).** Push the companion repo as
private, set three Codespace secrets, and open it in a Codespace:

| Secret | Used for |
|---|---|
| `BASHY_PAIR_CODE` | one-time pairing code from your cloudbox account (first start only) |
| `SHAPING_SATELLITE` | your satellite to attach to |
| `SITE_AI_KEY` | the key for the AI route in `site.json` |

On every start the container runs `shaping-host up` (installs bashy and
outpost if missing, pairs once under a stable host name, attaches to
your satellite, starts the daemon — no systemd) and then
`website serve`. A stopped workspace shows visitors the cloudbox offline
page while the static site keeps working; a workspace is never a
satellite or a relay.

**Your own machine.** Run the same two commands yourself:

```bash
bashy --bashsharp shaping-host.bsh up
export SITE_AI_KEY=...
bashy --bashsharp website.bsh serve ~/my-site-shaping --name site
```

`serve` builds the server, registers the outpost app (cloudbox public,
trusted identity), reads its SSO secret, and runs it on loopback.

### 5. Register for owner shaping

```bash
bashy --bashsharp website.bsh register ~/my-site-shaping --name site
```

This registers the companion repo as a shaped app so the owner shapes
the layer with `bashy shape` (wish, verify, preview, approve); run
`serve` again to publish the approved build. Visitors never code-shape
the site — only the owner shapes, on the host.

### 6. Add the one link to the static site

```html
<a href="https://<your satellite>/matrix/h/<host>/app/<name>/">Shape this page</a>
```

That engine face is where the panel appears. Visitors reach your site
two ways: the static host, unchanged, and the engine face with the panel.

## Verify and graduate

- `website status` shows the server, the outpost app, and the engine URL;
  `website stop` stops the server (the static site is unaffected).
- The template's own tests cover the tier matrix, forged stamps,
  fail-closed fields, link rebasing, and the view's data minimization
  and caps: `GOWORK=off go -C <companion-repo> test ./...`.
- Graduate when the site must always be on: move the layer from the
  session-scoped Codespace to your own outpost or satellite and serve it
  there. Nothing else changes — same repo, same link shape.

## What the first live run taught (2026-11-18)

The steps above ran end to end on a Next.js static export hosted on a free
static host, first on a free cloud workspace and then on the owner's
always-on Windows outpost behind their satellite. Details and fixes are in
the bashy kb (`bashy kb search shaping`):

- **Sign-in.** Visitors sign in on the satellite. Use
  `/cloud/signin?next=<page>` so they land back on the page; the panel
  does this. A satellite admits only active members, so an invitee must
  accept once. Master sessions do not yet carry to satellites, and master
  sign-out does not end satellite sessions (follow-ups filed).
- **Assets.** Assets must come from the static host, never through the
  engine (the edge rate-limits anonymous requests). App-router sites need
  `"static_only": true`; the panel fills the page's
  `data-shaping-contact` / `data-shaping-signin` hooks.
- **Owner shaping** needs the console started with a shaping agent
  (`--shape-agent`); without one, wishes are refused. Choose a route you
  own (your key, your subscription, or a local model). Free tiers may
  hang under an agent's load. The console finds Go through `bashy go`, so
  a host with only bashy installed can build shaped servers.
- **Private values** such as a phone number go in through a copysheet:
  the human types them once, and the agent writes them into the private
  fields without ever seeing them.
- **Tutorials** can be published to the owner's YouTube channel by an
  agent (`bashy google youtube-upload`, in a separate permission slot) and
  linked from a practice app.

