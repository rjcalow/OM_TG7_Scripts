#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

for f in "$@"; do
  dir=$(dirname "$f")
  name=$(basename "$f" .ORF)
  flatpak run --command=rawtherapee-cli com.rawtherapee.RawTherapee \
    -o "$dir/${name}_enhanced.jpg" \
    -p "$SCRIPT_DIR/tg7.pp3" \
    -j95 \
    -c "$f"
done

echo "Done."
