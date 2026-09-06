# Lessons

Patterns to apply in this repo, recorded after corrections.

## 2026-09-06: Do not link this site to other repos

- **Correction:** I proposed exporting CV content from the Personal-CV project into this site (cvkit web renderer, or a submodule). Alexander: "I dont want the website and my cv kit to be linked directly. that overcomplicates things."
- **Rule:** This website stays standalone. CV content is hand-written in `cv.qmd`; the CV PDF is copied in by hand. Never propose submodules, pre-render scripts, tokens for private repos, or shared packages between this repo and others.
- **Why it matters:** Content that changes a few times a year does not justify a pipeline. Simplicity of maintenance wins.

## 2026-09-06: Verify third-party flags and path semantics in a spike before writing them into a plan

- **What happened:** The plan's CI workflow used a lychee flag (`--exclude-mail`) that no longer exists, and assumed Quarto's site-level `image:` resolves from the site root when it resolves per page directory. Both surfaced only in CI or the final review and cost fix rounds.
- **Rule:** When a plan pins a CLI flag or relies on a tool's path resolution, confirm it in the scratch spike (run `--help`, render one nested page and grep the output) before the plan text is final.
- **Why it matters:** A plan is executed verbatim by workers who trust it; unverified details become defects with review overhead attached.
