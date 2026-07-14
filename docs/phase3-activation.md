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

## 2. Google Analytics (GA4) — pending

1. Create a GA4 property at [analytics.google.com](https://analytics.google.com).
2. Copy the Measurement ID (looks like `G-XXXXXXXXXX`).
3. In `_quarto.yml`, uncomment the `google-analytics:` line under `website:` and
   paste the ID in place of `G-XXXXXXXXXX`.
4. Commit and push the change.

Once analytics is live, a short privacy notice page is a sensible follow-up: GA4
sets identifiers to track visitors, and a brief, POPIA-friendly note on what's
collected and why is good practice once you're actually collecting the data.
