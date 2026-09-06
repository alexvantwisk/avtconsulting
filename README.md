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
