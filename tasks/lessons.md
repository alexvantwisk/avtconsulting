# Lessons

Patterns to apply in this repo, recorded after corrections.

## 2026-09-06: Do not link this site to other repos

- **Correction:** I proposed exporting CV content from the Personal-CV project into this site (cvkit web renderer, or a submodule). Alexander: "I dont want the website and my cv kit to be linked directly. that overcomplicates things."
- **Rule:** This website stays standalone. CV content is hand-written in `cv.qmd`; the CV PDF is copied in by hand. Never propose submodules, pre-render scripts, tokens for private repos, or shared packages between this repo and others.
- **Why it matters:** Content that changes a few times a year does not justify a pipeline. Simplicity of maintenance wins.
