# Personal Website Design Spec

**Date:** 2026-09-06 · **Status:** approved in discussion, awaiting written review
**Supersedes:** the site structure in `2026-03-31-consulting-website-design.md` (visual identity and consulting copy carry over)

## 1. Overview

Turn the AVT Consulting site into Alexander van Twisk's personal website: an online CV, a blog, and a personal home and About page, with the existing consulting practice kept intact as one section of the site. Same repo, same Quarto stack, same Forest & Sand theme, one deployment pipeline.

## 2. Goals and audience

- **Primary job of the site:** introduce Alexander as a biostatistician and PhD student, and publish writing.
- **Secondary job:** keep the consulting funnel working for postgraduate and medical researchers, with the pages moved rather than rebuilt.
- **Audiences:** academic peers, collaborators, and future employers (personal pages); researchers seeking statistical help (consulting pages).
- **Success looks like:** a visitor understands within one screen who Alexander is, can read the CV and the blog without friction, and can find consulting from the home page in one click. Old consulting links keep working.

## 3. Decisions made during design

| Decision | Choice | Rejected alternatives |
|---|---|---|
| Home page focus | Personal first | Balanced; consulting first |
| Site structure | Evolve this repo into the personal site | Two sites; monorepo with the CV project |
| CV content source | Hand-written `cv.qmd`, PDF copied in by hand | Export from cvkit; git submodule of Personal-CV |
| Blog content | Mix of R-based technical posts and prose essays | — |
| Blog execution | Freeze committed to the repo; CI never runs R | R installed in CI |
| Extra pages | None beyond CV, Blog, About, Consulting | Projects page; separate Talks page |
| Dark mode, comments, newsletter, booking link | Out of scope for this version | — |
| Hosting | GitHub Pages via GitHub Actions, custom domain optional | Netlify (config removed once confirmed unused) |

The website must stay independent of the Personal-CV repository. No submodules, shared code, tokens, or generated files cross between them. Personal-CV is a reference for CV facts only.

## 4. Information architecture

The navbar wordmark reads "Alexander van Twisk" and links home. Four nav items; Consulting is styled as the highlighted button that "Get in Touch" is today.

| Nav item | URL | Source | Content |
|---|---|---|---|
| Home | `/` | `index.qmd` | Intro with photo, three latest posts, links to CV and Consulting |
| About | `/about/` | `about.qmd` | Personal story, PhD focus, interests |
| CV | `/cv/` | `cv.qmd` | Hand-written CV with PDF download |
| Blog | `/blog/` | `blog/index.qmd`, `blog/<slug>/index.qmd` | Listing with categories and RSS; one folder per post |
| Consulting | `/consulting/` | `consulting/index.qmd`, `consulting/services.qmd`, `consulting/contact.qmd` | Current consulting pages, moved as a unit |
| — | `/privacy/` | `privacy.qmd` | Site-wide privacy notice, footer link only |
| — | `/404.html` | `404.qmd` | Not-found page |

Talks, workshops, and publications are sections inside the CV page. A separate publications page can split off later when PhD papers accumulate.

**Footer:** copyright line, Privacy link, then icons for email, LinkedIn (`linkedin.com/in/alexander-van-twisk`), GitHub (`github.com/alexvantwisk`), and the RSS feed (`/blog/index.xml`).

**Redirects:** each moved page declares Quarto `aliases` for its old path, so Quarto emits redirect pages at `/services/`, `/contact/`, and their `.html` forms. The old home URL now serves the personal home, which links prominently to Consulting above the fold.

## 5. Page specifications

### 5.1 Home (`index.qmd`)

- No title block (`pagetitle` only), no table of contents.
- Hero: circular photo left; name, one-line identity ("Biostatistician. PhD student at the MRC Biostatistics Unit, University of Cambridge."), two or three sentences, and two buttons: "Read the blog" and "Consulting".
- "Latest writing": a Quarto listing over `blog/*/index.qmd`, newest first, three items, grid layout styled as the existing cards, showing date, title, description.
- Short closing row with links to the CV and to Consulting.

### 5.2 About (`about.qmd`)

- Photo (rectangular crop, as today) beside two or three first-person paragraphs: the path from applied mathematics to biostatistics, the clinical trials work, the PhD in plain words (response-adaptive designs and why operational constraints matter), and a line on aviation and geopolitical history.
- No consulting pitch. A single sentence points to the Consulting section for anyone seeking help.
- Facts come from the CV content; nothing is invented.

