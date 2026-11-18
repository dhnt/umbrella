# Sprint 615: shaping-enable an existing website (free host or owner outpost)

Sprint UUID: `899fe465-c505-558d-a1f3-44a74a977e92`. Epic: software-shaping.
Status: **planning only**. Filed 2026-11-10; rescoped 2026-11-18 (operator).
The sprint card and its stories are authoritative.

## Primary goal

Produce **the standard steps to shaping-enable an existing website**: a kb
runbook plus an agent-directed Bash# skill-script (`website.bsh`). Anyone with a
casual personal site or vlog can follow them at $0, using:

- free static hosting;
- a free AI tier;
- the free cloudbox sign-in;
- a free cloud workspace or their own outpost as the shaping host.

The steps include refactoring the site where it must change to work with
bashy and cloudbox.

Visitors fall into three tiers:

| Tier | Who | Gets |
|---|---|---|
| anonymous | not signed in | the site exactly as today, plus a plain "Shape / sign in for more" link |
| signed-in | signed in to cloudbox, not a member of the owner | shaped presentation (generated views, declared preferences) over the public data |
| circle member | in one of the owner's circles (for example `recruiter`) | additionally, the private data the site's permission config grants that circle (for example contact details and certificates) |

First run (dogfood): the operator's own public résumé site, a Next.js static
export on GitHub Pages. It runs on a **free host only**, to prove the point.
The owner-outpost path is documented and unit-tested, but not dogfooded here.

## Why the rescope

The first plan (2026-11-10) made a free workspace a generic shaping host. A
concrete site gives that host a reason to exist and adds the missing half: who
the visitor is and what they may see. Google on the host (old S4) and
satellite attach (old S5) are not needed for this use case and are deferred.

## What the code showed (2026-11-18)

- **Circles** are owner-defined slugs in cloudbox, so `recruiter` is valid.
- **Share rules** are `{circles, groups, emails}` and admit mutual members
  only. A member added without a circle lands in the default circle `guest`.
- **Cloudbox public covers admission; privacy needs one small hosted change
  (S11).**
  - An app registered with `require_login: false` admits anonymous visitors.
  - When the caller is signed in, the edge forwards their **email** as
    `X-Periscope-User` and writes an audit row the owner can read, even if
    the caller is no member of the owner (`host_proxy.go`). That discloses a
    stranger's address to the site owner and must change.
  - The door is the existing `/matrix/h/<host>/app/<app>/` path.
  - A stopped host gets the existing offline page (`hostOfflineHandler`).
- **What an app behind outpost receives:** only email, name and an
  `admin|user` role, signed by outpost. Outpost stamps no circle, groups or
  owner (Sprint 639 S13, not started). `yoke/pkg/coopauth.Identity` has no
  circle.
- **Shaping agent:** `bashy shape wish` delegates to an agent CLI
  (`--agent tool:model`). No free-provider route exists for shaping or for
  generated views. `yoke/pkg/llmgw/openai` is a reusable OpenAI-compatible
  client.
- **Sprint 638 overlap:** `website.bsh` (S3) and the shaping levels (S6) are not
  built. The Shape-page prefill is partial. The link-door decision (638
  decision 2) is open.
- **The test site:**
  - It already has a private-field content type its PDF route reads, and
    none of those files are committed.
  - It ships a small Go static server for local preview.
  - Its content is markdown.

## Design (smallest slice that delivers all three tiers)

1. **Two faces, one build.**
   - **Static face:** the site stays on its free static host. It is always on
     and serves anonymous visitors. It adds only a tier-0 link (a plain
     anchor: no script, no CSP change).
   - **Engine face:** the same source registered as a shaped app on the
     owner's shaping host. It is registered as a **cloudbox public** app
     (`require_login: false`) and reached through outpost at
     `/matrix/h/<host>/app/<app>/`. Anonymous visitors pass through.
   - **Privacy:** the site learns only what the relationship already
     discloses.
     - A non-member who signs in is known only as *authenticated*, plus a
       per-site pseudonym, so allowances can be counted. The pseudonym is
       stable for one site and unlinkable across sites. The site gets no
       email.
     - A member's email and circle are already known to the owner through the
       mutual membership.
2. **Engine mode by progressive enhancement** (the site refactor).
   - The built site calls `GET api/me`. On the static host that is a 404, and
     the site stays public-only.
   - On the engine it returns the caller's tier, and the site renders extra
     sections from `api/fields` and a views panel from `api/view`.
   - One build serves both faces.
