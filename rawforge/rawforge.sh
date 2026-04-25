#!/bin/bash
# Denoise ORF with RawForge to produce DNG

# ============================================================
# RawForge processing pipeline:
#
#   ORF (camera RAW)
#     │
#     ├─► rawforge ──► DNG (ML-denoised + original EXIF)
#     │
#     ├─► rawtherapee-cli + profile
#     │
#     └─► enhanced JPEG (inherits EXIF from DNG)
#
# ============================================================

source "/home/ricardo/Documents/python env/env/bin/activate"

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

total=$#
count=0
start_time=$(date +%s)

for f in "$@"; do
  count=$((count + 1))
  file_start=$(date +%s)
  
  dir=$(dirname "$f")
  name=$(basename "$f" .ORF)
  outdir="$dir/converted"
  mkdir -p "$outdir"
  dng="$outdir/${name}_rawforge.dng"

  echo ""
  echo "===================================================="
  echo "[$count/$total] Processing: $name.ORF"
  echo "===================================================="

  echo "→ RawForge denoising..."
  rawforge TreeNetDenoiseSuperLight "$f" "$dng" --cfa

  if [ -f "$dng" ] && command -v exiftool &>/dev/null; then
    echo "→ Copying EXIF to DNG..."
    exiftool -overwrite_original -tagsFromFile "$f" -all:all "$dng" >/dev/null
  fi

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
sleep 60
