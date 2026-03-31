# Consulting Website Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Transform the skeleton Quarto website into a professional, four-page consulting site with the Forest & Sand color palette, approachable academic tone, and email-based contact flow.

**Architecture:** Quarto static site using `cosmo` as the base Bootstrap theme, overridden with a custom SCSS file for the Forest & Sand palette. Pages use Quarto's grid layout system for responsive columns. All contact CTAs use a pre-filled `mailto:` link. Deployed via the existing GitHub Actions workflow to GitHub Pages.

**Tech Stack:** Quarto, Bootstrap 5 (via Quarto), custom SCSS, GitHub Pages

**Design Spec:** `docs/superpowers/specs/2026-03-31-consulting-website-design.md`

---

## File Structure

| File | Action | Responsibility |
|------|--------|---------------|
| `styles.scss` | Create | Forest & Sand theme: color variables, typography, service cards, hero, CTA buttons, footer styling |
| `styles.css` | Delete | Replaced by `styles.scss` |
| `_quarto.yml` | Modify | Theme reference, navbar (with email CTA button), footer, page structure |
| `index.qmd` | Modify | Home page: hero (photo left, text right), service cards, closing CTA |
| `services.qmd` | Modify | Services page: intro, three styled sections, bottom CTA |
| `about.qmd` | Modify | About page: personal intro with photo, credentials section |
| `contact.qmd` | Create | Contact page: heading, framing paragraph, email button, "what to include" list |
| `images/` | Create | Directory for headshot image (user-provided) |

---

### Task 1: Create the Forest & Sand SCSS Theme

**Files:**
- Create: `styles.scss`
- Delete: `styles.css`

- [ ] **Step 1: Create `styles.scss` with theme variables**

```scss
/*-- scss:defaults --*/

// Forest & Sand palette
$green-forest: #2d6a4f;
$green-sage: #52796f;
$teal: #3d8b8a;
$sand: #a68a64;
$cream: #f5f0e8;
$charcoal: #2d3748;

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
$navbar-hl: $sand;

// Footer
$footer-bg: $green-forest;
$footer-fg: $cream;

/*-- scss:rules --*/

// ---- Navbar email CTA button ----
.navbar .navbar-nav .nav-item:last-child .nav-link {
  background-color: $sand;
  color: #fff;
  border-radius: 6px;
  padding: 0.4rem 1.2rem;
  font-weight: 600;
  margin-left: 0.5rem;
  transition: background-color 0.2s ease;

  &:hover {
    background-color: darken($sand, 10%);
    color: #fff;
  }
}

// ---- Hero section ----
.hero {
  padding: 2rem 0 3rem;
}

.hero h1 {
  font-size: 2rem;
  line-height: 1.3;
  margin-bottom: 1rem;
}

.hero .lead {
  font-size: 1.1rem;
  color: $green-sage;
  margin-bottom: 1.5rem;
}

.hero-photo {
  width: 220px;
  height: 220px;
  border-radius: 50%;
  object-fit: cover;
  border: 4px solid $green-sage;
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
    background-color: darken($green-forest, 10%);
    color: #fff;
  }
}

.btn-cta-large {
  font-size: 1.15rem;
  padding: 1rem 2rem;
}

// ---- Service cards ----
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
    color: lighten($charcoal, 15%);
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

// ---- Closing CTA section ----
.cta-section {
  background: darken($cream, 3%);
  border-radius: 8px;
  padding: 2.5rem;
  text-align: center;
  margin-top: 2.5rem;

  h2 {
    font-size: 1.5rem;
    margin-bottom: 0.75rem;
  }

  p {
    color: $green-sage;
    margin-bottom: 1.5rem;
  }
}

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

// ---- About page photo ----
.about-photo {
  width: 100%;
  max-width: 300px;
  border-radius: 8px;
  object-fit: cover;
  border: 3px solid $green-sage;
}

// ---- Contact page ----
.contact-section {
  max-width: 600px;
  margin: 0 auto;
  text-align: center;
}

.contact-section .what-to-include {
  text-align: left;
  margin-top: 2rem;

  h3 {
    font-size: 1.1rem;
  }

  ul {
    color: lighten($charcoal, 15%);
  }
}

// ---- Footer ----
.nav-footer {
  a {
    color: $cream;

    &:hover {
      color: $sand;
    }
  }
}
```

- [ ] **Step 2: Delete `styles.css`**

Run: `rm styles.css`

- [ ] **Step 3: Verify the SCSS file has valid Quarto section markers**

Run: `grep -c "scss:" styles.scss`

Expected: `2` (one `scss:defaults`, one `scss:rules`)

- [ ] **Step 4: Commit**

