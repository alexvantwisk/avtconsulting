# Personal Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the AVT Consulting Quarto site into Alexander van Twisk's personal website with an online CV and a blog, keeping the consulting practice as one section under `/consulting/`.

**Architecture:** One Quarto website project, one repo, one GitHub Actions pipeline to GitHub Pages. Consulting pages move as a unit with Quarto `aliases` providing redirects. The CV is a hand-written page with a manually copied PDF. Blog posts execute locally with `freeze: true` and commit their outputs, so CI never installs R.

**Tech Stack:** Quarto 1.9.36, Bootstrap 5 via the `cosmo` theme, SCSS, GitHub Actions, GitHub Pages, lychee (link checker), R 4.6 locally for blog posts.

**Spec:** `docs/superpowers/specs/2026-09-06-personal-website-design.md`

## Global Constraints

- Quarto is pinned to **1.9.36** in CI and bumped deliberately.
- This repo must **never** reference, import, or read from the Personal-CV repo. CV content is typed by hand; the PDF is copied by hand.
- Phone number and home address must **never** appear on the site or in the shipped PDF.
- **British English** throughout ("randomisation", "modelling", "organisation").
- Forest & Sand palette and the contrast-tuned shades from July stay **unchanged**. No web fonts, no dark mode, no JavaScript beyond Quarto's own.
- Site-wide `toc: false`; only `cv.qmd` and blog posts opt in.
- `_freeze/` is committed; `_site/` and `.quarto/` stay ignored.
- Every step leaves the site renderable and deployable. Verify with `quarto render` before each commit.
- Each of the six steps is its own branch and pull request into `main`. Branch names: `feat/1-foundation`, `feat/2-consulting`, `feat/3-home-about`, `feat/4-cv`, `feat/5-blog`, `feat/6-cutover`.
- Never invent facts. Copy is drawn from the CV YAML (already transcribed into this plan) and the existing site.
- Steps marked **⚠ Alexander** need his action or confirmation. Ask, then wait.

## Verified behaviours (Quarto 1.9.36, tested 2026-09-06)

These were checked in a scratch project; do not re-litigate them.

- `render: ["*.qmd"]` **already matches nested files** (`blog/x/index.qmd`, `consulting/x.qmd`) and skips `.md` files in `docs/` and `tasks/`. No render-target change is needed.
- Several SCSS files may be listed in `theme:`; variables declared in one file's `scss:defaults` are visible in every other file's `scss:rules`.
- `aliases: [/services.html, /services/]` produces both `_site/services.html` and `_site/services/index.html` as JavaScript redirect pages.
- `execute: freeze: true` in `blog/_metadata.yml` writes `_freeze/blog/<slug>/index/execute-results/html.json` plus figures when a post is rendered locally.
- A listing with `feed: {type: full}` writes `blog/index.xml` when `site-url` is set. The `reading-time` listing field works.
- A footer item `href: blog/index.xml` is rewritten per page (`../blog/index.xml`, `../../blog/index.xml`).
- The navbar link to `consulting/index.qmd` renders with an href containing `consulting` on every page, including inside `consulting/`, so `.navbar .nav-link[href*="consulting"]` is a safe selector.

---

## File Structure

| Path | Action | Responsibility |
|---|---|---|
| `.github/workflows/publish.yml` | Modify | Pin Quarto 1.9.36, render on PRs, lychee link check, deploy to Pages on `main` |
| `_quarto.yml` | Modify | Title, description, nav, footer, theme list, later `site-url` and `resources` |
| `styles.scss` | Delete | Replaced by `scss/*.scss` |
| `scss/palette.scss` | Create | `scss:defaults`: colours, shades, typography, Bootstrap/navbar/footer variables |
| `scss/components.scss` | Create | `scss:rules`: navbar button, nav hover, hero, CTA buttons, cards, about photo, footer |
| `scss/consulting.scss` | Create | `scss:rules`: service sections, FAQ, contact section and form, how-it-works, subnav |
| `scss/cv.scss` | Create | `scss:rules`: `.cv-entry` grid, dates column, skills list |
| `scss/blog.scss` | Create | `scss:rules`: listing colours, grid cards on home, post footer |
| `index.qmd` | Rewrite | Personal home: hero, latest posts, links |
| `about.qmd` | Rewrite | Personal About |
| `cv.qmd` | Create | Hand-written CV with PDF download |
| `files/Alexander_van_Twisk_CV.pdf` | Add (Alexander supplies) | Downloadable CV |
| `blog/index.qmd` | Create | Listing with categories and RSS |
| `blog/_metadata.yml` | Create | Freeze, echo, toc, author defaults for posts |
| `blog/_post-footer.qmd` | Create | "All posts" back link include |
| `blog/welcome/index.qmd` | Create | Prose starter post |
| `blog/sample-size-two-means/index.qmd` | Create | R starter post |
| `_freeze/` | Commit | Executed outputs for R posts |
| `consulting/index.qmd` | Move from `index.qmd`, edit | Consulting landing |
| `consulting/services.qmd` | Move, edit | Services with aliases and new FAQ |
| `consulting/contact.qmd` | Move, edit | Contact with aliases |
| `consulting/_cta-button.qmd` | Move | CTA include |
| `consulting/_subnav.qmd` | Create | Overview · Services · Contact link row |
| `privacy.qmd` | Rewrite | Site-wide notice, POPIA + UK GDPR |
| `images/social-card-personal.png` | Create | 1200×630 share image for personal pages |
| `scripts/social-card.R` | Create | Generates the personal share image |
| `netlify.toml`, `scripts/netlify-build.sh` | Delete (conditional) | Removed once Netlify is confirmed unused |
| `CNAME` | Create (domain path only) | Custom domain for GitHub Pages |
| `README.md` | Create | Maintenance notes: posts, freeze, CV PDF, deploy |
| `tasks/todo.md` | Create | Step checklist and review section |

---

## Step 0: Land the design documents

### Task 0: Open and merge the docs pull request

**Files:**
- Already committed on `feat/personal-site`: the spec, this plan, `tasks/lessons.md`, `tasks/todo.md`

- [ ] **Step 1: Push the branch**

```bash
git push -u origin feat/personal-site
```

- [ ] **Step 2: Open the pull request**

```bash
gh pr create --base main --head feat/personal-site \
  --title "docs: personal website design spec and implementation plan" \
  --body "Design spec and step-by-step plan for turning the consulting site into a personal website with CV and blog. No site changes in this PR."
```

- [ ] **Step 3: ⚠ Alexander merges.** After merge: `git checkout main && git pull --ff-only`.

---

## Step 1: Foundation

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/1-foundation`

### Task 1: Repository settings for GitHub Pages

**⚠ Alexander:** both commands change outward-facing settings. Ask for an explicit yes before running each.

**Interfaces:**
- Produces: a public repo with Pages source set to "GitHub Actions", which Task 2's workflow relies on.

- [ ] **Step 1: Confirm the repo may become public**

Tell Alexander: the repo contains no secrets (the analytics ID and the Formspree endpoint are public by design). The `docs/` planning notes will be public too. Wait for a yes.

- [ ] **Step 2: Make the repo public**

```bash
gh repo edit alexvantwisk/avtconsulting --visibility public --accept-visibility-change-consequences
gh repo view alexvantwisk/avtconsulting --json visibility --jq .visibility
```
Expected: `PUBLIC`

- [ ] **Step 3: Set the Pages source to GitHub Actions**

```bash
gh api --method POST repos/alexvantwisk/avtconsulting/pages -f build_type=workflow \
  || gh api --method PUT repos/alexvantwisk/avtconsulting/pages -f build_type=workflow
gh api repos/alexvantwisk/avtconsulting/pages --jq '{build_type, html_url}'
```
Expected: `build_type` is `workflow` and `html_url` is `https://alexvantwisk.github.io/avtconsulting/`. Nothing to commit.

### Task 2: Pin Quarto, add the link check, simplify the workflow

**Files:**
- Modify: `.github/workflows/publish.yml` (replace whole file)

**Interfaces:**
- Produces: a `build` job that fails on broken internal links; every later task's PR runs it.

- [ ] **Step 1: Replace the workflow**

```yaml
name: Build and deploy site

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Quarto
        uses: quarto-dev/quarto-actions/setup@v2
        with:
          version: "1.9.36"

      - name: Render
        uses: quarto-dev/quarto-actions/render@v2

      # Offline mode checks only links to files inside _site, so the build
      # never depends on external hosts. --root-dir resolves root-relative
      # links such as /blog/index.xml. Redirect pages made by Quarto aliases
      # are JavaScript, so their existence is verified by the local checklist
      # (test -f), not by lychee.
      - name: Check internal links
        uses: lycheeverse/lychee-action@v2
        with:
          args: >-
            --offline
            --root-dir ${{ github.workspace }}/_site
            --exclude-mail
            --no-progress
            "_site/**/*.html"
          fail: true

      - name: Upload Pages artifact
        if: github.ref == 'refs/heads/main'
        uses: actions/upload-pages-artifact@v3
        with:
          path: _site

  deploy:
    needs: build
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
```

- [ ] **Step 2: Render locally to confirm nothing else changed**

```bash
quarto render 2>&1 | tail -3
```
Expected: ends with `Output created: _site/index.html`.

- [ ] **Step 3: Commit**

```bash
git add .github/workflows/publish.yml
git commit -m "ci: pin Quarto 1.9.36, add offline link check, deploy only from main"
```

- [ ] **Step 4: After the PR for this step opens (Task 4), read the "Check internal links" job log.** If lychee reports a false positive, add one `--exclude '<regex>'` line to `args` for that pattern with a comment saying why, and commit it in the same PR. Do not lower `fail`.

### Task 3: Split the stylesheet into small files

**Files:**
- Create: `scss/palette.scss`, `scss/components.scss`, `scss/consulting.scss`
- Delete: `styles.scss`
- Modify: `_quarto.yml` (theme list only)

**Interfaces:**
- Produces: SCSS variables `$green-forest $green-sage $teal $sand $cream $charcoal $sand-light $ink $sage-text $charcoal-light $charcoal-lighter $forest-dark $cream-dark $cream-border` and the class names below, used by every later task.

