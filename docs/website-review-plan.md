# Website Review & Improvement Plan

## Status

- Phases 1–2 implemented (2026-07-14)
- Phase 3 implemented and fully activated: Formspree + Google Analytics live (see `docs/phase3-activation.md`)
- Phase 4 not started

**Reviewed:** 2026-07-14 · **Scope:** full source review of the AVT Consulting Quarto site
(`_quarto.yml`, all four pages, `styles.scss`, `images/`, CI workflow, original design spec)

---

## Executive summary

The site is in good shape for what it is: a focused four-page consulting site with a clear
audience, warm copy, a coherent visual identity, and a sensible zero-maintenance stack
(Quarto + GitHub Pages). Nothing here is broken.

The biggest opportunities, in order of impact:

1. **Conversion:** every call to action is a `mailto:` link. For your audience (grad students
   on university machines using webmail), clicking it often opens *nothing* — the single
   biggest silent leak in the funnel. Add a lightweight contact form as the primary CTA.
2. **Discoverability:** the site currently ships no sitemap, no social-share preview, no
   per-page descriptions, and no favicon. All are one-line-ish config fixes.
3. **Trust signals:** no pricing guidance, no confidentiality/POPIA statement, no response-time
   promise (the design spec called for one and it was never filled in). For medical/health
   researchers these are the questions that decide whether they email you.
4. **Accessibility:** three measured WCAG contrast failures, all fixable in the SCSS palette.
5. **Performance:** one 508 KB PNG headshot is nearly the entire page weight.

Everything is organized below as findings → phased roadmap, with severity and effort labels.

---

## What's already good (keep it)

- **Clear positioning.** "Biostatistics for medical/public-health researchers, from design to
  publication" is specific and credible. The hero headline is genuinely good.
- **Structured mailto template.** Pre-filling the inquiry email with the fields you need is a
  smart, zero-backend intake form.
- **Free consultation offer** is stated consistently on Home, Services, and Contact.
- **System font stack** (Georgia + system sans) — zero webfont bloat, loads instantly.
- **Reproducibility as a selling point** ("R + Quarto reports you can re-run") differentiates
  you and matches how the site itself is built. Nice coherence.
- **Simple, correct CI** — Quarto render → Pages deploy, with proper concurrency guard.

---

## Findings

### 1. SEO & metadata

| # | Finding | Severity |
|---|---------|----------|
| 1.1 | **No `site-url` in `_quarto.yml`.** Without it Quarto generates no `sitemap.xml` and no canonical URLs. Search engines are guessing. | High |
| 1.2 | **No Open Graph / Twitter card metadata.** When the link is shared on LinkedIn or WhatsApp — realistically your top referral channels — there is no preview image, title, or description. | High |
| 1.3 | **No per-page `description`** in any `.qmd` front matter; every page falls back to the one site-level description. | Medium |
| 1.4 | **Duplicate H1 on the home page.** `index.qmd` has `title: "Statistical Consulting"` (rendered as an H1 title block) *and* the hero `# The best time…` heading. Two H1s, and the plain title block above the hero is visually redundant. Replace `title:` with `pagetitle:` (sets the `<title>` tag without rendering a heading). | Medium |
| 1.5 | **No favicon** — browser tabs show the default globe. `website.favicon:` is one line. | Low |
| 1.6 | **No 404 page.** GitHub Pages serves its generic one. Add a `404.qmd` with a link home. | Low |
| 1.7 | **No structured data.** A small JSON-LD `ProfessionalService` block (name, URL, area served, LinkedIn `sameAs`) helps local queries like "biostatistician Pretoria". | Low |
| 1.8 | **`lang` not set explicitly** in `_quarto.yml`. Add `lang: en` so the HTML `lang` attribute is guaranteed (screen readers, translation tools). | Low |

Suggested config (covers 1.1, 1.2, 1.5, 1.8):

```yaml
lang: en

website:
  title: "AVT Consulting"
  site-url: https://alexvantwisk.github.io/avtconsulting   # or custom domain later
  favicon: images/favicon.png
  open-graph: true
  twitter-card: true
  image: images/social-card.png   # 1200x630 share image — headshot + name + tagline
```

### 2. Conversion & content