```bash
git add styles.scss
git rm styles.css
git commit -m "feat: add Forest & Sand SCSS theme, remove placeholder CSS"
```

---

### Task 2: Update `_quarto.yml` Configuration

**Files:**
- Modify: `_quarto.yml`

The email address `your.email@example.com` is a placeholder — replace it with your real email before deploying.

- [ ] **Step 1: Replace `_quarto.yml` contents**

Replace the full contents of `_quarto.yml` with:

```yaml
project:
  type: website
  output-dir: _site

website:
  title: "Alexander van Twisk"
  navbar:
    background: primary
    left:
      - href: index.qmd
        text: Home
      - href: services.qmd
        text: Services
      - href: about.qmd
        text: About
      - href: contact.qmd
        text: Contact
    right:
      - icon: envelope
        href: "mailto:your.email@example.com?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:"
        text: "Get in Touch"
        aria-label: "Email Alexander"
  page-footer:
    left: "© 2026 Alexander van Twisk"
    right:
      - icon: envelope
        href: "mailto:your.email@example.com"
        aria-label: "Email"

format:
  html:
    theme: [cosmo, styles.scss]
    toc: true
```

- [ ] **Step 2: Commit**

```bash
git add _quarto.yml
git commit -m "feat: update quarto config with navbar CTA, footer, and SCSS theme"
```

---

### Task 3: Set Up Images Directory

**Files:**
- Create: `images/` directory
- Create: `images/.gitkeep`

- [ ] **Step 1: Create images directory with .gitkeep**

Run: `mkdir -p images && touch images/.gitkeep`

The user will add their headshot as `images/headshot.png` (or `.png`). All page templates reference `images/headshot.png` — adjust the extension if needed.

- [ ] **Step 2: Commit**

```bash
git add images/.gitkeep
git commit -m "chore: add images directory for headshot"
```

---

### Task 4: Rewrite Home Page

**Files:**
- Modify: `index.qmd`

- [ ] **Step 1: Replace `index.qmd` contents**

Replace the full contents of `index.qmd` with:

```markdown
---
title: "Statistical Consulting"
toc: false
---

::: {.hero}

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
![](images/headshot.png){.hero-photo fig-alt="Alexander van Twisk"}
:::

::: {.g-col-12 .g-col-md-8}

# I help researchers navigate the statistics in their work {.unlisted}

[Biostatistical support for postgraduate students and researchers in medical and public health sciences. From study design through to publication — I'm here to help you get the statistics right.]{.lead}

[Get in touch](mailto:your.email@example.com?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:){.btn-cta}

:::

::::

:::

## What I Offer

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
::: {.service-card}
### Study Design

Sample size calculations, randomisation strategies, and statistical sections for study protocols.

[Learn more &rarr;](services.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-sage}
### Data Analysis

Regression modelling, survival analysis, mixed-effects models, and complex survey designs.

[Learn more &rarr;](services.qmd)
:::
:::

::: {.g-col-12 .g-col-md-4}
::: {.service-card .service-card-teal}
### Reporting

Publication-ready results sections, tables, figures, and reproducible analysis reports.

[Learn more &rarr;](services.qmd)
:::
:::

::::

::: {.cta-section}

## Ready to get started?

Send me a brief description of your project and I'll get back to you.

[Email me about your project](mailto:your.email@example.com?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:){.btn-cta}

:::
```

- [ ] **Step 2: Commit**

```bash
git add index.qmd
git commit -m "feat: rewrite home page with hero, service cards, and CTA"
```

---

### Task 5: Rewrite Services Page

**Files:**
- Modify: `services.qmd`

- [ ] **Step 1: Replace `services.qmd` contents**

Replace the full contents of `services.qmd` with:

```markdown
---
title: "Services"
---

I work with postgraduate students and researchers in medical and public health fields. Whether you're planning a study, analysing data, or writing up results, I can help with the statistical side of your project.

::: {.service-section-green}

## Study Design

Getting the design right from the start saves time and strengthens your research. I can help you with:

- **Sample size and power calculations** — determine how many participants you need to detect a meaningful effect
- **Randomisation strategies** — design appropriate allocation schemes for clinical trials
- **Study protocol statistical sections** — write the statistical methods section of your protocol with the detail reviewers expect

:::

::: {.service-section-sage}

## Data Analysis

I work with a range of methods commonly used in medical and public health research:

- **Exploratory data analysis** — understand your data before formal modelling
- **Regression modelling** — linear, logistic, survival, and mixed-effects models for longitudinal or clustered data
- **Survey data analysis** — handle complex sampling designs, weights, and stratification correctly

:::

::: {.service-section-teal}

## Reporting

Clear statistical reporting is essential for publication and for your examiners:

- **Statistical results sections** — write or review the results section of your manuscript
- **Tables and figures** — produce publication-ready output that meets journal requirements
- **Reproducible analysis reports** — receive a complete, documented analysis you can re-run and verify

:::

::: {.cta-section}

## Not sure what you need?

That's completely fine — many students aren't sure which statistical methods apply to their project, and that's exactly what I'm here to help with. Just send me a brief description and we'll figure it out together.

[Email me about your project](mailto:your.email@example.com?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:){.btn-cta}

:::
```