- [ ] **Step 1: Record the current compiled selectors for comparison**

```bash
quarto render >/dev/null 2>&1
grep -oE '\.[a-zA-Z][a-zA-Z0-9_-]*' _site/site_libs/bootstrap/bootstrap-*.min.css | sort -u > /tmp/before-selectors.txt
wc -l /tmp/before-selectors.txt
```

- [ ] **Step 2: Create `scss/palette.scss`**

```scss
/*-- scss:defaults --*/

// Forest & Sand palette
$green-forest: #2d6a4f;
$green-sage: #52796f;
$teal: #3d8b8a;
$sand: #a68a64;
$cream: #f5f0e8;
$charcoal: #2d3748;

// Precomputed shades (replace darken()/lighten(), which are deprecated in
// Dart Sass) chosen to pass WCAG AA contrast where used as text/hover colors.
$sand-light: #b39b78;       // sand lightened ~6% (navbar button hover); ink text on it = 5.8:1
$ink: #212529;              // near-black text; 4.7:1 on sand (white on sand is only 3.3:1)
$sage-text: #486a61;        // sage darkened ~5%; 5.3:1 on cream — use for text; keep $green-sage for borders
$charcoal-light: #4a5b77;   // charcoal lightened 15%
$charcoal-lighter: #546787; // charcoal lightened 20%
$forest-dark: #1e4634;      // forest darkened 10% (hover)
$cream-dark: #f0e9dd;       // cream darkened 3% (cta-section bg)
$cream-border: #e9ddcb;     // cream darkened 8% (borders)

// Bootstrap overrides
$body-bg: $cream;
$body-color: $charcoal;
$link-color: $green-forest;
$font-family-sans-serif: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
$headings-font-family: Georgia, "Times New Roman", serif;
$headings-color: $charcoal;

// Navbar
$navbar-bg: $green-forest;
$navbar-fg: $cream;
$navbar-hl: #fff;

// Footer
$footer-bg: $green-forest;
$footer-fg: $cream;
```

- [ ] **Step 3: Create `scss/components.scss`**

```scss
/*-- scss:rules --*/

// ---- Navbar call-to-action button ----
// Match on "contact" anywhere in the href, not the ".html" suffix, because
// pretty-URL rewriting on some hosts turns ./contact.html into ./contact/.
// Task 6 changes this match to "consulting".
.navbar .nav-link[href*="contact"] {
  background-color: $sand;
  color: $ink;
  border-radius: 6px;
  padding: 0.4rem 1.2rem;
  font-weight: 600;
  margin-left: 0.5rem;
  transition: background-color 0.2s ease;

  // It's a button; no underline in any state. Quarto wraps the label in a
  // child span (.menu-text) that gets its own underline on hover/active.
  &,
  &:hover,
  &:focus,
  &.active,
  & .menu-text,
  & i {
    text-decoration: none !important;
  }

  &:hover,
  &:focus {
    background-color: $sand-light;
    color: $ink;
  }

  &.active {
    color: $ink;
  }
}

// ---- Navbar hover/active affordance ----
.navbar .nav-link:not([href*="contact"]):hover,
.navbar .nav-link:not([href*="contact"]).active {
  text-decoration: underline;
  text-underline-offset: 0.25em;
}

// ---- Hero section ----
.hero {
  padding: 2rem 0 3rem;
}

.hero h1 {
  font-size: 2.4rem;
  line-height: 1.25;
  margin-bottom: 0.5rem;
  color: $green-forest;
}

.hero .lead {
  font-size: 1.1rem;
  color: $sage-text;
}

.hero .follow-up {
  font-size: 1.15rem;
  color: $sage-text;
  font-style: italic;
}

.hero-photo {
  width: 220px;
  height: 220px;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid $green-sage;
}

@media (max-width: 767.98px) {
  .hero-photo {
    display: block;
    margin-left: auto;
    margin-right: auto;
  }
}

// ---- CTA buttons ----
.btn-cta {
  display: inline-block;
  background-color: $green-forest;
  color: #fff;
  padding: 0.75rem 1.5rem;
  border-radius: 6px;
  font-weight: 600;
  text-decoration: none;
  transition: background-color 0.2s ease;

  &:hover {
    background-color: $forest-dark;
    color: #fff;
  }
}

.btn-cta-large {
  font-size: 1.15rem;
  padding: 1rem 2rem;
}

button.btn-cta {
  border: none;
  cursor: pointer;
  font-family: inherit;
  font-size: 1rem;
}

// ---- Cards ----
.service-card {
  background: #fff;
  border-radius: 8px;
  padding: 1.5rem;
  border-top: 4px solid $green-forest;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  height: 100%;

  h3 {
    font-size: 1.2rem;
    margin-bottom: 0.5rem;
  }

  p {
    font-size: 0.95rem;
    color: $charcoal-light;
    margin-bottom: 1rem;
  }

  a {
    color: $green-forest;
    font-weight: 600;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
}

.service-card-sage {
  border-top-color: $green-sage;
}

.service-card-teal {
  border-top-color: $teal;
}

.credibility-card {
  background: #fff;
  border-left: 3px solid $green-sage;
  padding: 1rem 1.25rem;
  border-radius: 4px;
  height: 100%;

  strong, h3 {
    display: block;
    font-family: $headings-font-family;
    font-size: 1rem;
    color: $charcoal;
    margin-bottom: 0.25rem;
  }

  p {
    font-size: 0.9rem;
    color: $charcoal-lighter;
    margin-bottom: 0;
  }
}

// ---- Closing CTA section ----
.cta-section {
  background: $cream-dark;
  border-radius: 8px;
  padding: 2.5rem;
  text-align: center;
  margin-top: 2.5rem;

  h2 {
    font-size: 1.5rem;
    margin-bottom: 0.75rem;
  }

  p {
    color: $sage-text;
    margin-bottom: 1.5rem;
  }
}

// ---- About page photo ----
.about-photo {
  width: 100%;
  max-width: 300px;
  border-radius: 8px;
  object-fit: cover;
  border: 3px solid $green-sage;
}

// ---- Footer ----
.nav-footer {
  a {
    color: $cream;

    &:hover {
      color: #fff;
      text-decoration: underline;
      text-underline-offset: 0.25em;
    }
  }
}
```

- [ ] **Step 4: Create `scss/consulting.scss`**

```scss
/*-- scss:rules --*/

// ---- Services page section accents ----
.service-section-green h2 {
  border-left: 4px solid $green-forest;
  padding-left: 0.75rem;
}

.service-section-sage h2 {
  border-left: 4px solid $green-sage;
  padding-left: 0.75rem;
}

.service-section-teal h2 {
  border-left: 4px solid $teal;
  padding-left: 0.75rem;
}

// ---- Service entry-point text ----
.service-entry-point {
  font-style: italic;
  color: $sage-text;
  margin-bottom: 1rem;
  font-size: 1rem;
}

// ---- FAQ section (services page) ----
.faq-section {
  margin-top: 3rem;

  h3 {
    font-size: 1.1rem;
    margin-top: 1.5rem;
  }
}

// ---- Contact page ----
// Centre the page title (and description) on the contact page only
body:has(.contact-section) #title-block-header {
  text-align: center;
}

.contact-section {
  max-width: 600px;
  margin: 0 auto;
  text-align: center;

  h2 {
    font-size: 1.4rem;
    margin-top: 2.5rem;
  }
}

// ---- Contact form ----
.contact-form {
  text-align: left;

  label {
    display: block;
    font-weight: 600;
    margin-bottom: 0.25rem;
    color: $charcoal;
  }

  input,
  select,
  textarea {
    width: 100%;
    padding: 0.5rem 0.75rem;
    border: 1px solid $green-sage;
    border-radius: 6px;
    background: #fff;
    margin-bottom: 1rem;
    font: inherit;

    &:focus {
      outline: 2px solid $green-forest;
      outline-offset: 1px;
    }
  }

  textarea {
    resize: vertical;
  }
}

// ---- Contact "how it works" ----
.how-it-works {
  text-align: left;
  margin-top: 2.5rem;
  padding-top: 1.5rem;
  border-top: 1px solid $cream-border;

  ol {
    padding-left: 1.25rem;
  }

  li {
    margin-bottom: 0.75rem;
    color: $charcoal-light;

    &::marker {
      color: $green-forest;
      font-weight: 600;
    }
  }
}
```

- [ ] **Step 5: Point the theme at the new files and delete the old one**

In `_quarto.yml`, replace

```yaml
    theme: [cosmo, styles.scss]
```
with
```yaml
    theme: [cosmo, scss/palette.scss, scss/components.scss, scss/consulting.scss]
```

Then `git rm styles.scss`.

- [ ] **Step 6: Render and compare selectors**

```bash
quarto render 2>&1 | tail -2
grep -oE '\.[a-zA-Z][a-zA-Z0-9_-]*' _site/site_libs/bootstrap/bootstrap-*.min.css | sort -u > /tmp/after-selectors.txt
diff /tmp/before-selectors.txt /tmp/after-selectors.txt && echo "SELECTORS IDENTICAL"
```
Expected: `SELECTORS IDENTICAL`. If a name is missing, a rule was dropped in the split; restore it.

- [ ] **Step 7: Commit**

```bash
git add scss/ _quarto.yml
git commit -m "refactor: split styles.scss into palette, components, and consulting files"
```

### Task 4: Site identity, footer, and housekeeping

**Files:**
- Modify: `_quarto.yml`
- Delete: `images/.gitkeep`
- Modify: `docs/website-review-plan.md` (status note only)

- [ ] **Step 1: Replace `_quarto.yml` with**

