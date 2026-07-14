# Phase 3 activation steps

Phase 3 shipped two features in a placeholder state. Both need a one-time setup step
before they're fully live.

## 1. Formspree (contact form)

1. Create a free account at [formspree.io](https://formspree.io) using
   `vantwiska@gmail.com`.
2. Click **New Form**, give it a name (e.g. "AVT Consulting contact form").
3. Copy the form ID — the part of the form's endpoint URL after `/f/`
   (e.g. `https://formspree.io/f/abcdwxyz` → `abcdwxyz`).
4. In `contact.qmd`, replace `YOUR_FORM_ID` in the form's `action` attribute with
   that ID.
5. Commit and push the change.

Notes:

- The free tier allows 50 submissions/month. Submissions are also emailed to you
  directly, so you don't need to log in to Formspree to see them.
- **Until step 4 is done, submitting the form will show a Formspree error page**
  (the form ID doesn't exist yet). The "Email me directly using this template"
  fallback link below the form works regardless, so the page is never a dead end.

## 2. Google Analytics (GA4)

1. Create a GA4 property at [analytics.google.com](https://analytics.google.com).
2. Copy the Measurement ID (looks like `G-XXXXXXXXXX`).
3. In `_quarto.yml`, uncomment the `google-analytics:` line under `website:` and
   paste the ID in place of `G-XXXXXXXXXX`.
4. Commit and push the change.

Once analytics is live, a short privacy notice page is a sensible follow-up: GA4
sets identifiers to track visitors, and a brief, POPIA-friendly note on what's
collected and why is good practice once you're actually collecting the data.
