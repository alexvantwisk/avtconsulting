#!/usr/bin/env bash
set -euo pipefail

QUARTO_VERSION="1.7.32"
QUARTO_DIR="$PWD/.quarto-cli"

if [ ! -x "$QUARTO_DIR/bin/quarto" ]; then
  curl -L -o /tmp/quarto.tar.gz \
    "https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz"
  mkdir -p "$QUARTO_DIR"
  tar -xzf /tmp/quarto.tar.gz -C "$QUARTO_DIR" --strip-components=1
fi

export PATH="$QUARTO_DIR/bin:$PATH"
quarto render
