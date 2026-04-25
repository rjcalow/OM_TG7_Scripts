#!/bin/bash
# Copy EXIF from original ORF to enhanced JPEG
# Assumes JPEG is named {original}_enhanced.jpg or {original}_enhanced_with_rawforge.jpg

for jpg in "$@"; do
  dir=$(dirname "$jpg")
  base=$(basename "$jpg" .jpg)
  # Strip known suffixes to find original name
  orig_name="${base%_enhanced_with_rawforge}"
  orig_name="${orig_name%_enhanced}"
  orf="$dir/${orig_name}.ORF"

  if [ ! -f "$orf" ]; then
    echo "✗ No ORF found for $jpg (looked for $orf)"
    continue
  fi

  echo "→ $jpg ← $(basename "$orf")"
  exiftool -overwrite_original -tagsFromFile "$orf" -all:all "$jpg" >/dev/null
done

echo "Done."
