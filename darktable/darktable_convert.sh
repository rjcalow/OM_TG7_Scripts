#!/bin/bash
# ============================================================
# Develop TG-7 ORF files using darktable-cli (Flatpak)
#
#   ORF ──► darktable-cli + XMP profile ──► JPEG
#
# Requires: flatpak override --user --filesystem=/media org.darktable.Darktable
# ============================================================

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
XMP="$SCRIPT_DIR/tg7.ORF.xmp"

total=$#
count=0
start_time=$(date +%s)

for f in "$@"; do
  count=$((count + 1))
  file_start=$(date +%s)

  dir=$(dirname "$f")
  name=$(basename "$f")
  name="${name%.*}"
  ext="${f##*.}"
  if [[ "${ext,,}" == "dng" ]]; then
    XMP_FILE="$SCRIPT_DIR/rawforge_dng.xmp"
    source_type="DNG"
  else
    XMP_FILE="$SCRIPT_DIR/tg7.ORF.xmp"
    source_type="ORF"
  fi
  outdir="$dir/darktable_exports"
  mkdir -p "$outdir"
  jpg="$outdir/${name}_darktable.jpg"

  echo ""
  echo "===================================================="
  echo "[$count/$total] Processing: $name.$ext ($source_type)"
  echo "===================================================="

  echo "→ darktable developing..."
  flatpak run --command=darktable-cli org.darktable.Darktable \
    "$f" "$XMP_FILE" "$jpg" \
    --hq true \
    --core --configdir "$HOME/.cache/darktable-cli" \
    --conf plugins/imageio/format/jpeg/quality=100

  file_end=$(date +%s)
  file_elapsed=$((file_end - file_start))
  echo "✓ Done in ${file_elapsed}s"
done

end_time=$(date +%s)
total_elapsed=$((end_time - start_time))
mins=$((total_elapsed / 60))
secs=$((total_elapsed % 60))

echo ""
echo "===================================================="
echo "All done. Processed $total file(s) in ${mins}m ${secs}s"
echo "===================================================="
