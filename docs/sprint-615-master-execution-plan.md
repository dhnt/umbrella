# Sprint 615: a shaping-enabled simple site (showcase MVP)

Sprint UUID: `899fe465-c505-558d-a1f3-44a74a977e92`. Epic: software-shaping.
Status: **done** (updated 2026-11-24: 15/17 stories done, 2 wontfix; S21 moved to Sprint 706 as R6). Filed 2026-11-10; rescoped 2026-11-18 (operator),
cut to the MVP the same day. The follow-up is Sprint 665
(`482ac62d-1c0e-5e38-9236-c7c5893f895c`). The sprint cards and their stories
are authoritative.

## Primary goal (KISS / MVP)

Show software shaping enabled on a simple existing site, at $0, using the
operator's own public résumé site as the test:

- a Next.js static export on GitHub Pages;
- a free cloud workspace (Codespace) as the shaping host;
- a free AI tier;
- the free cloudbox sign-in.

The sprint proves the feature end to end and writes down the steps that
worked. Everything else goes to Sprint 665.

| Relationship | Gets | Site learns |
|---|---|---|
| anonymous | the site exactly as today, plus a plain "Shape / sign in for more" link | nothing |
| account (not a member) | public data plus one generated view (a recruiter summary) | "authenticated" plus a per-site pseudonym, **never the email** |
| member of a circle (e.g. `recruiter`) | additionally the private fields granted to that circle (contact details, certificates) | email and circle, already known through the mutual membership |
| owner | everything, and shapes the site with `bashy shape` on the host | everything |

For privileged data, the MVP adds a "Request access" contact link. The visitor
reaches the owner by their own action. The owner grants access with the
existing member invite and a circle. A consented in-product request flow is in
Sprint 665.

## What the code showed (2026-11-18)

- **Circles** are owner-defined slugs. `guest` is the default **member**
  circle, so the non-member relationship is named `account`, never `guest`
  (initially `signed-in`, kept as a one-release wire alias during Sprint 706 R1).
- **Cloudbox public** (`require_login: false`) admits anonymous visitors,
  serves the app at `/matrix/h/<host>/app/<app>/`, and shows an offline page
  when the host is stopped (`hostOfflineHandler`).
- **The privacy gap:** for an `account` caller, the edge forwards the email
  (`X-Periscope-User`) and audits it for the owner, even for a non-member.
- **Outpost** stamps email and `admin|user` (OS elevation) only, with no circle.
  `yoke/pkg/coopauth.Identity` has no circle.
- **Reusable pieces:**
  - `yoke/pkg/llmgw/openai` is an OpenAI-compatible client;
  - `bashy llm` (cligw) is an OpenAI-compatible gateway over the agent CLIs, so
    it plugs into the same configuration.
- **The test site:**
  - its markdown content lives under `edit-me/content/`;
  - it has an existing private-field type, with no files committed;
  - it includes a small Go static server.

## Design

1. **Two faces, one build.**
   - The static face stays on GitHub Pages. The only change is the tier-0 link.
   - The engine face is the same source, registered as a cloudbox-public
     shaped app on the shaping host.
   - The built site calls `api/me`. On Pages that is a 404, so the site stays
     public-only. On the engine it renders the extra sections and the view.
2. **Site server.** A small Go `shaped.json` server, scaffolded:
   - it serves the static build plus `api/me`, `api/fields` and `api/view`;
   - identity comes through `coopauth`, and an unsigned request is anonymous.
3. **Audience.**
   - Private fields live in a private companion repo, with `audience:` in the
     cloudbox rule grammar plus `account: true` (today `signed_in: true`).
   - **Fail closed:** no audience means owner-only. Never in the Pages build.
4. **Free AI.** One OpenAI-compatible route: base URL, model and the key's
   secret name in `site.json` (owner BYOK). It has a simple daily cap. The
   prompt carries only the caller's allowed data. A free API tier and
   `bashy llm` on the owner's host both fit, and the MVP tests one.
5. **Visitors never code-shape a public site.** Only the owner shapes, with
   `bashy shape` on the host. The change is pushed to the site repo and Pages
   redeploys.

## Stories (MVP)

