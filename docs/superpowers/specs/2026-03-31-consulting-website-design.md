# Consulting Website Design Spec

## Overview

A professional Quarto website for Alexander van Twisk's statistical consulting practice. The site targets postgraduate students in medical and public health fields who need biostatistical support. The primary conversion goal is getting visitors to send an inquiry email.

## Audience & Goals

- **Primary audience:** Postgrad students (masters, PhD) in medical and public health programs at universities
- **Tone:** Approachable academic — warm, collegial, non-intimidating. "I'm here to help you through the stats."
- **Primary action:** Email inquiry via a pre-filled mailto template
- **Secondary goal:** Build trust and credibility so students feel comfortable reaching out

## Pages

Four pages: Home, Services, About, Contact.

## Visual Design

### Color Palette — "Forest & Sand"

| Role | Color | Hex |
|------|-------|-----|
| Primary | Deep forest green | `#2d6a4f` |
| Secondary | Sage | `#52796f` |
| Accent | Teal | `#3d8b8a` |
| Warm accent | Sand | `#a68a64` |
| Background | Cream | `#f5f0e8` |
| Body text | Dark charcoal | `#2d3748` |

### Typography

- **Headings:** Georgia or similar serif — conveys warmth and academic credibility
- **Body text:** System sans-serif stack — clean and readable
- **Combination rationale:** Serif headings + sans-serif body is a classic pairing that balances approachability with professionalism

### Quarto Theme

Override the `cosmo` base theme with a custom SCSS file applying the Forest & Sand palette. This gives us Bootstrap's layout system with our own colors and typography.

## Site-Wide Elements

### Navigation

- Top navbar
- Left: site title / name ("Alexander van Twisk")
- Right: Home, Services, About, Contact links
- Prominent email CTA button in the navbar (visible on every page, styled with sand accent color)

### Footer

- Simple: name, copyright year, email link
- No social media links unless added later

### Email Template

All "Get in touch" / "Email me" buttons use a mailto link with pre-filled subject and body:

```
mailto:{email}?subject=Statistical%20Consulting%20Inquiry&body=Name:%0D%0AProgram%20(e.g.%20PhD%20Public%20Health):%0D%0ABrief%20project%20description:%0D%0AWhere%20you%27re%20at%20(proposal%2C%20data%20collection%2C%20analysis%2C%20writing%20up):%0D%0ATimeline%20or%20deadlines:
```

This guides students to provide the information needed for an initial assessment without requiring a form backend.

## Page Designs

### Home Page

**Purpose:** First impression — communicate who you are, what you do, and how to reach you in one scroll.

**Table of contents:** Disabled (landing page, not a document).

**Hero section** (full-width, cream background):
- **Left:** Professional photo in circular crop with subtle border
- **Right:** Headline in Georgia serif ("I help researchers navigate the statistics in their work"), 1-2 sentence subtitle about the audience, and a prominent "Get in touch" email CTA button
- Hero uses a two-column Quarto layout

**Service cards** (3 cards in a row):
- Study Design — forest green (`#2d6a4f`) top border
- Data Analysis — sage (`#52796f`) top border
- Reporting — teal (`#3d8b8a`) top border
- Each card: title, 1-line description, link to Services page
- White cards on cream background for contrast

**Closing CTA** (centered, slightly different background shade):
- "Ready to get started?"
- Brief line about what to include in an email
- Templated email button

### Services Page

**Purpose:** Detail what you offer so students can see if you're the right fit.

**Intro paragraph:** 1-2 sentences about working across the full research lifecycle.

**Three sections** with colored accents matching the Home page service cards:

**Study Design** (forest green accent):
- Sample size and power calculations
- Randomisation strategies
- Study protocol statistical sections

**Data Analysis** (sage accent):
- Exploratory data analysis
- Regression modelling (linear, logistic, survival, mixed-effects)
- Survey data analysis with complex sampling designs

**Reporting** (teal accent):
- Statistical results sections for manuscripts
- Tables and figures for publication
- Reproducible analysis reports

Each section includes a short framing sentence in plain language so students understand what they're getting even if they don't know the terminology.

**Bottom CTA:** "Not sure what you need?" with reassuring copy ("That's fine — just email me a brief description of your project and we'll figure it out together") + templated email button. This removes the barrier for students who don't know the right statistical terms.

### About Page

**Purpose:** Build trust and human connection.

**Personal intro section** (top):
- Photo on the left (larger rectangular crop — differentiates from circular Home photo)
- 2-3 sentences in first person about your approach and why you enjoy this work
- Warm, first-person tone: "I'm a biostatistician who..." not "Alexander is a biostatistician who..."

**Credentials/experience section** (below, structured with subheadings):
- **Expertise:** Clinical trials, longitudinal studies, survey analysis, cross-sectional designs
- **Tools:** R, Quarto, reproducible research workflows
- **Experience:** Brief summary of clinical trials work and university consulting background

No CTA on this page — the navbar email button provides the contact path. About is for trust-building, not selling.

### Contact Page

**Purpose:** Single-purpose page — get the visitor to send an email.

**Heading:** "Let's Talk About Your Project" (or similar)

**Framing paragraph** (2-3 sentences):
- Who you work with
- Expected response time (to be filled in by Alexander)
- Reassurance: "You don't need to have your stats figured out before reaching out"

**Templated email button:** Large, prominent, centered. Opens email client with pre-filled structure.

**"What to include" list** (below button, for those writing their own email):
- Your name and program
- A brief description of your research project
- Where you're at in the process (proposal, data collection, analysis, writing up)
- Any deadlines you're working toward

No form, no calendar, no extras.

## Technical Implementation Notes

### Quarto Configuration

- Base theme: `cosmo` with custom SCSS overrides
- Custom `styles.scss` replacing current `styles.css`
- Table of contents disabled on Home and Contact pages (`toc: false` in YAML frontmatter)
- Photo stored in a project `images/` directory

### Deployment

GitHub Pages via existing GitHub Actions workflow (already configured). No changes needed to the CI pipeline.

### File Structure

```
consulting-website/
  _quarto.yml          # Updated navbar, theme config
  styles.scss          # Custom Forest & Sand theme (replaces styles.css)
  index.qmd            # Home page
  services.qmd         # Services page
  about.qmd            # About page
  contact.qmd          # Contact page (new)
  images/
    headshot.png        # Professional photo (user-provided)
```

### What's Out of Scope

- Blog / resources page (future addition)
- Social media links
- Contact form or booking system
- Analytics / tracking
- Custom domain setup (can be added to GitHub Pages later)