```yaml
project:
  type: website
  output-dir: _site
  render:
    - "*.qmd"

lang: en

website:
  title: "Alexander van Twisk"
  description: "Alexander van Twisk is a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge. Writing on statistics, R, and clinical trial methodology, with statistical consulting for researchers."
  site-url: https://alexvantwisk.github.io/avtconsulting
  favicon: images/favicon.png
  open-graph: true
  twitter-card: true
  image: images/social-card.png
  google-analytics: "G-3EB0K5GDXG"
  navbar:
    background: primary
    left:
      - href: index.qmd
        text: Home
      - href: services.qmd
        text: Services
      - href: about.qmd
        text: About
    right:
      - icon: envelope
        href: contact.qmd
        text: "Get in Touch"
        aria-label: "Get in touch"
  page-footer:
    left: "© 2026 Alexander van Twisk"
    center:
      - href: privacy.qmd
        text: Privacy
    right:
      - icon: envelope
        href: "mailto:vantwiska@gmail.com"
        aria-label: "Email"
      - icon: linkedin
        href: "https://www.linkedin.com/in/alexander-van-twisk"
        aria-label: "LinkedIn"
      - icon: github
        href: "https://github.com/alexvantwisk"
        aria-label: "GitHub"

format:
  html:
    theme: [cosmo, scss/palette.scss, scss/components.scss, scss/consulting.scss]
    toc: false
```

- [ ] **Step 2: Remove the empty placeholder and note the old plan's status**

```bash
git rm images/.gitkeep
```

At the top of `docs/website-review-plan.md`, under `## Status`, add the line:

```markdown
- Phase 4 superseded by `docs/superpowers/specs/2026-09-06-personal-website-design.md` (personal site with blog; custom domain handled there)
```

- [ ] **Step 3: Render and verify**

```bash
quarto render 2>&1 | tail -2
grep -c 'Alexander van Twisk' _site/index.html
grep -o 'href="https://github.com/alexvantwisk"' _site/about.html
```
Expected: render succeeds; count is at least 2; the GitHub href is printed.

- [ ] **Step 4: Commit, push, open the PR**

```bash
git add _quarto.yml docs/website-review-plan.md
git commit -m "feat: site identity as Alexander van Twisk, GitHub footer link"
git push -u origin feat/1-foundation
gh pr create --base main --head feat/1-foundation --title "Step 1: foundation" \
  --body "Pins Quarto 1.9.36, adds offline link check, splits SCSS into small files, renames the site to Alexander van Twisk. No page content changes."
```

- [ ] **Step 5: Watch CI, then ⚠ Alexander merges**

```bash
gh pr checks --watch
```
Expected: `build` passes, including "Check internal links". If lychee fails, follow Task 2 Step 4. After merge, confirm the deploy: `gh run list --limit 1 --json conclusion --jq '.[0].conclusion'` prints `success`, and `https://alexvantwisk.github.io/avtconsulting/` shows the renamed site.

---

## Step 2: Move consulting into its own section

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/2-consulting`

### Task 5: Move the pages, add aliases, subnav, and a stopgap home

**Files:**
- Move: `index.qmd` → `consulting/index.qmd`; `services.qmd` → `consulting/services.qmd`; `contact.qmd` → `consulting/contact.qmd`; `_cta-button.qmd` → `consulting/_cta-button.qmd`
- Create: `consulting/_subnav.qmd`, new `index.qmd`
- Modify: `scss/consulting.scss` (append), `scss/components.scss` (append)

**Interfaces:**
- Produces: `consulting/_subnav.qmd` (include), `.consulting-subnav`, `.btn-cta-secondary`. Task 9 uses `.btn-cta-secondary`.

- [ ] **Step 1: Move the files**

```bash
mkdir -p consulting
git mv index.qmd consulting/index.qmd
git mv services.qmd consulting/services.qmd
git mv contact.qmd consulting/contact.qmd
git mv _cta-button.qmd consulting/_cta-button.qmd
```

- [ ] **Step 2: Create `consulting/_subnav.qmd`**

```markdown
::: {.consulting-subnav}
[Overview](index.qmd) · [Services](services.qmd) · [Contact](contact.qmd)
:::
```

- [ ] **Step 3: Edit `consulting/index.qmd` front matter and paths**

Replace the front matter with:

```yaml
---
pagetitle: "Consulting | Alexander van Twisk"
description: "Biostatistical consulting for medical and public health researchers: study design, sample size, data analysis, and publication-ready reporting. Free initial consultation."
image: ../images/social-card.png
---

{{< include _subnav.qmd >}}
```

Change the image line `![](images/headshot.jpg){.hero-photo fig-alt="Alex van Twisk"}` to `![](../images/headshot.jpg){.hero-photo fig-alt="Alex van Twisk"}`. The three `[Learn more &rarr;](services.qmd)` links and both `{{< include _cta-button.qmd >}}` lines stay as they are (relative paths still resolve inside `consulting/`).

- [ ] **Step 4: Edit `consulting/services.qmd` front matter**

```yaml
---
title: "Services"
description: "Statistical consulting services: sample size and power calculations, regression and survival analysis, survey data analysis, and publication-ready statistical reporting."
image: ../images/social-card.png
aliases:
  - /services.html
  - /services/
---

{{< include _subnav.qmd >}}
```

- [ ] **Step 5: Edit `consulting/contact.qmd` front matter**

```yaml
---
title: "Let's Talk About Your Project"
description: "Get in touch about your research project. The initial consultation is free, with no obligations."
image: ../images/social-card.png
aliases:
  - /contact.html
  - /contact/
---

