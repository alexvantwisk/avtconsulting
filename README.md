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
2. Update the `Last updated` line at the top of `cv.qmd`.
3. To offer a PDF later: place it at `files/Alexander_van_Twisk_CV.pdf` (use a variant without phone number or home address) and add this block directly after the front matter of `cv.qmd`:

   ```markdown
   ::: {.cv-download}
   [Download PDF](files/Alexander_van_Twisk_CV.pdf){.btn-cta download="Alexander_van_Twisk_CV.pdf"}
   :::
   ```

## Deploy

Push to `main`. The workflow renders the site, runs an offline link check, and deploys. Pull requests run the render and link check only.

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

Posts without an `image:` of their own use the site's personal share card automatically.

The feed is at `/blog/index.xml`. Search indexes posts automatically.
