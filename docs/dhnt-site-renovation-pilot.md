# Renovate dhnt.io through software shaping

Sprint 707 · `7dd246c4-2465-51e2-ad46-eee5805e276f` · Backlog brief, 2026-11-24. The card and its five linked stories track delivery. This filing records proposed copy, a commercial offer to test and future tests.

## Why an owner would buy

Start with the operations owner who pays people to chase incomplete client intake forms. Ask for the last three submissions that needed follow-up. What did the customer miss? Who intervened? How long did it take? If one obvious fix helps every customer, improve the default. Shaping earns its keep when different customers repeatedly need different ways through the same workflow.

**Proposed owner offer.** “Help more customers finish your form on their own. Bring us one form people get stuck on. We’ll set up a paid pilot and measure how many submissions arrive complete on the first try.” Pair **Try the form** with **Request a paid pilot**. The inquiry should ask for the workflow and the recurring difficulty, without requesting customer records. The offer is a proposal for the renovation.

The owner chooses the surface and the rules. In the intake example, visitors could request a checklist of what remains. Required fields, consent text and validation must hold across versions. Keep visitors on declared choices unless the app and caller are authorized for more. Useful variations can become an owner-reviewed improvement for other customers.

| Buyer | Example job | Outcome to measure |
| --- | --- | --- |
| Intake or operations lead | Get a complete application on the first pass | Complete submissions per start, follow-ups per submission, staff minutes |
| Catalog or sales lead | Help a buyer compare products on the specifications their job requires | Qualified quote requests per eligible visit, specification questions per quote |
| B2B app product lead | Serve different customer workflows without maintaining a separate release for each account | Repeat customization tickets, delivery and ongoing support hours, adoption of a variation by a second account |

Product-finding studies support the catalog problem. A pilot would still need to show incremental value over the site's existing filters and comparison tools. [Baymard product-list and filtering research](https://baymard.com/research/ecommerce-product-lists)

For the proposed fixed-fee pilot, scope one workflow, owner-approved changes, setup, checks, measurement and a results review. Agree a baseline, comparison window, minimum worthwhile improvement and a quoted fee before starting. Compare staff time saved and any attributable value of additional completed transactions with setup, review, hosting, model and maintenance costs. If the owner wants ongoing operation after the trial, test a recurring managed-service offer with that buyer. Keep inquiries, accepted quotes, payments and renewals as separate evidence.

## What a visitor should understand