3. **Site server.** A Go `shaped.json` server, scaffolded by `website.bsh
   enable`:
   - it serves the static build plus `api/me`, `api/fields` and `api/view`;
   - it reads the signed outpost identity and relationship stamp through
     `coopauth`;
   - a request without a valid signature is anonymous.
4. **Permission config = a per-field `audience`.**
   - Private fields live in a **private companion repo**, never in the site
     repo or the static build.
   - Each field's frontmatter carries `audience:` in the cloudbox rule grammar
     (`circles`, `groups`, `emails`, plus `signed_in: true` for any signed-in account),
     evaluated with yoke's boundary matcher.
   - **Fail closed:** a field without an audience is visible to the owner only.
5. **Visitors never code-shape a public site** (638·S10).
   - Signed-in visitors and members get declared-property personalization and generated
     **views**, such as a recruiter summary or a skills timeline. Views are
     rendered per request from only the data their tier may see.
   - Only the owner code-shapes, with `bashy shape` on the host.
   - Engine levels (638·S6) are therefore not a prerequisite.
6. **Free AI, provider-agnostic.**
   - `api/view` takes any OpenAI-compatible route: base URL, model and the key's
     secret name in `site.json`; the key itself in a host secret.
   - It enforces a per-visitor daily allowance plus an owner cap. The prompt
     carries allowed data only.
   - The docs list GitHub Models, Gemini free, Groq and OpenRouter free models.
   - **Two kinds of route, same config:**
     - **free API:** a provider's free tier, called directly with the owner's
       key;
     - **`bashy llm`:** the host's own OpenAI-compatible gateway (cligw,
       `yoke/pkg/cligw`) over the agent CLIs the owner already has, such as
       opencode and other tools with limited free access, or local models.
       It is reached on the host with the owner token and fits owners with an
       outpost (or a free host where the CLI is installed).
   - The site server never holds an agent CLI itself; it only calls a URL.
   - **BYOK:** this sprint covers the **site owner** only: the owner's
     own key, or `bashy llm` on the owner's outpost or satellite. Shaping on a
     visitor's own outpost (visitor BYOK) is supported by the design and filed
     as a follow-up.
   - Owner code-shaping uses an `--agent` CLI that can target a free route
     (spike).
7. **Hosts and graduation.**
   - **Free host** (a Codespace first, Gitpod second): the engine face is live
     while the workspace runs. When it is stopped, the engine face shows an
     offline page and the static face is unaffected.
   - **Owner outpost:** the same registration on a machine the owner keeps on.
     Moving between the two is `shaping-host graduate`.

## Stories

Vendor is the planned assignment by strength; the conductor may reassign.