| # | Finding | Severity |
|---|---------|----------|
| 2.1 | **`mailto:`-only CTAs are a conversion leak.** On machines without a configured mail client (most university lab PCs, many students on webmail) clicking the button does nothing, and the visitor rarely comes back. Add a free-tier form service (Formspree, Tally, or Web3Forms — all work on static sites) as the primary CTA, keep the mailto as the secondary option. This is the single highest-impact change on the list. | High |
| 2.2 | **No response-time promise.** The original design spec explicitly called for one on the Contact page ("to be filled in by Alexander") and it never was. "I reply within 2 business days" costs nothing and measurably lowers the barrier to emailing a stranger. | High |
| 2.3 | **No pricing signal anywhere.** You don't need a rate card, but grad students assume consulting is unaffordable and self-filter out. Even "Student-friendly rates — you'll get a clear quote after the free consultation, before any work begins" changes the calculus. | High |
| 2.4 | **No confidentiality / data-handling statement.** Your clients handle sensitive health data; many are bound by ethics approvals and POPIA. A short paragraph ("your data stays confidential, is handled per POPIA, and is deleted on request after project close") is a trust signal your competitors likely lack. | Medium |
| 2.5 | **No FAQ.** The questions every prospective client has: cost, turnaround, "do you work with SPSS/Stata data?", "will you be acknowledged or a co-author?", "can you talk to my supervisor?". An FAQ section on Services or Contact answers them at 2 a.m. when the student is browsing. | Medium |
| 2.6 | **"What happens next" only covers step one.** Extend it into a simple 4-step "How it works" (Email → free consult → quote & plan → work + deliverables) so the whole engagement feels predictable. | Medium |
| 2.7 | **No social proof.** Understandable while the practice is young — but plan the slot now. Even one attributed quote from a supervisor or collaborator ("Alex made our revisions painless") outperforms a paragraph of self-description. | Medium |
| 2.8 | **Optional: bookable consult.** Since the offer is a free consultation, a Calendly/Cal.com free-tier link ("Book a 20-minute intro call") removes the email round-trip entirely. Worth an experiment after 2.1. | Low |

### 3. Accessibility (measured)

| # | Finding | Measured | Severity |
|---|---------|----------|----------|
| 3.1 | **Navbar hover/active color fails badly.** `$navbar-hl: $sand` puts sand `#a68a64` text on forest `#2d6a4f`. | **1.96:1** (needs 4.5:1) | High |
| 3.2 | **Navbar "Get in Touch" button:** white text on sand `#a68a64`. | **3.26:1** (needs 4.5:1) | Medium |
| 3.3 | **Sage body text** (`.lead`, `.follow-up`, `.service-entry-point`, `.cta-section p`) on cream background. | **4.28:1** (needs 4.5:1) | Medium |
| 3.4 | **Heading skip:** credibility cards use `####` (h4) directly under an h2 section — skips h3. Use `###` to match the service cards. | — | Low |
| 3.5 | **Footer link hover** is also sand-on-forest (same 1.96:1 as 3.1). | 1.96:1 | Low |

Fixes: darken sand for text/hover use (e.g. `#8a6f4d` on white ≈ 4.6:1) or switch navbar
hover to cream with an underline; darken sage for text (e.g. `#456359`) while keeping
`$green-sage` for borders/decoration. Reference: forest-on-cream (5.63:1) and white-on-forest
(6.39:1) both pass — the core palette is fine, it's the two accent uses that fail.

### 4. Performance

| # | Finding | Severity |
|---|---------|----------|
| 4.1 | **`images/headshot.png` is 508 KB** (640×566 PNG) — a photo stored in the wrong format, and it's the LCP element of the home page. Re-export as WebP or quality-80 JPEG at ~440×440 (2× the 220 px display size): expect **~25–50 KB, a ~90% reduction** in total page weight. | High |
| 4.2 | No explicit `width`/`height` on the about-page photo (CSS gives it `width: 100%; max-width: 300px`), so it can cause layout shift while loading. Minor once 4.1 shrinks the file. | Low |

### 5. Code quality & maintainability

| # | Finding | Severity |
|---|---------|----------|
| 5.1 | **The mailto URL is duplicated 5×** across `_quarto.yml`, `index.qmd` (×2), `services.qmd`, `contact.qmd` — and has already drifted (navbar says "Program (e.g. PhD Public Health)", pages say "Program or affiliation"). Extract the CTA button into `_email-cta.qmd` and drop `{{< include _email-cta.qmd >}}` where needed; the navbar copy stays in `_quarto.yml` but should be reconciled. | Medium |
| 5.2 | **Deprecated Sass functions.** `darken()` / `lighten()` are deprecated in Dart Sass and will eventually break as Quarto upgrades its bundled Sass. Replace with `color.adjust()` / `color.scale()` or precomputed hex values. | Medium |
| 5.3 | **TOC enabled site-wide** (`toc: true` in `format.html`) puts a document-style table of contents on Services and About. On a 4-page marketing site it reads as "rendered document" rather than "website". Recommend `toc: false` globally. | Low |
| 5.4 | **Dead CSS:** `.hero .lead` and `.hero .follow-up` set `margin-bottom`, but `[text]{.class}` renders inline `<span>`s where vertical margins are ignored; the visible spacing comes from the wrapping `<p>`. Either delete the margins or add `display: block`. | Low |
| 5.5 | **Tablet layout:** the four credibility cards use `.g-col-md-3`, i.e. four across from 768 px — cramped on tablets. Use `.g-col-md-6 .g-col-lg-3` (2×2 on tablets, 4 across on desktop). Similarly, the fixed 220 px hero photo is left-aligned when the grid stacks on mobile; center it with a small media query. | Low |