**Tell the app what you’d like to change. Try it. Keep it if it helps.** Give the visitor something familiar to change before introducing the term *software shaping*. The public homepage already has a Shape this page entry and an installation path. Make the former the first action and keep the latter easy for builders to find. [Current homepage](https://dhnt.io/index.md)

| Audience | Proposed words | Action |
| --- | --- | --- |
| First-time visitor | “How would you like this page to look? Try a change and see it on this page. Sign in if you want to keep it.” | Shape this page |
| Someone using a form | “Put the questions I still need to answer at the top.” | Try it on a half-filled example |
| Form or board owner | “Give people a way to change your app in their own words. You define what must keep working. They try the change and decide whether to keep it.” | Explore bashy |

For builders, show where the work happens. Cloudbox coordinates access. A Satellite connects an owner or team with their hosts. Outpost brings the app on the owner's machine into reach. bashy exposes the workflow, Yoke checks and activates changes, and Bash and Bash# give authors a scripting foundation for repeatable checks. Web activation can be personal. CLI and service activation is host-scoped. Phrase every invitation for the authority available at that step. Anonymous visitors can try declared choices. Source-changing wishes require an authorized path. [Shaping contract](../bashy/docs/shape-contract.md) · [Activation scope](../yoke/pkg/shape/program.go) · [Access-tier plan](sprint-706-master-execution-plan.md)

## Why test this distinction

| Prior work | Consequence for the pilot |
| --- | --- |
| Customaise describes spoken or typed website changes. MorphGUI studied functional and visual calendar customization with 18 participants. [Customaise](https://github.com/getcustomaise) · [MorphGUI paper](https://doi.org/10.1016/j.ijhcs.2025.103695) | Use page appearance for the first interaction, then demonstrate a behavior change with a rule the owner can check. |
| Grist offers private copies, comparison and replacement. Replit offers agent checkpoints and rollback. [Grist](https://support.getgrist.com/copying-docs/) · [Replit](https://docs.replit.com/replit-workspace/workspace-features/version-control) | Show who receives an approved change and what happens when a plausible change would lose an answer. |
| Ink & Switch documents personal tools at the point of use. CHI research reports difficulty judging whether generated code matches a beginner’s intent. [Malleable software](https://www.inkandswitch.com/essay/malleable-software/) · [CHI study](https://doi.org/10.1145/3613904.3642706) | Give participants a working preview and an understandable failure. Ask them to explain the outcome in their own words. |

The moat hypothesis is that each participating app can accumulate useful, voluntarily shared changes with repeatable checks and evidence about the versions they work with. A second owner adopting a checked change is the smallest test of whether that asset has value beyond its creator. Market exclusivity, cross-app upgrade survival and comparative cost savings require separate evidence.

## Stories and acceptance

1. **R1 · Positioning · `687dbcdb18e4`.** Draft the visitor and builder paths above. For each public claim, record the supporting source or observed journey and its scope. Mark proposed copy awaiting evidence. The maintainer of a shared form or board is the initial audience for adoption.
2. **R2 · Owner renovates dhnt.io · `8121ff032fab`.** After R1, submit the homepage renovation through the existing site’s owner shaping workflow on staging. Example wish: “Let visitors try changing this page first. Put the bashy installation link under a heading for people who build apps.” Record the exact wish, starting revision, candidate and preview. Check the rendered and no-JavaScript page, Shape link, About and install links, and Markdown/JSON representations. Rehearse approval and undo. Save before/after evidence and the step, error and workaround if the owner needs help. A direct edit is a recorded gap in this test. Hosted publication belongs to the normal release train.
3. **R3 · Visitor and form user · `18cdc29586a5`.** On the R2 candidate, observe a first-time visitor find Shape, try an available change and explain who sees it and what signing in keeps. In the existing form, have an authorized participant ask to move unanswered required fields first. Use two separate sessions and synthetic answers. Inspect the preview, keep it, reopen, observe the other person's view, then undo. Check answer values before and after each transition. A missing agent, permission or feature is a result to capture. [Form wishes](../bashy/examples/desk/form/shaped.json)
4. **R4 · Test the moat · `ae8ec2cd89e2`.** With the same form, present a candidate that violates the answer-preservation rule. Record whether a declared check catches it, whether activation is refused, and what the person understands. Offer a good change to a second owner through the existing promotion path. Record their independent review and decision. Recheck against one identified upstream update, recording clean adoption, conflict, refusal or manual repair. Keep the original revision available. [Approval](../yoke/pkg/shape/service.go) · [Promotion](../yoke/pkg/shape/promotion.go)

5. **R5 · Buying decision · `18a4076d5db7`.** Prepare the offer and buyer CTA alongside R1. Use R3/R4 to substantiate the pitch. For authorized buyer discovery, document the owner, current workaround, economic baseline, quoted scope and price, and whether they commit, decline or ask for different terms. Record an untested offer as untested. Clicks indicate interest. A paid pilot tests willingness to pay.

For each attempted case record the app and revisions, participant role, expected and observed outcome, elapsed time, help needed, and a reproducible evidence reference. Use synthetic data and public-safe role labels. Summarize which promises the observations support, the single biggest obstacle, and the next product decision. A missed check is a finding. Two participants and one update establish a case study.

## Reuse and boundaries

Reuse the existing company site (693, `a7400f6ee26e`), public page representations (693, `4fc13e0db790`) and badge (641, `fd88e341de41`). The earlier company-site onboarding story (638, `2125438f19c3`) was superseded. The ai.dhnt.io teaching journey (`d7b76350c028`) has its own destination. Coordinate with 706 for member permissions. Keep the shelved catalog-wide and commercial benchmarks in 632 in their recorded disposition. This sprint sizes one homepage, one form and one update.
