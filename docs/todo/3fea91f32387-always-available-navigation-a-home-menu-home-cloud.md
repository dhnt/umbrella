---
id: 3fea91f32387
kind: bug
title: 'Always-available navigation: a home menu (Home, Cloudbox, satellites, hosts, sign in/out) in every mode, plus a Shape-only strip'
seq: 532
status: todo
priority: p1
labels:
    - desktop
    - ux
created: 2026-11-19T14:40:39.806498Z
assignee: claude-sonnet5.5
sprint: 641
sprint_id: d8aa925c-ba20-5705-ba28-33bc35700909
sprint_title: 'MVP phase A: voice input + dhnt.io cosmetic — the free desktop you shape by asking'
---

Seen live 2026-11-19 on v0.18.77: the operator reported 'cloudbox is broken / always redirects to /periscope/'. Root cause: their desktop had shapeOnly=true (toggled from the Shape panel during the J3 test). Shape-only hides the whole header (logo, Install, history, settings, theme, Cloudbox, account; 8 controls present but hidden), leaving only the round Flow button bottom-right, with nothing saying that controls are hidden or how to restore them. (The / -> /periscope/ redirect for any session cookie is long-standing, routes_spa.go, and was not the fault.) Fix (small, UI): in Shape-only mode show a persistent, unmissable affordance, e.g. a slim top strip 'Shape-only mode: controls hidden' with a 'Show controls' button, plus an Esc or keyboard path; make the toggle's effect explicit when switching it on. Done when: a fresh user who enables Shape-only can see that it's on and restore controls without opening the Shape panel; a vitest or DOM test covers the strip; the J6 record includes this.

## Expanded scope (operator, 2026-11-19): always-available navigation

The operator asked for navigation that is always reachable: home for cloudbox, satellite and outpost, plus login and logout, in a collapsed menu or better UX, design left to the conductor. Design (KISS, reuse):

- One persistent **home menu** button, top-left, visible in normal AND Shape-only mode, collapsed by default. Reuse the collapsed mobile header navigation from Sprint 659 (cloudbox d469e3f, periscope-layout.tsx); no new component family.
- Menu items: **Home** (Periscope launcher), **Cloudbox** (account console), **Your satellites** (one link per satellite home, from data the SPA already loads), **Your outposts / hosts** (one link per host page), the account email with **Sign in / Sign out** (existing auth routes), and **Show all controls** (only while Shape-only is on).
- **Shape-only strip**: a slim, persistent strip "Shape-only mode · controls hidden · Show controls" while shapeOnly=true.
- **Keyboard**: Alt+M opens the menu and Esc closes it (agents and screen readers). Proper aria (button aria-expanded, menu role).
- **Scope now**: cloudbox SPA (master and satellite share it). **Follow-up**: outpost admin UI gets the same menu (links to Cloudbox, its satellite, and back), filed separately.
- Not in scope: changing the / -> /periscope/ redirect.

Done when: in both modes the menu opens by click and Alt+M and lists home, Cloudbox, satellites, hosts and sign in/out; Shape-only shows the strip and the menu restores controls; vitest covers the menu and strip; tsc and eslint are clean; it renders in a browser check (stubbed preview); the conductor verifies it live after the next cloudbox build. Build and test rules as on the other Sprint 641 stories (focused tests; cloudbox Linux tests on the test host via the Windows test host's narrow WSL resources (see `bashy resource list`); no tag or deploy).

## Added scope (operator, 2026-11-19): visible desktop actions

Clear recents, Clear favorites, Undo, History and Refresh are unstyled plain buttons hidden inside the collapsed "Settings, undo, and history" section of the Shape panel (cloudbox ui/src/features/desktop-settings/settings.tsx). Make them visible:
- A clear toolbar of labelled outline buttons with icons. Undo has a visible disabled state with a tooltip at revision 0.
- Clear recents and Clear favorites use a cautionary but visible style. They are undoable, so show "Cleared. Undo" instead of a confirmation dialog.
- Undo and History are promoted into the Shape panel's main action row next to Apply (signed in). "Undo last change" also appears in the home menu.
- vitest covers accessible names, Undo disabled at revision 0, and Undo/History in the main row.