| # | Story | Vendor |
|---|---|---|
| S1 `bddd4f6e0183` | `shaping-host.bsh` check / up / status / down / graduate. It detects the free platform, or an owner outpost where `up` is idempotent. Credentials come from platform or host secrets only. | codex |
| S2 `72f0077803c0` | Starter template = the private companion repo:<br>• devcontainer and `.gitpod.yml`;<br>• `private-fields/` with `audience:` examples;<br>• a `site.json` template.<br>It opens into a session with the public site imported as a shaped app. | glm |
| S3 `b95774378a90` | Stopped state on the client: `status` reports idle timeout and remaining free quota. The visitor-facing offline page already exists in cloudbox. | claude |
| S6 `20ce3526b52a` | Outpost start path without systemd. Only if S1 proves the gap; separate commit. | codex |
| S7 `65f9a8471919` | **The standard steps:** kb runbook "Shaping-enable an existing website" (owner role, generic names). It covers assess, refactor for engine mode, private data and audience, register, free host or owner outpost, free AI route, verify, graduate. Linked from the README shaping path. Written from what S13 and S14 actually ran. | muse |
| S8 `8ce4637753f4` (from 638) | `bashy/examples/shaping/website/website.bsh`:<br>• `assess DIR`: generator, export mode, content dirs, CSP, private-data candidates;<br>• `enable DIR`: `shaped.json`, `contract.bsh`, `checks/build.bsh`, the site-server scaffold, the `site.json` template, the tier-0 link;<br>• `register NAME --git URL`;<br>• `status`.<br>Next.js static export first, Vite second. | codex |
| S9 new | Site-server scaffold (Go, shipped by `enable`):<br>• static plus `api/me`, `api/fields`, `api/view`;<br>• audience evaluation with the yoke boundary matcher, fail closed;<br>• the matrix owner / circle / other circle / signed-in / anonymous / forged headers, on the CLI and over HTTP. | claude |
| S10 `0eaeb7a534e6` (from 639) | Outpost stamps the caller's circle, groups and owner for trust-identity apps; `coopauth.Identity` carries them. Signed and versioned, with the existing identity signature. | codex |
| S11 new | Hosted (public wire contract only), privacy for cloudbox-public apps:<br>• a signed-in caller who is not a mutual member of the host owner is forwarded as `authenticated` plus a per-(owner, host, app) pseudonym, never the email;<br>• the audit row for that access is pseudonymized as well;<br>• members and the owner are unchanged.<br>Acceptance: unit cases for non-member, member, owner and anonymous; a compatibility check of every existing `require_login: false` app that reads the email. Coordinate the release with the Sprint 664 conductor (todo `3bf3516ffb34`). | claude (cloudbox) |
| S12 new | Free-AI view route in the scaffold:<br>• OpenAI-compatible through `yoke/pkg/llmgw/openai`;<br>• key from a host secret;<br>• per-visitor allowance plus owner cap;<br>• a data-minimization test (the prompt holds only the tier's data).<br>Spike: owner code-shaping with an agent CLI on a free model. | codex |
| S13 new | Refactor the operator's résumé site by running `website.bsh assess` and `enable`:<br>• engine-mode client;<br>• the private-field type moved to the companion repo with `audience:`;<br>• `recruiter` fields (contact, certificates);<br>• views panel (recruiter summary, skills timeline);<br>• tier-0 link in the header and the no-script fallback.<br>Every manual step the scaffold missed is fixed in S8, not by hand. | claude |
| S14 new | Dogfood verification on the free host only. Evidence goes on the story. | claude |

Deferred to follow-ups: old S4 `e9bffaa179d1` (Google on the host) and old S5
`4e4452889dd8` (satellite attach), unlinked from this card. The owner-outpost
dogfood run is also deferred.

Order:
1. S10 and S11 (prerequisites, in parallel).
2. S8, then S9, then S12.
3. S2, S1 and S6.
4. S13, then S14, then S7.

S8 and S7 are the deliverable; S13 and S14 prove them.

## Gates

Each story passes its own acceptance plus the relevant targeted unit tests:
yoke and outpost `go test` for the touched packages; `GOWORK=off go build
./...` and the example's checks in bashy. Full gates stay in QA. No hosted CI
beyond the site's own static-host deploy. No containers or VMs on the dev box.

## Verification (recorded on S14)

1. **Anonymous.** The static site is unchanged apart from the tier-0 link.
   `api/me` is absent there. No private field appears anywhere in the built
   static artifact (grep it).
2. **Tiers.** The link opens the engine face, which offers sign-in:
   - a signed-in non-member gets `tier: signed-in` (public data plus views).
     The site server, its logs and the owner's audit view show a pseudonym,
     never the email;
   - a `recruiter` member also gets contact details and certificates;
   - a member of another circle gets neither;
   - the owner sees everything.
3. **Fail closed.** A field without an audience is owner-only. Identity headers
   without a valid signature are treated as anonymous.
4. **Free AI.** A view request is answered through the free route. The
   allowance is enforced. The recorded prompt holds only the tier's data.
5. **Owner shaping.** One `bashy shape` wish, verify and approve on the host.
   The change is pushed to the site repo and the static host redeploys.
6. **Session-scoped.** Stopping the workspace shows the offline page on the
   engine face while the static face is fine. Restarting keeps the host name,
   with no re-pairing.
7. **Owner outpost.** `shaping-host up` is idempotent on a home host (targeted
   test). The runbook covers the path.

## Not doing

Visitor BYOK and shaping on the visitor's own outpost (follow-up), a runtime overlay script on the public site, anonymous model calls, code
shaping by non-owners, keep-alive tricks on free workspaces, a workspace acting
as satellite or relay, and engine shaping levels (they stay in Sprint 638).

## Naming note (2026-11-18)

The tier for a signed-in non-member is `signed-in`, never `guest`. `guest`
is cloudbox's default **member circle**: a member added without a circle
lands there. If the site reused that name, a field shared with the guest
circle would leak to every cloudbox account.
