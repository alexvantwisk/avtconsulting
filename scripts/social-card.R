# Renders images/social-card-personal.png (1200 x 630) in the Forest & Sand palette.
# Run from the repo root: Rscript scripts/social-card.R
cream <- "#f5f0e8"
forest <- "#2d6a4f"
sage <- "#52796f"
charcoal <- "#2d3748"
sand <- "#a68a64"

png("images/social-card-personal.png", width = 1200, height = 630)
par(mar = c(0, 0, 0, 0), bg = cream, xaxs = "i", yaxs = "i")
plot.new()
plot.window(xlim = c(0, 1200), ylim = c(0, 630))

rect(0, 600, 1200, 630, col = forest, border = NA)
rect(0, 0, 1200, 24, col = forest, border = NA)
segments(90, 430, 330, 430, col = sand, lwd = 6)

text(90, 355, "Alexander van Twisk",
  family = "serif", font = 2, cex = 5.2,
  adj = c(0, 0.5), col = charcoal
)
text(90, 270, "Biostatistician",
  family = "sans", cex = 2.4,
  adj = c(0, 0.5), col = sage
)
text(90, 215, "PhD student, MRC Biostatistics Unit, University of Cambridge",
  family = "sans", cex = 1.9, adj = c(0, 0.5), col = charcoal
)
text(90, 110, "Statistics  ·  R  ·  Clinical trial methodology",
  family = "sans",
  cex = 1.7, adj = c(0, 0.5), col = sage
)
invisible(dev.off())
