#!/bin/bash
# Startup hook: copy notebooks from /opt/notebooks/ to ~/drive/ at first launch.
# Child images add their notebooks via:  COPY --chown=1000:100 notebooks/ /opt/notebooks/
# This script runs once per notebook — it never overwrites an existing file,
# so user edits made in a previous session are preserved.
mkdir -p "${HOME}/drive"
for nb in /opt/notebooks/*.ipynb; do
  [ -f "$nb" ] || continue
  dest="${HOME}/drive/$(basename "$nb")"
  [ -f "$dest" ] || cp "$nb" "$dest"
done