| # | Story | Vendor |
|---|---|---|
| S10 `0eaeb7a534e6` | Outpost carries the relationship to trust-identity apps:<br>• a member gets circle and groups;<br>• the owner gets the owner flag;<br>• a non-member gets authenticated plus a pseudonym, never an email;<br>• `coopauth.Identity` carries these fields. | codex |
| S11 `a455574ee679` | Cloudbox-public privacy: an `account` non-member is forwarded as authenticated plus a per-site pseudonym (computed, not stored), and the audit row is pseudonymized too. Members and the owner are unchanged. Hosted change, public wire contract only. Shares the held release with Sprint 664. | claude |
| S8 `8ce4637753f4` | `website.bsh assess / enable / register` for a Next.js static export. | codex |
| S9 `947daaceea4b` | Site-server scaffold:<br>• `api/me`, `api/fields`, `api/view`;<br>• fail-closed audience;<br>• matrix tests for owner, recruiter, other circle, account, anonymous and forged headers. | claude |
| S12 `393725804606` | AI view route: one OpenAI-compatible route, owner BYOK, daily cap, data-minimization test. | codex |
| S2 `72f0077803c0` | Private companion repo template:<br>• a Codespaces devcontainer that runs `shaping-host up`;<br>• `private-fields/` with `audience:`;<br>• `site.json`. | glm |
| S1 `bddd4f6e0183` | `shaping-host.bsh check / up / status` on a Codespace. | codex |
| S6 `20ce3526b52a` | Outpost start path without systemd. Only if S1 proves the gap. | codex |
| S13 `f7649d9479f5` | Refactor the résumé site by running `website.bsh`:<br>• the engine-mode client;<br>• the recruiter fields;<br>• one view (recruiter summary);<br>• the tier-0 link;<br>• a "Request access" contact link. | claude |
| S14 `78cde8d8d896` | Showcase verification on the Codespace (below). Evidence goes on the story. | claude |
| S7 `65f9a8471919` | A lean kb runbook covering the steps that actually ran. | muse |

Order:
1. S10 and S11 in parallel.
2. S8, then S9, then S12.
3. S2, then S1, plus S6 if S1 proves the gap.
4. S13, then S14, then S7.

## Verification (S14, the showcase)

1. **Anonymous.** The Pages site is unchanged apart from the link. No private
   field appears in the build artifact (grep it).
2. **The four relationships on the engine face:**
   - an `account` non-member gets `account` (public data plus the view). The
     site server and its logs show a pseudonym, never an email;
   - a `recruiter` member gets contact details and certificates;
   - a member of another circle gets neither;
   - the owner sees everything.
3. **Fail closed.** A field without an audience is owner-only. Forged identity
   headers are treated as anonymous.
4. **The view.** A recruiter summary is generated through the free route from
   only the caller's data. The cap is enforced.
5. **Owner shaping.** One `bashy shape` wish, verify and approve on the host.
   The change is pushed and Pages redeploys.
6. **Stopped host.** Stopping the Codespace shows the cloudbox offline page;
   Pages is unaffected.

Gates: targeted unit tests per story. Full gates stay in QA. No hosted CI
beyond the site's own Pages deploy.

## Moved to Sprint 665 (follow-up)

- **Consented access request:** the edge forwards the email only after an
  explicit "share your email with the owner?" confirmation, for one request to
  `api/request`. The owner grants with the existing invite and a circle.
- **Visitor BYOK:** shaping a site's views on the visitor's own outpost
  (`cdf9dd171b63`).
- **The owner's own outpost or satellite as the host:** `shaping-host down` /
  `graduate`, and a live run of `bashy llm` as the route.
- **Stopped-state reporting** (idle timeout and free quota), old S3
  `b95774378a90`.
- **Gitpod and Vite** support in the template and `website.bsh`.
- **Visitor personalization** of declared properties, and more views (for
  example a skills timeline).
- **Google on the host** (old S4 `e9bffaa179d1`) and **satellite attach**
  (old S5 `4e4452889dd8`).

## Future design note: identity assurance levels (plan only)

The four relationships use one axis (anonymous, account,
member of a circle, owner). A second axis is **how well the caller is
identified**, borrowed from marketplaces such as freelancer sites that badge
their participants:

| Level | Meaning |
|---|---|
| `anonymous` | no sign-in |
| `authenticated` | a valid cloudbox login (OAuth), shown to sites as a pseudonym |
| `email` | the email disclosed by consent, or known through membership |
| `verified` | identity verified by a third-party verification provider (for example a government ID and photo match) |

Design rules for later:
- An audience may require a minimum level (for example `level: verified` for
  certificates).
- Levels and relationships combine. A circle still bounds what is shown;
  levels only narrow it.
- Cloudbox stores only the outcome, as relationship data: level, provider and
  date. Documents, ID numbers and photos are never stored or forwarded.
- Sites receive the level, never the evidence.
- Verification goes through an external provider and is opt-in by the
  visitor.

No story in Sprint 615 or 665 implements this. It is tracked as a design todo.

## Not doing

Code shaping by non-owners, anonymous model calls, a runtime overlay script on
the public site, keep-alive tricks on free workspaces, and engine shaping
levels (those stay in Sprint 638).