### 5.3 CV (`cv.qmd`)

- Title "Curriculum Vitae", sidebar table of contents, a "Download PDF" button linking `files/Alexander_van_Twisk_CV.pdf`, and a "Last updated" line.
- The PDF is copied in by hand from the CV project's build output whenever the CV changes. The copied variant should omit phone number and home address. The page shows email and LinkedIn only.
- Sections, in this order: Summary, Education, Work Experience, Selected Talks & Workshops, Skills, Research Projects. Publications is added when the first item exists.
- Each dated entry uses a `.cv-entry` layout: dates in a narrow left column, title, organisation, location, and highlights on the right. On narrow screens the columns stack.
- No code execution on this page.

### 5.4 Blog

**Listing (`blog/index.qmd`):**
- Contents `*/index.qmd`, sorted by date descending, default list layout, ten per page.
- Fields: date, title, description, categories, reading time.
- Category filter in the margin; sort and filter controls on.
- Full-text RSS feed emitted as `blog/index.xml`.

**Posts (`blog/<slug>/index.qmd`):**
- Front matter: `title`, `description`, `date`, `categories`, optional `image`, optional `draft: true`.
- Slug folders carry no date; the date lives in front matter. Each post's images sit in its own folder.
- Categories are free-form. Starter set: R, Statistics, Clinical trials, PhD, Aviation, History.
- Drafts stay out of the built site until the flag is removed; they show in local preview.

**Defaults (`blog/_metadata.yml`):**
- `execute: freeze: true`; `echo: true`; warnings and messages off.
- `toc: true`, author name, a back link to the blog, no comments.

**Freeze workflow:** render an R post locally (`quarto render blog/<slug>/index.qmd` or `quarto preview`), commit the post and its `_freeze/` output together, push. CI reuses the frozen outputs and does not install R. Prose posts have no code and need no freeze output. If an R post is edited without a local render, CI still builds with the previous outputs, and the pull-request render check surfaces the stale state for review.

### 5.5 Consulting section (`consulting/`)

- `index.qmd` (landing), `services.qmd`, `contact.qmd`, `_cta-button.qmd`, `_subnav.qmd`.
- Each page declares `aliases` for its previous root path.
- `_subnav.qmd` is a one-line link row, "Consulting: Overview · Services · Contact", included at the top of all three pages.
- Landing keeps today's hero, service cards, credibility cards, and closing CTA. Copy states that Alexander is a PhD student at the MRC Biostatistics Unit who takes on a limited number of remote consulting projects, working with researchers in South Africa and the UK.
- Credibility cards become: PhD in trials methodology; clinical trials experience as lead statistician on regulatory bioequivalence submissions; formal training; teaching background.
- Services keeps its sections and FAQ, plus one new FAQ answer on availability and turnaround alongside the PhD. The confidentiality answer names UK GDPR alongside POPIA.
- Contact keeps the Formspree form, hidden subject and honeypot fields, the email fallback, and the "How it works" steps. Prices remain unstated.
- The consulting pages set `image:` to the existing consulting social card.

### 5.6 Privacy (`privacy.qmd`)

Scope widens to the whole site: analytics on every page, the contact form, direct email, the RSS feed (no tracking), and client data. Mentions UK GDPR alongside POPIA. Fresh "last updated" date.

## 6. Theme and shared components

- Palette, typography, and the contrast-tuned shades from July stay unchanged. No web fonts, no dark mode, no JavaScript beyond Quarto's own.
- `styles.scss` splits into small files listed in the theme configuration: `scss/palette.scss` (defaults: colours, fonts, Bootstrap variables), `scss/components.scss` (navbar button, CTA buttons, cards, footer), `scss/blog.scss` (listing and post styling), `scss/cv.scss` (`.cv-entry` layout), `scss/consulting.scss` (service sections, FAQ, contact form, how-it-works, subnav). Each file keeps Quarto's `scss:defaults` / `scss:rules` markers as needed.
- The navbar highlight rule targets the Consulting link by `href` containing `consulting`, replacing the current `contact` match.
- New social share image (1200×630) with the name and identity line for personal pages; the existing card stays for consulting pages.
- The headshot stays as the optimised JPEG.

## 7. Configuration and repository layout