- [ ] **Step 2: Commit**

```bash
git add services.qmd
git commit -m "feat: rewrite services page with styled sections and CTA"
```

---

### Task 6: Rewrite About Page

**Files:**
- Modify: `about.qmd`

- [ ] **Step 1: Replace `about.qmd` contents**

Replace the full contents of `about.qmd` with:

```markdown
---
title: "About"
---

:::: {.grid}

::: {.g-col-12 .g-col-md-4}
![](images/headshot.png){.about-photo fig-alt="Alexander van Twisk"}
:::

::: {.g-col-12 .g-col-md-8}

I'm a biostatistician who enjoys helping researchers make sense of their data. I know that statistics can feel overwhelming — especially when it's not your primary field — and I aim to make the process straightforward and collaborative. My goal is for you to understand the analysis behind your results, not just receive a set of numbers.

:::

::::

## Expertise

- Clinical trials — design, analysis, and reporting
- Longitudinal and repeated-measures studies
- Survey analysis with complex sampling designs
- Cross-sectional and observational study designs

## Tools

- **R** for statistical computing and data visualisation
- **Quarto** for reproducible reports and documents
- **renv** for reproducible analysis environments

## Experience

I work primarily in clinical trials and also consult with postgraduate students and researchers at universities, helping them navigate the statistical aspects of their research projects in the medical and public health sciences.
```

- [ ] **Step 2: Commit**

```bash
git add about.qmd
git commit -m "feat: rewrite about page with photo and structured credentials"
```

---

### Task 7: Create Contact Page

**Files:**
- Create: `contact.qmd`

- [ ] **Step 1: Create `contact.qmd`**

```markdown
---
title: "Let's Talk About Your Project"
toc: false
---

::: {.contact-section}

I work with postgraduate students and researchers in medical and public health fields. If you're looking for statistical support at any stage of your project, I'd be happy to hear from you.

I typically respond within [X business days — update this].

You don't need to have your statistics figured out before reaching out — that's what I'm here for.

[Email me about your project](mailto:your.email@example.com?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:){.btn-cta .btn-cta-large}

::: {.what-to-include}

### What to include in your email

- Your name and program (e.g. PhD in Public Health)
- A brief description of your research project
- Where you're at in the process — proposal, data collection, analysis, or writing up
- Any deadlines you're working toward

:::

:::
```

- [ ] **Step 2: Commit**

```bash
git add contact.qmd
git commit -m "feat: add contact page with templated email CTA"
```

---

### Task 8: Build and Verify

**Files:** None (verification only)

- [ ] **Step 1: Render the site**

Run: `quarto render`

Expected: Clean build with no errors. Output in `_site/`.

- [ ] **Step 2: Preview the site locally**

Run: `quarto preview`

Expected: Opens in browser. Verify each page:

1. **Home** — hero section with photo placeholder (left) and heading (right), three service cards, closing CTA. Forest & Sand colors applied.
2. **Services** — intro text, three sections with colored left borders, bottom CTA.
3. **About** — photo (left) with personal intro (right), then credentials sections below.
4. **Contact** — centered layout, email button, "what to include" list.
5. **Navbar** — all four page links on the left, "Get in Touch" button (sand-colored) on the right.
6. **Footer** — name/copyright on left, email icon on right.

- [ ] **Step 3: Check responsive layout**

In the browser, resize to mobile width (~375px). Verify:

- Grid columns stack vertically on mobile
- Service cards stack into single column
- Hero photo appears above text on mobile
- Navbar collapses to hamburger menu

- [ ] **Step 4: Fix any styling issues**

If colors, spacing, or layout don't match the spec, adjust `styles.scss` and re-render.

- [ ] **Step 5: Commit any fixes**

```bash
git add -A
git commit -m "fix: adjust styling after visual review"
```

---

## Post-Implementation Checklist

Before deploying, the user needs to:

- [ ] Add headshot photo as `images/headshot.png` (or update file references if using a different format)
- [ ] Replace all `your.email@example.com` with actual email address (appears in `_quarto.yml`, `index.qmd`, `services.qmd`, `contact.qmd`)
- [ ] Update the response time placeholder `[X business days — update this]` in `contact.qmd`
- [ ] Review and personalise the About page text
- [ ] Run `quarto render` and verify the final output
