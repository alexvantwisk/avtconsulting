# Personal website upgrade

Spec: docs/superpowers/specs/2026-09-06-personal-website-design.md
Plan: docs/superpowers/plans/2026-09-06-personal-website.md

- [x] Step 0: docs (PR #10)
- [x] Step 1: foundation (Tasks 1–4, PR #11)
- [x] Step 2: consulting moved (Tasks 5–8, PR #12)
- [x] Step 3: home and About (Tasks 9–10, PR #13)
- [x] Step 4: CV (Tasks 11–12, PR #14)
- [x] Step 5: blog (Tasks 13–16, PR #15)
- [x] Step 6a: social card and Netlify parity (Tasks 17–18, PR #16)
- [ ] Step 6b: domain cutover (Task 19 A4–A5, Task 20; draft PR #17, waits for avantwisk.com)

## Review (2026-09-06)

**What shipped.** Eight stacked pull requests into `main`, to be merged in order #10 → #16, with #17 held as a draft until the domain exists. Every PR passed CI (Quarto 1.9.36 render plus an offline lychee link check). The site is now Alexander's personal site: home, About, hand-written CV, a blog with categories, full-text RSS and freeze-based R execution (two starter posts), the consulting pages moved as a unit under `/consulting/` with alias redirects and a subnav, a site-wide privacy notice covering POPIA and UK GDPR, a five-file stylesheet, a personal share card, and Netlify building with the same Quarto version as CI.

**Verified.** Each task was implemented by a fresh subagent and reviewed against its brief before the next started; a final whole-branch review found one Important defect (the site-level share image resolved per page directory), fixed in PR #16 by making the path root-absolute. Alias pages, the RSS feed, search indexing, and the freeze round-trip were all checked in the rendered output. CI on PR #15 proved the blog builds on a runner with no R installed.

**Deliberately left out.** CV PDF download (Alexander's choice; README explains how to add it), dark mode, comments, a Projects page, a separate Talks page, and any link between this repo and the Personal-CV project.

**Deviations from the plan.** Step PRs target `main` and stack on each other rather than waiting for merges; the 404 page is excluded from the link check until cutover; the 404 page's contact link was fixed in Step 2; Netlify config is kept until DNS moves because Netlify is live; Step 6 was split into a mergeable PR and a draft cutover PR.

**Open for Alexander.** Register avantwisk.com and follow the checklist in PR #17. Decide whether the contact page's "I reply within two business days" promise still holds during the PhD. Optionally align "MSc Biostatistics (Cum Laude)" on the consulting landing with "Passed with Distinction" on the CV; both are his own wording.
