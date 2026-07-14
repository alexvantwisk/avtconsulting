# Phase 3 activation steps

Phase 3 shipped two features in a placeholder state. Both need a one-time setup step
before they're fully live.

## 1. Formspree (contact form) — ✅ done (2026-07-14)

The form in `contact.qmd` is wired to the live endpoint
`https://formspree.io/f/xojgvnla`, with submissions delivered to
`vantwiska@gmail.com`.

Notes:

- The free tier allows 50 submissions/month. Submissions are also emailed to you
  directly, so you don't need to log in to Formspree to see them.
- After the first submission arrives, send one test submission yourself from the
  live site to confirm end-to-end delivery.

## 2. Google Analytics (GA4) — ✅ done (2026-07-14)

`_quarto.yml` carries the live Measurement ID (`G-3EB0K5GDXG`); tracking starts
once the site deploys from `main`. Data appears in the GA4 dashboard within a
day or so of the first visits.

Follow-up worth doing: a short privacy notice page. GA4 sets identifiers to
track visitors, and a brief, POPIA-friendly note on what's collected and why is
good practice now that data is actually being collected.