{{< include _subnav.qmd >}}
```

- [ ] **Step 6: Append the subnav style to `scss/consulting.scss`**

```scss
// ---- Consulting sub-navigation ----
.consulting-subnav {
  font-size: 0.9rem;
  margin-bottom: 1.5rem;
  padding-bottom: 0.5rem;
  border-bottom: 1px solid $cream-border;

  p {
    margin: 0;
    color: $sage-text;

    &::before {
      content: "Consulting: ";
      font-weight: 600;
      color: $charcoal;
    }
  }

  a {
    color: $green-forest;
    font-weight: 600;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
}
```

- [ ] **Step 7: Append the secondary button to `scss/components.scss`** (directly after the `button.btn-cta` rule)

```scss
.btn-cta-secondary {
  background-color: transparent;
  color: $green-forest;
  border: 2px solid $green-forest;
  padding: calc(0.75rem - 2px) calc(1.5rem - 2px);

  &:hover {
    background-color: $green-forest;
    color: #fff;
  }
}
```

- [ ] **Step 8: Create the stopgap root `index.qmd`** (Task 9 replaces it)

```markdown
---
pagetitle: "Alexander van Twisk | Biostatistician"
description: "Alexander van Twisk is a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge."
---

::: {.hero}

# Alexander van Twisk {.unlisted}

[Biostatistician. PhD student at the MRC Biostatistics Unit, University of Cambridge.]{.lead}

[About me](about.qmd){.btn-cta} [Consulting](consulting/index.qmd){.btn-cta .btn-cta-secondary}

:::
```

- [ ] **Step 9: Render and verify the moves and redirects**

```bash
quarto render 2>&1 | tail -2
for f in _site/consulting/index.html _site/consulting/services.html _site/consulting/contact.html \
         _site/services.html _site/services/index.html _site/contact.html _site/contact/index.html; do
  test -f "$f" && echo "OK  $f" || echo "MISSING $f"; done
grep -o 'consulting/services.html' _site/services/index.html | head -1
grep -c 'consulting-subnav' _site/consulting/contact.html
```
Expected: seven `OK` lines; the redirect target prints; the count is 1.

- [ ] **Step 10: Commit**

```bash
git add -A consulting/ index.qmd scss/
git commit -m "feat: move consulting pages under /consulting with redirects and subnav"
```

### Task 6: Navbar: Consulting becomes the highlighted item

**Files:**
- Modify: `_quarto.yml` (navbar block), `scss/components.scss` (two selectors)

- [ ] **Step 1: Replace the `navbar:` block in `_quarto.yml`**

```yaml
  navbar:
    background: primary
    left:
      - href: about.qmd
        text: About
    right:
      - href: consulting/index.qmd
        text: Consulting
        aria-label: "Consulting services"
```

- [ ] **Step 2: Retarget the button selectors in `scss/components.scss`**

Change `.navbar .nav-link[href*="contact"] {` to `.navbar .nav-link[href*="consulting"] {` and update its comment to read `// Match on "consulting" anywhere in the href. Verified: the navbar href contains "consulting" on every page, including pages inside consulting/.`

Change both `:not([href*="contact"])` occurrences to `:not([href*="consulting"])`.

- [ ] **Step 3: Render and verify**

```bash
quarto render 2>&1 | tail -2
grep -oE '<a class="nav-link[^"]*" href="[^"]*consulting/index.html"' _site/index.html _site/consulting/services.html
grep -c 'nav-link\[href\*=consulting\]' _site/site_libs/bootstrap/bootstrap-*.min.css
```
Expected: one match per page; the CSS count is at least 1.

- [ ] **Step 4: Commit**

```bash
git add _quarto.yml scss/components.scss
git commit -m "feat: navbar shows About and a highlighted Consulting button"
```

### Task 7: Consulting positioning copy

**Files:**
- Modify: `consulting/index.qmd` (lead paragraph and credibility cards), `consulting/services.qmd` (FAQ)

- [ ] **Step 1: Replace the lead paragraph in `consulting/index.qmd`**

Replace the line beginning `[I'm Alex van Twisk, a biostatistician helping researchers` with:

```markdown
[I'm Alex van Twisk, a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge. I take on a limited number of consulting projects alongside my research, working remotely with researchers in South Africa and the UK to get the statistics right, from study design through to publication.]{.lead}
```

- [ ] **Step 2: Replace the four credibility cards** (everything between `## Why work with me` and the closing `::::` of that grid)

```markdown
:::: {.grid}

::: {.g-col-12 .g-col-md-6 .g-col-lg-3}
::: {.credibility-card}
### PhD in trials methodology

PhD student at the MRC Biostatistics Unit, University of Cambridge, researching response-adaptive designs for clinical trials.
:::
:::

::: {.g-col-12 .g-col-md-6 .g-col-lg-3}
::: {.credibility-card}
### Clinical trials experience

Over a year at a contract research organisation, most recently as lead statistician and programmer on bioequivalence studies submitted to the FDA and the EMA.
:::
:::

::: {.g-col-12 .g-col-md-6 .g-col-lg-3}
::: {.credibility-card}
### Formal training

MSc Biostatistics (Cum Laude), BScHons Biostatistics (With Distinction), and a BSc in Applied Mathematics.
:::
:::

::: {.g-col-12 .g-col-md-6 .g-col-lg-3}
::: {.credibility-card}
### Teaching background

A postgraduate teaching qualification, university teaching assistant, and mathematics teacher. I explain things clearly, not just run your analysis.
:::
:::

::::
```

- [ ] **Step 3: Add the availability answer to the FAQ in `consulting/services.qmd`**

Directly after the `### How long will it take?` answer paragraph, insert:

```markdown
### Are you taking on projects during your PhD?

Yes, in limited numbers. I run a few projects at a time alongside my research, so I may propose a start date rather than begin immediately. Tell me your deadline up front and I'll say honestly whether I can meet it.
```

- [ ] **Step 4: Widen the confidentiality answer**

Replace the `### Is my data kept confidential?` answer with:

```markdown
Yes. Your data is stored securely, never shared, handled in line with POPIA, with UK GDPR where it applies, and the conditions of your ethics approval, and deleted after the project closes if you wish.
```

- [ ] **Step 5: Render and verify**

```bash
quarto render 2>&1 | tail -2
grep -c 'PhD in trials methodology' _site/consulting/index.html
grep -c 'taking on projects during your PhD' _site/consulting/services.html
grep -c 'Reproducible workflow' _site/consulting/index.html
```
Expected: 1, 1, 0.

- [ ] **Step 6: Commit**

```bash
git add consulting/
git commit -m "feat: reposition consulting copy for the Cambridge PhD"
```

### Task 8: Privacy notice for the whole site

**Files:**
- Rewrite: `privacy.qmd`

- [ ] **Step 1: Get today's date for the notice**

```bash
date "+%-d %B %Y"
```

- [ ] **Step 2: Replace `privacy.qmd`** (put the date from Step 1 in the first line)

```markdown
---
title: "Privacy Notice"
description: "What information this website collects, how it is used, and your rights under POPIA and UK GDPR."
---

*Last updated: DAY MONTH YEAR*

This website is run by Alexander van Twisk, a biostatistician and PhD student at the University of Cambridge who also offers statistical consulting. This notice explains what information the site collects and how it is used, in line with South Africa's Protection of Personal Information Act (POPIA) and, where it applies, the UK General Data Protection Regulation (UK GDPR).

## Website analytics

Every page on this site uses Google Analytics 4 to understand how the site is used: which pages are visited, roughly where visitors come from, and what kind of device and browser they use. Google Analytics sets cookies and collects usage identifiers for this purpose, and Google may process this data on servers outside South Africa and the UK.

I only ever look at this data in aggregate, to see what is useful on the site and what is not. It is not used to identify you, and it is never sold or shared.

If you would rather not be counted, you can block cookies in your browser settings or install Google's [Analytics opt-out browser add-on](https://tools.google.com/dlpage/gaoptout).

## Contact form and email

When you use the [contact form](consulting/contact.qmd), your submission (name, email address, and whatever you tell me about your project) is processed by [Formspree](https://formspree.io/legal/privacy-policy/) and delivered to my email. If you email me directly, the same applies without the Formspree step.

This information is used only to respond to you and, if we work together, to provide the consulting you have asked for. It is never added to a mailing list, shared, or sold.

## Blog and RSS feed

The blog's RSS feed contains only the published posts. Subscribing happens in your own feed reader and sends nothing to me. There are no comments, newsletters, or mailing lists on this site.

## Client and research data

Data shared with me during a consulting engagement is handled under the confidentiality terms we agree at the start of the project: stored securely, never shared, handled in line with POPIA, UK GDPR where it applies, and the conditions of your ethics approval, and deleted after the project closes if you wish. See the [FAQ on the Services page](consulting/services.qmd) for more.

## Your rights

Under POPIA and UK GDPR you can ask what personal information I hold about you, and ask for it to be corrected or deleted. Just [email me](mailto:vantwiska@gmail.com) and I will sort it out.

## Changes to this notice

If this notice changes, the updated version will be posted on this page.
```

- [ ] **Step 3: Render, verify, commit, open the PR**

```bash
quarto render 2>&1 | tail -2
grep -c 'UK GDPR' _site/privacy.html
git add privacy.qmd
git commit -m "feat: widen privacy notice to the whole site and UK GDPR"
git push -u origin feat/2-consulting
gh pr create --base main --head feat/2-consulting --title "Step 2: consulting section" \
  --body "Moves the consulting pages under /consulting with redirects and a subnav, repositions the copy for the Cambridge PhD, and widens the privacy notice. Root home is a stopgap until Step 3."
gh pr checks --watch
```
Expected: `UK GDPR` count is at least 3; CI passes. **⚠ Alexander merges.** After deploy, open the live `/services/` and `/contact.html` URLs and confirm they land on the consulting pages.

---

## Step 3: Home and About

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/3-home-about`

### Task 9: Personal home page

**Files:**
- Rewrite: `index.qmd`

- [ ] **Step 1: Replace `index.qmd`**

```markdown
---
pagetitle: "Alexander van Twisk | Biostatistician"
description: "Alexander van Twisk is a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge, writing about statistics, R, and clinical trial methodology."
---

::: {.hero}

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
![](images/headshot.jpg){.hero-photo fig-alt="Alexander van Twisk"}
:::

::: {.g-col-12 .g-col-md-8}

# Alexander van Twisk {.unlisted}

[Biostatistician. PhD student at the MRC Biostatistics Unit, University of Cambridge.]{.follow-up}

[I work on how clinical trials can adapt as they learn, and on making good statistics practical for the researchers who need it. I write here about statistics, R, and trial methodology, and now and then about aviation and history.]{.lead}

[About me](about.qmd){.btn-cta} [Consulting](consulting/index.qmd){.btn-cta .btn-cta-secondary}

:::

::::

:::

## Elsewhere on this site

:::: {.grid}

::: {.g-col-12 .g-col-md-6}
::: {.service-card}
### Consulting

Statistical support for researchers in the medical and public health sciences, from study design to publication. A limited number of projects run alongside the PhD.

[Consulting &rarr;](consulting/index.qmd)
:::
:::

::: {.g-col-12 .g-col-md-6}
::: {.service-card .service-card-sage}
### About

The path from applied mathematics to trial methodology, and what the PhD is about.

[About me &rarr;](about.qmd)
:::
:::

::::
```

- [ ] **Step 2: Render and verify**

```bash
quarto render 2>&1 | tail -2
grep -c 'hero-photo' _site/index.html
grep -c 'btn-cta-secondary' _site/index.html
```
Expected: 1 and 1.

- [ ] **Step 3: Commit**

```bash
git add index.qmd
git commit -m "feat: personal home page"
```

### Task 10: Personal About page

**Files:**
- Rewrite: `about.qmd`

- [ ] **Step 1: Replace `about.qmd`**

```markdown
---
title: "About"
description: "Alexander van Twisk is a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge, with clinical trials experience and a teaching background."
---

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
![](images/headshot.jpg){.about-photo fig-alt="Alexander van Twisk"}
:::

::: {.g-col-12 .g-col-md-8}

I'm a biostatistician. From October 2026 I'm a PhD student at the MRC Biostatistics Unit, University of Cambridge, supervised by Professor Sofia Villar and funded by an MRC Trials Methodology Research Partnership studentship. My research is on response-adaptive designs for clinical trials: how to let a trial learn from its own data and send more participants to the treatments that are working, without breaking either the statistics or the logistics that keep a trial running.

I came to this by way of applied mathematics, then biostatistics at Pretoria and Stellenbosch, and then a clinical research organisation, where I went from intern to lead statistician on regulatory bioequivalence submissions. That work showed me how often a theoretically optimal design founders on delayed outcomes, randomisation systems, or recruitment realities. I care most about trials in resource-constrained settings, where efficiency gains matter most.

:::

::::

## Before the PhD

I taught mathematics before any of this, at a high school and as a university teaching assistant, and I still enjoy explaining hard ideas clearly. My MSc thesis compared Hamiltonian Monte Carlo with Metropolis–Hastings sampling for Bayesian survival analysis of weighted, interval-censored HIV survey data, and I presented that work at the South African Statistical Association's annual conference.

Away from statistics I am known for a steady supply of interesting facts and a love of aviation and geopolitical history. Some of that will end up on the [blog](blog/index.qmd).

## Working with me

If you are a researcher looking for statistical help with a study, see the [consulting](consulting/index.qmd) pages. The full record of degrees, roles, and talks is on the [CV](cv.qmd) page.
```

**Note for the executor:** `blog/index.qmd` and `cv.qmd` do not exist until Steps 4 and 5, so the link checker would fail on this PR. Until then, write those two sentences without links:

```markdown
Some of that will end up on the blog.
```
and
```markdown
If you are a researcher looking for statistical help with a study, see the [consulting](consulting/index.qmd) pages. The full record of degrees, roles, and talks is on the CV page.
```
Tasks 12 and 13 restore the links.

- [ ] **Step 2: Render and verify**

```bash
quarto render 2>&1 | tail -2
grep -c 'Sofia Villar' _site/about.html
grep -c 'consult with researchers on the side' _site/about.html
```
Expected: 1 and 0.

- [ ] **Step 3: Commit, push, open the PR**

```bash
git add about.qmd
git commit -m "feat: rewrite About for the personal site"
git push -u origin feat/3-home-about
gh pr create --base main --head feat/3-home-about --title "Step 3: home and About" \
  --body "Personal home page with hero and section cards; About rewritten around the PhD. Blog and CV links arrive with their pages."
gh pr checks --watch
```
**⚠ Alexander merges.**

---

## Step 4: CV

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/4-cv`

### Task 11: CV styling and page content

**Files:**
- Create: `scss/cv.scss`, `cv.qmd`
- Modify: `_quarto.yml` (theme list)

**Interfaces:**
- Produces: classes `.cv-entry .cv-dates .cv-body .cv-org .cv-skills .cv-updated .cv-download`.

- [ ] **Step 1: Create `scss/cv.scss`**

```scss
/*-- scss:rules --*/

// ---- CV page ----
.cv-download {
  margin-bottom: 1.5rem;
}

.cv-updated {
  display: block;
  font-size: 0.9rem;
  color: $sage-text;
  margin-bottom: 2rem;
}

.cv-entry {
  display: grid;
  grid-template-columns: 9.5rem 1fr;
  column-gap: 1.5rem;
  margin-bottom: 1.5rem;
}

.cv-dates {
  color: $sage-text;
  font-size: 0.95rem;
  padding-top: 0.15rem;
}

.cv-body {
  p {
    margin-bottom: 0.35rem;
  }

  ul {
    margin-top: 0.5rem;
    margin-bottom: 0;
  }

  li {
    margin-bottom: 0.25rem;
  }
}

.cv-org {
  color: $charcoal-light;
}

.cv-skills {
  dt {
    font-weight: 600;
    margin-top: 0.75rem;
  }

  dd {
    margin-left: 0;
    color: $charcoal-light;
  }
}

@media (max-width: 575.98px) {
  .cv-entry {
    grid-template-columns: 1fr;
  }

  .cv-dates {
    margin-bottom: 0.25rem;
  }
}
```

- [ ] **Step 2: Add the file to the theme list in `_quarto.yml`**

```yaml
    theme: [cosmo, scss/palette.scss, scss/components.scss, scss/consulting.scss, scss/cv.scss]
```

- [ ] **Step 3: Create `cv.qmd`**

Content below is transcribed from the CV project's YAML as of 2026-09-06 (default profile sections; the locum teaching role is included on the web version because it supports the teaching narrative). The `Download PDF` block is added in Task 12.

````markdown
---
title: "Curriculum Vitae"
description: "CV of Alexander van Twisk: biostatistician, PhD student at the MRC Biostatistics Unit, University of Cambridge."
toc: true
toc-title: "Sections"
---

[Last updated: September 2026]{.cv-updated}

[vantwiska@gmail.com](mailto:vantwiska@gmail.com) · [LinkedIn](https://www.linkedin.com/in/alexander-van-twisk) · [GitHub](https://github.com/alexvantwisk)

## Summary

I am a biostatistician working towards aligning novel statistical theory with practical application in clinical trials. My path from applied mathematics to biostatistics has followed problems that sit where theory, computation, and operational constraints meet, and my time at a clinical research organisation, from intern to lead statistician on regulatory bioequivalence submissions, showed me how often a theoretically optimal design founders on delayed outcomes, randomisation systems, or recruitment realities. I care most about trials in resource-constrained settings, where efficiency gains matter most. From October 2026 I am a PhD student in Biostatistics at the University of Cambridge's MRC Biostatistics Unit. I work precisely and directly, build tools that remove friction for the people around me, and enjoy explaining hard ideas clearly, a habit from teaching mathematics.

## Education

:::: {.cv-entry}
::: {.cv-dates}
Oct 2026 – present
:::
::: {.cv-body}
**PhD Biostatistics**
[University of Cambridge · Cambridge, United Kingdom]{.cv-org}

- Research: *Operationally Feasible Multi-Arm Bandit Response-Adaptive Designs for Clinical Trials*, supervised by Professor Sofia Villar at the MRC Biostatistics Unit.
- Aims to bridge optimal response-adaptive allocation theory and the operational realities of clinical trials: identifying where multi-armed bandit algorithms break down under constraints such as delayed or missing outcomes, and developing modifications that preserve statistical validity and practical feasibility.
- Funded by an MRC Trials Methodology Research Partnership (TMRP) Doctoral Training Partnership studentship.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Jan 2024 – Dec 2025
:::
::: {.cv-body}
**MSc Biostatistics**
[Stellenbosch University · Cape Town, South Africa]{.cv-org}

- Passed with Distinction
- Recipient of a Fogarty International scholarship
- Research focussed on Bayesian survival analysis of interval-censored, weighted data.
- **Courses:** Mathematical Statistics, Statistical Inference, Data Management and Statistical Computing, Linear Models, Survival Analysis, Observational Data Analysis, Categorical Data Analysis, Generalised Linear Models, Clinical Trials, Biostatistics Collaboration, Bayesian Statistics.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Jan 2023 – Nov 2023
:::
::: {.cv-body}
**BScHons Biostatistics**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- Passed with Distinction
- Majoring in Epidemiology and Biostatistics
- Honours class representative
- **Courses:** Epidemiology, Biostatistics, Scientific Writing, Learning in Public Health, Conducting Surveys
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Feb 2022 – Nov 2022
:::
::: {.cv-body}
**Postgraduate Certificate in Education**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- Passed with Distinction
- Specialised in Mathematics and Economics Education
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Feb 2019 – Nov 2021
:::
::: {.cv-body}
**BSc Applied Mathematics**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- Double majored in Economics
- Third-year class representative
:::
::::

## Work Experience

:::: {.cv-entry}
::: {.cv-dates}
Jun 2026 – Sep 2026
:::
::: {.cv-body}
**Biostatistician I**
[Scigenix · Pretoria, South Africa]{.cv-org}

- Lead statistician and programmer on two bioequivalence studies, one with a full CDISC submission to the FDA and the other submitted to the EMA.
- Authored statistical analysis plans (SAPs) for sponsor trials.
- Worked collaboratively across the Data Management and Data Science teams.
- Pioneered agentic AI-assisted programming for building R submission packages, in strict adherence to GCP standards and participant privacy.
- Built three in-house web tools to streamline and automate processes, containerised with Docker and deployed on an AWS EC2 instance with GitHub-based CI/CD.
- Updated the company's statistical computing environment in line with GAMP 5 guidance for compliant GxP computerised systems.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Dec 2025 – May 2026
:::
::: {.cv-body}
**Associate Biostatistician**
[Scigenix · Pretoria, South Africa]{.cv-org}

- Supported clinical research projects through data cleaning, modelling, and reporting across multiple consulting studies.
- Prepared randomisation schedules and contributed to RCT design workflows for sponsor trials.
- Programmed R-based manual edit checks and performed regulatory-grade QC of trial datasets.
- Maintained and extended a production-ready Shiny app for dataset comparison and coding checks used in internal QC workflows.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Jun 2025 – Nov 2025
:::
::: {.cv-body}
**Biostatistician Intern**
[Scigenix · Pretoria, South Africa]{.cv-org}

- Assisted senior biostatisticians with data cleaning, exploratory analyses, and R-based reporting.
- Implemented R-based manual edit checks and supported QC of clinical trial datasets under supervision.
- Built the initial production-ready Shiny app for dataset comparison and coding checks to streamline QC.
- Contributed to database validation activities and documentation of edit checks for sponsor-facing deliverables.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Oct 2024 – Feb 2025
:::
::: {.cv-body}
**Data Capturer**
[Stellenbosch University · Cape Town, South Africa]{.cv-org}

- Clinical study to determine the effects of mindfulness training on student burn-out.
- Capturing survey data onto REDCap.
- Research conducted in partnership between the universities of Oxford and Stellenbosch.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Oct 2022 – Dec 2023
:::
::: {.cv-body}
**Locum Mathematics Teacher**
[Pretoria Boys High School · Pretoria, South Africa]{.cv-org}

- Teaching mathematics to Grades 8 to 12.
- Taking extra mathematics classes after school.
- Presenting revision workshops for Grade 12s.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Mar 2021 – Jun 2022
:::
::: {.cv-body}
**Teaching Assistant**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- Courses taught: Calculus, Linear Algebra.
- Assisting the lecturer responsible with marking and general admin for the modules via ClickUP.
:::
::::

## Selected Talks & Workshops

:::: {.cv-entry}
::: {.cv-dates}
Nov 2025
:::
::: {.cv-body}
**Presenter – Bayesian inference of weighted, interval-censored data: a comparison of Hamiltonian Monte Carlo and Metropolis–Hastings algorithms**
[South African Statistical Association (SASA) Annual Conference · South Africa]{.cv-org}

- 15-minute contributed talk presenting MSc thesis work on weighted, interval-censored HIV data.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
Nov 2025
:::
::: {.cv-body}
**Workshop Facilitator – Prompt → Plot → Proof**
[Stellenbosch University, ML learning short course · Cape Town, South Africa]{.cv-org}

- 2-hour hands-on workshop on using large language models and ggplot2 to streamline biostatistics workflows.
:::
::::

## Skills

::: {.cv-skills}

Programming
:   R (advanced), Stata (intermediate), Python (novice), SQL (novice)

Statistical Methods
:   Sample Size Calculations, GLMMs, Survival Analysis, Categorical Data Analysis, Bayesian Inference, Causal Inference, Clinical Trials

Clinical Data Standards
:   CRF design, data cleaning, clinical report structuring (ADaM, SDTM)

Soft Skills
:   Time Management, Teamwork, Problem-solving, Engaging Presentation, Teaching

:::

## Research Projects

:::: {.cv-entry}
::: {.cv-dates}
2025
:::
::: {.cv-body}
**Bayesian inference of interval-censored data with an application to HIV population surveys: A simulation study and application to an HIV population survey comparing Hamiltonian Monte Carlo and Metropolis–Hastings sampling algorithms**
[Stellenbosch University · Cape Town, South Africa]{.cv-org}

- Conducted a Master's thesis on Bayesian inference for interval-censored HIV seroconversion data using a log-logistic accelerated failure-time model.
- Designed and implemented a large-scale simulation study (5,400 datasets) to compare Hamiltonian Monte Carlo (Stan) with Metropolis–Hastings (JAGS) under complex survey weighting.
- Demonstrated that HMC delivers identical inference with 30–90× higher sampling efficiency and substantially faster convergence.
- Applied the weighted Bayesian model to the ZIMPHIA 2020 HIV population survey to estimate seroconversion dynamics and covariate effects under informative sampling.
- Developed expertise in Bayesian modelling, survival analysis, complex survey methods, HMC/NUTS, MCMC diagnostics, Stan, JAGS, and advanced R programming.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
2023
:::
::: {.cv-body}
**Prevalence and Factors Associated with HIV Testing Among Adolescent Girls and Young Women in Southern African Development Community Countries: Evidence from Latest Demographic and Health Surveys**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- A research protocol developed during my honours year, written with the goal of presenting it to a university ethics committee at the start of my master's studies.
:::
::::

:::: {.cv-entry}
::: {.cv-dates}
2021
:::
::: {.cv-body}
**Comparing the Logistic and Gompertz models in their use for modelling cancer growth using numerical methods**
[University of Pretoria · Pretoria, South Africa]{.cv-org}

- Final-year research project for WTW 383 (Numerical Analysis), comparing two mathematical models of tumour growth using Python implementations of the numerical algorithms learnt in the module.
:::
::::
````

- [ ] **Step 4: Render and verify structure**

```bash
quarto render 2>&1 | tail -2
grep -c 'class="cv-entry"' _site/cv.html
grep -c '<dt>' _site/cv.html
grep -ciE '\+27|Pretoria, South Africa</p>' _site/cv.html
```
Expected: 16 entries; 4 `<dt>`; the last count is 0 (no phone number, no bare address line; "Pretoria, South Africa" appears only inside `.cv-org` spans).

- [ ] **Step 5: Commit**

```bash
git add scss/cv.scss cv.qmd _quarto.yml
git commit -m "feat: hand-written CV page with two-column entries"
```

### Task 12: PDF download, nav item, README, About link

**Files:**
- Add: `files/Alexander_van_Twisk_CV.pdf` (⚠ Alexander supplies)
- Modify: `cv.qmd` (download block), `_quarto.yml` (nav), `about.qmd` (restore CV link), `index.qmd` (add CV card)
- Create: `README.md`

- [ ] **Step 1: ⚠ Ask Alexander for the PDF**

Ask him to place his current CV PDF at `files/Alexander_van_Twisk_CV.pdf`, preferably a variant without phone number and home address. Wait until the file exists:

```bash
test -f files/Alexander_van_Twisk_CV.pdf && echo "PDF present" || echo "PDF missing"
```
Do not continue until it prints `PDF present`.

- [ ] **Step 2: Add the download block to `cv.qmd`**

Insert directly after the front matter, before the `Last updated` line:

```markdown
::: {.cv-download}
[Download PDF](files/Alexander_van_Twisk_CV.pdf){.btn-cta download="Alexander_van_Twisk_CV.pdf"}
:::
```

- [ ] **Step 3: Add CV to the navbar in `_quarto.yml`**

```yaml
    left:
      - href: about.qmd
        text: About
      - href: cv.qmd
        text: CV
```

- [ ] **Step 4: Restore the CV link in `about.qmd`**

Replace `The full record of degrees, roles, and talks is on the CV page.` with `The full record of degrees, roles, and talks is on the [CV](cv.qmd) page.`

- [ ] **Step 5: Make the home page grid three cards** (replace the whole `## Elsewhere on this site` grid in `index.qmd`)

```markdown
## Elsewhere on this site

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
::: {.service-card}
### CV

Degrees, roles, talks, and research projects, with a PDF to download.

[Read the CV &rarr;](cv.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-sage}
### About

The path from applied mathematics to trial methodology, and what the PhD is about.

[About me &rarr;](about.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-teal}
### Consulting

Statistical support for researchers in the medical and public health sciences, from study design to publication.

[Consulting &rarr;](consulting/index.qmd)
:::
:::

::::
```

- [ ] **Step 6: Create `README.md`**

````markdown
# alexvantwisk.github.io / avantwisk.com

Alexander van Twisk's personal website: CV, blog, and consulting pages. Built with Quarto, deployed to GitHub Pages by GitHub Actions.

## Local commands

```bash
quarto preview        # live preview at http://localhost:4200
quarto render         # full build into _site/
```

Quarto is pinned to 1.9.36 in `.github/workflows/publish.yml`. Keep your local version in step and bump both together.

## Updating the CV

1. Edit `cv.qmd` by hand. It is deliberately not linked to any other project.
2. Replace `files/Alexander_van_Twisk_CV.pdf` with the new PDF. Use a variant without phone number or home address.
3. Update the `Last updated` line at the top of `cv.qmd`.

## Deploy

Push to `main`. The workflow renders the site, runs an offline link check, and deploys. Pull requests run the render and link check only.
````

- [ ] **Step 7: Render, verify, commit, PR**

```bash
quarto render 2>&1 | tail -2
test -f _site/files/Alexander_van_Twisk_CV.pdf && echo "PDF shipped"
grep -c 'download="Alexander_van_Twisk_CV.pdf"' _site/cv.html
grep -oE 'href="[^"]*cv.html"' _site/index.html | head -2
git add cv.qmd _quarto.yml about.qmd index.qmd README.md files/
git commit -m "feat: CV download, nav item, README, and home card"
git push -u origin feat/4-cv
gh pr create --base main --head feat/4-cv --title "Step 4: CV page" \
  --body "Hand-written CV with two-column entries, PDF download, nav item, README with maintenance notes."
gh pr checks --watch
```
Expected: `PDF shipped`, count 1, at least one `cv.html` href. **⚠ Alexander merges.**

---

## Step 5: Blog

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/5-blog`

### Task 13: Blog listing, defaults, styling, nav, footer feed

**Files:**
- Create: `blog/index.qmd`, `blog/_metadata.yml`, `blog/_post-footer.qmd`, `scss/blog.scss`
- Modify: `_quarto.yml` (theme list, nav, footer)

**Interfaces:**
- Produces: `blog/_post-footer.qmd` (posts include it), `.post-footer`, the feed at `blog/index.xml`. Tasks 14–16 rely on these.

- [ ] **Step 1: Create `blog/_metadata.yml`**

```yaml
# Defaults for every post under blog/.
# freeze: true means a post's code runs only when you render that post
# locally; the results in _freeze/ are committed and reused by CI, which has
# no R installed. After editing an R post run:
#   quarto render blog/<slug>/index.qmd
# and commit the post together with its _freeze/ output.
execute:
  freeze: true
  echo: true
  warning: false
  message: false
toc: true
author: "Alexander van Twisk"
```

- [ ] **Step 2: Create `blog/_post-footer.qmd`**

```markdown
::: {.post-footer}
[&larr; All posts](../index.qmd)
:::
```

- [ ] **Step 3: Create `blog/index.qmd`**

```markdown
---
title: "Blog"
description: "Writing by Alexander van Twisk on statistics, R, clinical trial methodology, and the occasional essay."
listing:
  contents: "*/index.qmd"
  sort: "date desc"
  type: default
  categories: true
  feed:
    type: full
  fields: [date, title, description, categories, reading-time]
  page-size: 10
  sort-ui: true
  filter-ui: true
---
```

- [ ] **Step 4: Create `scss/blog.scss`**

```scss
/*-- scss:rules --*/

// ---- Blog listing ----
.quarto-listing-default .listing-title {
  font-family: $headings-font-family;
}

.listing-reading-time,
.listing-date {
  color: $sage-text;
}

.quarto-category,
.listing-categories .listing-category {
  background: $cream-dark;
  border-color: $cream-border;
  color: $charcoal-light;
}

// ---- Latest-posts grid on the home page ----
.quarto-grid-item.card {
  border: none;
  border-top: 4px solid $green-forest;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);

  .card-title {
    font-family: $headings-font-family;
    font-size: 1.1rem;
  }
}

// ---- Post footer ----
.post-footer {
  margin-top: 3rem;
  padding-top: 1rem;
  border-top: 1px solid $cream-border;
}
```

- [ ] **Step 5: Update `_quarto.yml`**

Theme list:
```yaml
    theme: [cosmo, scss/palette.scss, scss/components.scss, scss/consulting.scss, scss/cv.scss, scss/blog.scss]
```

Navbar left:
```yaml
    left:
      - href: about.qmd
        text: About
      - href: cv.qmd
        text: CV
      - href: blog/index.qmd
        text: Blog
```

Footer right, add after the GitHub item:
```yaml
      - icon: rss
        href: blog/index.xml
        aria-label: "RSS feed"
```

- [ ] **Step 6: Render and verify**

```bash
quarto render 2>&1 | tail -2
test -f _site/blog/index.html && echo "listing OK"
grep -oE 'href="[^"]*blog/index.xml"' _site/consulting/services.html | head -1
```
Expected: `listing OK`; the href prints as `../blog/index.xml`. The feed file appears once a post exists (Task 14).

- [ ] **Step 7: Commit**

```bash
git add blog/ scss/blog.scss _quarto.yml
git commit -m "feat: blog listing with categories, RSS, and post defaults"
```

### Task 14: Prose starter post

**Files:**
- Create: `blog/welcome/index.qmd`

- [ ] **Step 1: Create the post** (set `date` to the day you write it, ISO format)

```markdown
---
title: "Welcome"
description: "What this site is for and what I plan to write about."
date: 2026-09-06
categories: [Essays]
---

This site started life as the home of my consulting practice. It is now my personal site: an online [CV](../../cv.qmd), this blog, and the [consulting](../../consulting/index.qmd) pages, which stay for researchers who need statistical help.

I'm a biostatistician. From October 2026 I'm a PhD student at the MRC Biostatistics Unit in Cambridge, working on response-adaptive designs for clinical trials. Before that I spent a little over a year at a clinical research organisation in Pretoria, where I went from intern to lead statistician on regulatory bioequivalence submissions.

Here is what I expect to write about:

- **Statistics and R.** Worked examples of the methods researchers ask me about most, with the code.
- **Clinical trials.** Adaptive designs, the gap between what is optimal on paper and what runs in practice, and what I learn along the way in the PhD.
- **The occasional essay** on aviation, geopolitical history, or whatever else has my attention.

Technical posts carry their code so you can run them yourself. If you would like new posts delivered, subscribe to the [RSS feed](../index.xml).

{{< include ../_post-footer.qmd >}}
```

- [ ] **Step 2: Render and verify the feed appears**

```bash
quarto render 2>&1 | tail -2
test -f _site/blog/index.xml && echo "feed OK"
grep -c '<item>' _site/blog/index.xml
grep -c 'post-footer' _site/blog/welcome/index.html
```
Expected: `feed OK`, 1, 1.

- [ ] **Step 3: Commit**

```bash
git add blog/welcome/
git commit -m "feat: welcome post"
```

### Task 15: R starter post with committed freeze output

**Files:**
- Create: `blog/sample-size-two-means/index.qmd`
- Commit: `_freeze/blog/sample-size-two-means/`

- [ ] **Step 1: Create the post** (set `date` to the day you write it)

````markdown
---
title: "How many participants do I need? A worked sample size example"
description: "A sample size calculation for comparing two group means, with the power curve behind it, in base R."
date: 2026-09-07
categories: [Statistics, R]
---

"How many participants do I need?" is the question I am asked most often, and the honest answer starts with four other questions. This post works through the simplest common case, comparing the means of two independent groups, so you can see where the number comes from.

## Four inputs

Say you are planning a trial of a blood pressure intervention against usual care, with systolic blood pressure at 12 weeks as the outcome. A two-sample t-test needs:

1. **The difference worth detecting.** The smallest between-group difference that would change practice. Suppose 5 mmHg.
2. **The spread of the outcome.** The standard deviation of systolic blood pressure in this population. Suppose 10 mmHg, from a previous study.
3. **The significance level.** Almost always 0.05, two-sided.
4. **The power.** The probability of detecting the difference if it is real. 80% is the usual floor; 90% is better if you can afford it.

## The calculation

Base R has this built in.

```{r}
#| label: sample-size
power.t.test(delta = 5, sd = 10, sig.level = 0.05, power = 0.80)
```

Read `n` as participants **per group** and round up: 64 per group, 128 in total.

## Where the number comes from

Power is not a switch. It rises smoothly as the groups grow, and 80% is just the point on the curve we chose to stop at.

```{r}
#| label: power-curve
#| fig-cap: "Power to detect a 5 mmHg difference (SD 10 mmHg) at a two-sided 5% level, by participants per group."
#| fig-alt: "Line chart of power rising with participants per group, crossing 80% at 64 per group."
n <- seq(10, 150, by = 2)
power <- vapply(
  n,
  function(k) power.t.test(n = k, delta = 5, sd = 10, sig.level = 0.05)$power,
  numeric(1)
)

plot(n, power, type = "l", lwd = 2, col = "#2d6a4f", ylim = c(0, 1),
     xlab = "Participants per group", ylab = "Power", las = 1, bty = "l")
abline(h = 0.8, lty = 2, col = "#a68a64")
abline(v = 64, lty = 3, col = "#52796f")
```

## What moves the number

**The effect size dominates.** Halve the difference to 2.5 mmHg and the required sample roughly quadruples, to `r ceiling(power.t.test(delta = 2.5, sd = 10, sig.level = 0.05, power = 0.80)$n)` per group. Be honest about the smallest difference that matters rather than the one you hope for.

**Dropout inflates it.** If you expect 15% of participants to be lost to follow-up, divide by 0.85: 64 / 0.85 is 75.3, so recruit 76 per group.

**More power costs more.** Raising power to 90% needs `r ceiling(power.t.test(delta = 5, sd = 10, sig.level = 0.05, power = 0.90)$n)` per group.

## When this is not your case

This is the simplest situation. Binary outcomes, survival times, clustered or repeated measurements, and unequal group sizes each have their own calculation, and getting the design right is far cheaper before recruitment starts than after. If that is where you are, the [consulting pages](../../consulting/index.qmd) explain how I can help.

{{< include ../_post-footer.qmd >}}
````

- [ ] **Step 2: Render the post locally so R executes and freeze output is written**

```bash
quarto render blog/sample-size-two-means/index.qmd 2>&1 | tail -3
ls _freeze/blog/sample-size-two-means/index/execute-results/
ls _freeze/blog/sample-size-two-means/index/figure-html/
```
Expected: `html.json` and `power-curve-1.png` are listed.

- [ ] **Step 3: Check the rendered numbers**

```bash
grep -oE 'n = 63\.[0-9]+' _site/blog/sample-size-two-means/index.html | head -1
grep -oE 'to 253 per group' _site/blog/sample-size-two-means/index.html | head -1
grep -oE 'needs 8[5-6] per group' _site/blog/sample-size-two-means/index.html | head -1
```
Expected: `n = 63.76…` (per-group estimate), `to 253 per group`, `needs 86 per group` (all three verified with R 4.6 on 2026-09-06). If a number differs, R computed it, so update the prose in Step 1 only where it states a fixed figure (64, 128, 76).

- [ ] **Step 4: Full render without executing, to prove CI's path works**

```bash
quarto render 2>&1 | tail -2
grep -c 'power-curve-1.png' _site/blog/sample-size-two-means/index.html
```
Expected: render succeeds with no `processing file:` lines for this post (frozen), and the figure count is at least 1.

- [ ] **Step 5: Commit the post and the freeze output together**

```bash
git add blog/sample-size-two-means/ _freeze/
git commit -m "feat: sample size worked example post with frozen outputs"
```

### Task 16: Latest posts on the home page and blog notes in the README

**Files:**
- Modify: `index.qmd`, `about.qmd` (restore blog link), `README.md`

- [ ] **Step 1: Replace `index.qmd` with the final version**

```markdown
---
pagetitle: "Alexander van Twisk | Biostatistician"
description: "Alexander van Twisk is a biostatistician and PhD student at the MRC Biostatistics Unit, University of Cambridge, writing about statistics, R, and clinical trial methodology."
listing:
  id: latest-posts
  contents: blog/*/index.qmd
  sort: "date desc"
  max-items: 3
  type: grid
  grid-columns: 3
  fields: [date, title, description]
---

::: {.hero}

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
![](images/headshot.jpg){.hero-photo fig-alt="Alexander van Twisk"}
:::

::: {.g-col-12 .g-col-md-8}

# Alexander van Twisk {.unlisted}

[Biostatistician. PhD student at the MRC Biostatistics Unit, University of Cambridge.]{.follow-up}

[I work on how clinical trials can adapt as they learn, and on making good statistics practical for the researchers who need it. I write here about statistics, R, and trial methodology, and now and then about aviation and history.]{.lead}

[Read the blog](blog/index.qmd){.btn-cta} [Consulting](consulting/index.qmd){.btn-cta .btn-cta-secondary}

:::

::::

:::

## Latest writing

::: {#latest-posts}
:::

[All posts &rarr;](blog/index.qmd)

## Elsewhere on this site

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
::: {.service-card}
### CV

Degrees, roles, talks, and research projects, with a PDF to download.

[Read the CV &rarr;](cv.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-sage}
### About

The path from applied mathematics to trial methodology, and what the PhD is about.

[About me &rarr;](about.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-teal}
### Consulting

Statistical support for researchers in the medical and public health sciences, from study design to publication.

[Consulting &rarr;](consulting/index.qmd)
:::
:::

::::
```

- [ ] **Step 2: Restore the blog link in `about.qmd`**

Replace `Some of that will end up on the blog.` with `Some of that will end up on the [blog](blog/index.qmd).`

- [ ] **Step 3: Append to `README.md`**

````markdown
## Writing a blog post

1. Create `blog/<slug>/index.qmd`. The slug is the URL; keep it short and lower-case with hyphens, no date.
2. Front matter:

   ```yaml
   ---
   title: "Post title"
   description: "One sentence shown in the listing and the feed."
   date: 2026-09-06
   categories: [Statistics, R]   # free-form; existing: R, Statistics, Clinical trials, PhD, Aviation, History, Essays
   draft: true                   # remove to publish; drafts show in quarto preview only
   ---
   ```

3. End the post with `{{< include ../_post-footer.qmd >}}` for the "All posts" link.
4. Put images in the post's folder and reference them by file name.
5. **If the post has R code**, render it locally so the outputs are frozen, then commit both:

   ```bash
   quarto render blog/<slug>/index.qmd
   git add blog/<slug>/ _freeze/blog/<slug>/
   ```

   CI has no R. It reuses `_freeze/`. If you edit an R post and forget to render, CI publishes the previous outputs.
6. Prose posts need no render step beyond checking `quarto preview`.

The feed is at `/blog/index.xml`. Search indexes posts automatically.
````

- [ ] **Step 4: Render, verify, commit, PR**

```bash
quarto render 2>&1 | tail -2
grep -c 'quarto-grid-item' _site/index.html
grep -c 'sample-size-two-means' _site/search.json
git add index.qmd about.qmd README.md
git commit -m "feat: latest posts on the home page, blog notes in README"
git push -u origin feat/5-blog
gh pr create --base main --head feat/5-blog --title "Step 5: blog" \
  --body "Blog listing with categories and full-text RSS, post defaults with freeze, two starter posts (one R with a plot, one prose), latest posts on the home page, README notes."
gh pr checks --watch
```
Expected: grid items at least 2; search count at least 1; CI passes with no R installed. **⚠ Alexander merges.** After deploy, open the live blog, a post, and `/blog/index.xml`.

---

## Step 6: Cutover

Branch: `git checkout main && git pull --ff-only && git checkout -b feat/6-cutover`

### Task 17: Confirm the live host and remove Netlify

**Files:**
- Delete (conditional): `netlify.toml`, `scripts/netlify-build.sh`

- [ ] **Step 1: ⚠ Ask Alexander** whether the site is served from Netlify (a `*.netlify.app` address or a domain pointed at Netlify). Also check what GitHub serves:

```bash
curl -sI https://alexvantwisk.github.io/avtconsulting/ | head -1
```

- [ ] **Step 2a: If Netlify is not in use** (Alexander confirms, or the site was only ever on GitHub Pages):

```bash
git rm netlify.toml scripts/netlify-build.sh
git commit -m "chore: remove Netlify build config; GitHub Pages is the only pipeline"
```

- [ ] **Step 2b: If Netlify is serving the live site:** keep both files for now. Complete Task 19 first, confirm the GitHub Pages URL serves the site, then have Alexander point the domain at GitHub (Task 19 path A) or announce the new address, then run Step 2a.

### Task 18: Personal social card

**Files:**
- Create: `scripts/social-card.R`, `images/social-card-personal.png`
- Modify: `_quarto.yml` (`website.image`)

- [ ] **Step 1: Create `scripts/social-card.R`**

```r
# Renders images/social-card-personal.png (1200 x 630) in the Forest & Sand palette.
# Run from the repo root: Rscript scripts/social-card.R
cream <- "#f5f0e8"
forest <- "#2d6a4f"
sage <- "#52796f"
charcoal <- "#2d3748"
sand <- "#a68a64"

png("images/social-card-personal.png", width = 1200, height = 630)
par(mar = c(0, 0, 0, 0), bg = cream, xaxs = "i", yaxs = "i")
plot.new()
plot.window(xlim = c(0, 1200), ylim = c(0, 630))

rect(0, 600, 1200, 630, col = forest, border = NA)
rect(0, 0, 1200, 24, col = forest, border = NA)
segments(90, 430, 330, 430, col = sand, lwd = 6)

text(90, 355, "Alexander van Twisk", family = "serif", font = 2, cex = 5.2,
     adj = c(0, 0.5), col = charcoal)
text(90, 270, "Biostatistician", family = "sans", cex = 2.4,
     adj = c(0, 0.5), col = sage)
text(90, 215, "PhD student, MRC Biostatistics Unit, University of Cambridge",
     family = "sans", cex = 1.9, adj = c(0, 0.5), col = charcoal)
text(90, 110, "Statistics  ·  R  ·  Clinical trial methodology", family = "sans",
     cex = 1.7, adj = c(0, 0.5), col = sage)
invisible(dev.off())
```

- [ ] **Step 2: Generate and inspect**

```bash
Rscript scripts/social-card.R
file images/social-card-personal.png
```
Expected: `PNG image data, 1200 x 630`. Open the file (Read tool on the PNG) and check that no text is clipped at the right edge. If the name is clipped, lower its `cex` to 4.8 and re-run.

- [ ] **Step 3: Point the site default at the new card**

In `_quarto.yml` change `image: images/social-card.png` to `image: images/social-card-personal.png`. The consulting pages keep their own `image:` set in Task 5.

- [ ] **Step 4: Render, verify, commit**

```bash
quarto render 2>&1 | tail -2
grep -o 'social-card-personal.png' _site/index.html | head -1
grep -o 'images/social-card.png' _site/consulting/index.html | head -1
git add scripts/social-card.R images/social-card-personal.png _quarto.yml
git commit -m "feat: personal social share card; consulting keeps its own"
```
Expected: both greps print a match.

### Task 19: Final URL

Do **exactly one** of path A or path B. **⚠ Ask Alexander** which applies.

#### Path A: custom domain `avantwisk.com`

**Files:**
- Create: `CNAME`
- Modify: `_quarto.yml` (`site-url`, `resources`)

- [ ] **A1: Create `CNAME`** containing one line:

```
avantwisk.com
```

- [ ] **A2: Update `_quarto.yml`**

```yaml
project:
  type: website
  output-dir: _site
  render:
    - "*.qmd"
  resources:
    - CNAME
```
and
```yaml
  site-url: https://avantwisk.com
```

- [ ] **A3: Render and verify the CNAME ships**

```bash
quarto render 2>&1 | tail -2
cat _site/CNAME
grep -o 'https://avantwisk.com/blog/index.xml' _site/blog/index.xml | head -1
```
Expected: `avantwisk.com`; the feed's self-link uses the domain.

- [ ] **A4: ⚠ Alexander sets DNS at Porkbun.** In the domain's DNS panel, delete Porkbun's default parking records for `@` and `www`, then add:

| Type | Host | Answer |
|---|---|---|
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |
| CNAME | www | alexvantwisk.github.io |

- [ ] **A5: Set the custom domain on GitHub Pages** (after A6's merge so the CNAME is deployed, or now; both orders work)

```bash
gh api --method PUT repos/alexvantwisk/avtconsulting/pages -f cname=avantwisk.com
```
Wait for DNS to propagate (minutes to an hour), then:
```bash
dig +short avantwisk.com
gh api --method PUT repos/alexvantwisk/avtconsulting/pages -F https_enforced=true
```
Expected: `dig` prints the four GitHub IPs; the second call succeeds (retry after a few minutes if it reports the certificate is not ready).

- [ ] **A6: Commit, push, PR**

```bash
git add CNAME _quarto.yml
git commit -m "feat: serve the site at avantwisk.com"
git push -u origin feat/6-cutover
gh pr create --base main --head feat/6-cutover --title "Step 6: cutover to avantwisk.com" \
  --body "Site URL and CNAME for the custom domain, personal social card, Netlify config removed."
gh pr checks --watch
```
**⚠ Alexander merges.** GitHub redirects `alexvantwisk.github.io/avtconsulting/` to the custom domain automatically once the domain is active, so no redirect repo is needed.

#### Path B: no domain, root GitHub Pages URL

**Files:**
- Modify: `_quarto.yml` (`site-url`)
- New repo: `alexvantwisk/avtconsulting` (redirect only, after the rename frees the name)

- [ ] **B1: ⚠ Rename the repo** (Alexander confirms)

```bash
gh repo rename alexvantwisk.github.io --repo alexvantwisk/avtconsulting --yes
git remote set-url origin https://github.com/alexvantwisk/alexvantwisk.github.io.git
gh api repos/alexvantwisk/alexvantwisk.github.io/pages --jq .html_url
```
Expected: `https://alexvantwisk.github.io/`

- [ ] **B2: Update `_quarto.yml`**

```yaml
  site-url: https://alexvantwisk.github.io
```

- [ ] **B3: Commit, push, PR**

```bash
git add _quarto.yml
git commit -m "feat: serve the site at alexvantwisk.github.io"
git push -u origin feat/6-cutover
gh pr create --base main --head feat/6-cutover --title "Step 6: cutover to alexvantwisk.github.io" \
  --body "Site URL for the root GitHub Pages address, personal social card, Netlify config removed."
gh pr checks --watch
```
**⚠ Alexander merges.**

- [ ] **B4: Create the redirect repo for old links** (in a scratch directory, not inside this repo)

```bash
mkdir -p /tmp/avtconsulting-redirect && cd /tmp/avtconsulting-redirect && git init -q
cat > index.html <<'EOF'
<!doctype html><html lang="en"><head><meta charset="utf-8">
<meta http-equiv="refresh" content="0; url=https://alexvantwisk.github.io/consulting/">
<link rel="canonical" href="https://alexvantwisk.github.io/consulting/">
<title>Moved</title></head>
<body><p>This site has moved to <a href="https://alexvantwisk.github.io/consulting/">alexvantwisk.github.io/consulting</a>.</p></body></html>
EOF
cp index.html 404.html
git add . && git commit -q -m "Redirect old consulting URLs to the new site"
gh repo create alexvantwisk/avtconsulting --public --source . --push
gh api --method POST repos/alexvantwisk/avtconsulting/pages -f 'source[branch]=main' -f 'source[path]=/'
```
Expected: `https://alexvantwisk.github.io/avtconsulting/anything` lands on the new consulting landing within a few minutes.

### Task 20: Smoke checks and review

- [ ] **Step 1: Redirects and pages** (replace `SITE` with the final base URL)

```bash
SITE=https://avantwisk.com   # or https://alexvantwisk.github.io
for p in / /about.html /cv.html /blog/ /blog/index.xml /consulting/ /consulting/services.html /consulting/contact.html /services/ /contact.html /privacy.html /files/Alexander_van_Twisk_CV.pdf; do
  printf '%-45s %s\n' "$p" "$(curl -s -o /dev/null -w '%{http_code}' "$SITE$p")"; done
```
Expected: every line ends in `200` (the alias pages are 200 responses that redirect in the browser).

- [ ] **Step 2: Share preview.** Paste `SITE/` and `SITE/consulting/` into https://www.opengraph.xyz and confirm the personal card appears for the first and the consulting card for the second.

- [ ] **Step 3: ⚠ Alexander:** send one test message through the contact form and confirm it arrives; open Google Analytics realtime while visiting the site and confirm a hit.

- [ ] **Step 4: Fill in the review section of `tasks/todo.md`**

Record: what shipped (list the six PRs), which checks in this task passed, what was deliberately left out (dark mode, comments, projects page, cvkit link), and any open follow-ups. Tick all steps. Commit on `main` via a small PR:

```bash
git checkout -b chore/todo-review
git add tasks/todo.md
git commit -m "docs: record personal website review in tasks/todo.md"
git push -u origin chore/todo-review
gh pr create --base main --head chore/todo-review --title "docs: todo review" --body "Closes out the personal website plan."
```

---

## Self-review against the spec

- **§4 IA and URLs:** nav (Tasks 6, 12, 13), footer icons (Tasks 4, 13), aliases (Task 5), talks inside CV (Task 11), privacy at root (Task 8), 404 unchanged. Covered.
- **§5.1 Home:** Task 9 then Task 16 (final). **§5.2 About:** Task 10. **§5.3 CV:** Tasks 11–12. **§5.4 Blog:** Tasks 13–16 including freeze, RSS full text, categories, reading time, drafts (documented in README), post footer. **§5.5 Consulting:** Tasks 5–7. **§5.6 Privacy:** Task 8. Covered.
- **§6 Theme:** Task 3 split, Task 6 selector, Task 18 social card, `.btn-cta-secondary` added in Task 5 as the hero's second button. Covered.
- **§7 Layout:** matches the File Structure table; render targets confirmed unchanged.
- **§8 Deployment:** Tasks 1–2, 17, 19 (both paths). **§9 Verification:** CI in Task 2, local checks in every task, cutover checks in Task 20. **§10 Order:** six steps as branches. **§11 Content rules:** all copy is in the plan and drawn from the CV YAML or existing pages; phone/address absent (checked in Task 11 Step 4). **§12 Out of scope:** nothing added.
- **Placeholder scan:** the only variable values are the privacy date (obtained by command), post dates (instruction given), and `SITE` in Task 20 (two concrete choices). No TBDs.
- **Name consistency:** `.btn-cta-secondary` (Task 5 including the stopgap home, Tasks 9 and 16); `consulting/_subnav.qmd` (Tasks 5, 7); `blog/_post-footer.qmd` and `.post-footer` (Tasks 13–15); `#latest-posts` (Task 16); `files/Alexander_van_Twisk_CV.pdf` (Tasks 12, 20); theme list grows in Tasks 3, 11, 13 and is identical each time it is quoted.