```
_quarto.yml            # site config: nav, footer, theme list, render targets, site-url
scss/                  # palette, components, blog, cv, consulting
index.qmd  about.qmd  cv.qmd  privacy.qmd  404.qmd
blog/_metadata.yml  blog/index.qmd  blog/<slug>/index.qmd
consulting/index.qmd  services.qmd  contact.qmd  _cta-button.qmd  _subnav.qmd
files/Alexander_van_Twisk_CV.pdf
images/                # headshot.jpg, favicon.png, social-card.png (consulting), social-card-personal.png
_freeze/               # committed executed outputs for R posts
.github/workflows/publish.yml
docs/                  # specs and plans, excluded from render
tasks/                 # todo and lessons, excluded from render
```

- Render targets are listed explicitly so `docs/`, `tasks/`, and `README.md` never render. The exact glob form is verified by rendering during implementation.
- Site-wide `toc: false`; the CV page and blog posts opt in.
- `_site/` and `.quarto/` stay ignored; `_freeze/` is tracked.

## 8. Deployment

- **Pipeline:** GitHub Actions renders and deploys to GitHub Pages on pushes to `main`; pull requests run the render and link check only. Quarto is pinned to the version on Alexander's machine (1.9.36 at the time of writing) and bumped deliberately.
- **Netlify:** `netlify.toml` and `scripts/netlify-build.sh` are deleted once it is confirmed that the live site does not depend on Netlify. If it does, DNS moves to GitHub Pages at cutover and the files are deleted then.
- **Repository settings (Alexander's actions, guided):** make the repo public; set Pages source to "GitHub Actions". The Pages-enabled probe in the workflow is then removed.
- **URL, with the domain `avantwisk.com`:** the repo name is irrelevant; a `CNAME` file is shipped via `resources`; `site-url` is `https://avantwisk.com`; Porkbun DNS carries the four GitHub Pages A records and a `www` CNAME; HTTPS is enforced in Pages settings. A one-file repository keeps the old `alexvantwisk.github.io/avtconsulting` address redirecting to the domain.
- **URL, without a domain:** the repo is renamed `alexvantwisk.github.io` so the site serves at the root; `site-url` is `https://alexvantwisk.github.io`; a tiny `avtconsulting` repo redirects old links.
- `site-url` must match the real host before the sitemap, RSS, and share previews are correct.

## 9. Verification

Build-level checks stand in for unit tests on a static site.

- **CI, every push and pull request:** `quarto render`; then a link checker (lychee) in offline mode over `_site`, so broken internal links and missing redirect pages fail the build without depending on external hosts.
- **Locally, per task:** full render; browser check of navigation and layout at desktop and phone widths; confirm an alias page exists in `_site` for every moved URL; confirm `_site/blog/index.xml` exists and parses; confirm `_site/search.json` contains the posts; confirm that rendering an R post creates its `_freeze/` output.
- **At cutover:** one test submission through the contact form; confirm analytics fires on the new host; check the share preview for the new social card; confirm every old consulting URL redirects.

## 10. Order of work

Six steps, each leaving the site deployable, each its own branch and pull request.

1. **Foundation.** Pin Quarto; explicit render targets; split the stylesheet; wordmark and nav skeleton; footer icons; GitHub Pages settings; lychee link check in CI.
2. **Move consulting.** Files under `consulting/`, aliases, subnav include, positioning copy, credibility cards, new FAQ answer, widened privacy notice.
3. **Home and About.** Personal hero, closing links row, rewritten About. The latest-posts listing is added in step 5 once posts exist.
4. **CV.** `cv.qmd`, `.cv-entry` styling, PDF in `files/`.
5. **Blog.** Listing, `_metadata.yml`, RSS, home-page listing, two starter posts (one R with a plot, one prose) to prove both paths, freeze committed.
6. **Cutover.** `site-url`, domain or repo rename, redirect repo, personal social card, Netlify removal, smoke checks.

## 11. Content rules

- Never invent facts. CV and About content is copied from the CV project's YAML or from the existing site and rephrased only for tone.
- Phone number and home address never appear on the site or in the shipped PDF.
- British English throughout, matching the existing copy.

## 12. Out of scope

Dark mode, comments, newsletter, booking link, testimonials, JSON-LD structured data, a Projects page, a separate publications page, any automation between this repo and Personal-CV.

## 13. Open items to settle during implementation

- Where the site is currently served (GitHub Pages or Netlify), checked before deleting the Netlify files.
- Whether `avantwisk.com` is purchased; both URL paths are specified above.
- The exact wording of the availability FAQ answer and the response-time promise while the PhD is under way.