### 6. Infrastructure & ops

| # | Finding | Severity |
|---|---------|----------|
| 6.1 | **No analytics.** The spec scoped it out, but you now can't answer "does anyone visit?" or "which page loses people?". A privacy-friendly counter (GoatCounter is free; Plausible is nicer, paid) needs no cookie banner. Add before spending effort on content changes so you can see what works. | Medium |
| 6.2 | **Quarto version unpinned in CI** (`quarto-actions/setup@v2` grabs latest), so a Quarto release can change or break the rendered site with no code change. Pin with `with: version: "1.6.42"` (or current) and bump deliberately. | Medium |
| 6.3 | **No render check on PRs.** Add a `pull_request` trigger that runs the render step only (no deploy) so a broken `.qmd` is caught before merge. | Low |
| 6.4 | **Custom domain + professional email.** `vantwiska@gmail.com` as the business contact undercuts the professionalism the site works hard to build. A domain (e.g. `avtconsulting.co.za`) plus mail hosting gives `alex@avtconsulting.co.za`; GitHub Pages supports custom domains for free. Not urgent, but the highest-leverage credibility upgrade available. | Medium |
| 6.5 | **Internal planning docs are in the public repo** (`docs/superpowers/…` design specs and plans). They're harmless, but if you'd rather not publish internal notes, move them out or make the repo private (Pages can stay public). | Low |
| 6.6 | **Verify the LinkedIn URL** in the footer resolves to your profile (couldn't verify from this environment's network). | Low |

---

## Phased roadmap

### Phase 1 — Config quick wins (~1–2 hours, no design changes)
1. Add `site-url`, `open-graph`, `twitter-card`, `favicon`, `lang: en` (findings 1.1, 1.2, 1.5, 1.8)
2. Create a 1200×630 social share image (1.2)
3. Add per-page `description:` front matter (1.3)
4. Fix the home-page duplicate H1 via `pagetitle:` (1.4)
5. Add `404.qmd` (1.6)
6. Pin Quarto version in CI + add PR render check (6.2, 6.3)

### Phase 2 — Performance & accessibility (~1–2 hours)
7. Optimize headshot to ~440×440 WebP/JPEG (4.1)
8. Contrast fixes: navbar hover, sand button, sage text shades (3.1–3.3, 3.5)
9. Heading level + grid breakpoints + mobile hero centering (3.4, 5.5)
10. Replace deprecated `darken()`/`lighten()` (5.2); drop dead span margins (5.4)

### Phase 3 — Conversion & trust (the highest-impact phase, ~1 day incl. copywriting)
11. Contact form as primary CTA, mailto secondary (2.1)
12. Response-time promise on Contact (2.2)
13. Pricing-approach sentence + FAQ section (2.3, 2.5)
14. Confidentiality/POPIA statement (2.4)
15. "How it works" 4-step process (2.6)
16. DRY the email CTA into an include; reconcile the drifted copy (5.1)
17. Add analytics so Phase 3's impact is measurable (6.1)

### Phase 4 — Growth (as the practice matures)
18. Custom domain + professional email (6.4)
19. First testimonial(s) into the reserved slot (2.7)
20. Optional bookable-consult link (2.8)
21. JSON-LD structured data (1.7)
22. Longer term: a small "Resources/Notes" blog via a Quarto listing page — e.g. short posts like "How many participants do I need?" — the classic SEO channel for exactly your audience.

---

## Notes on what I deliberately did *not* recommend

- **A redesign.** The Forest & Sand identity is distinctive and appropriate; only the two
  failing accent usages need adjustment.
- **A JS framework or site generator migration.** Quarto is the right tool here: free hosting,
  no build complexity, and it doubles as a live demo of your reproducible-reporting workflow.
- **Dark mode.** Possible in Quarto but low value for this audience; skip unless requested.
