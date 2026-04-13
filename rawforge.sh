#!/bin/bash
# Denoise ORF with RawForge, then develop with RawTherapee

# ============================================================
# RawForge processing pipeline:
#
#   ORF (camera RAW)
#     │
#     ├─► rawforge ──► DNG (ML-denoised, metadata stripped)
#     │
#     ├─► exiftool ──► DNG (+ original EXIF from ORF)
#     │
#     ├─► rawtherapee-cli + tg7-for-rawforge-dng-files.pp3
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
  dng="$dir/${name}_rawforge.dng"
  jpg="$dir/${name}_enhanced_with_rawforge.jpg"

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

  echo "→ RawTherapee developing..."
  flatpak run --command=rawtherapee-cli com.rawtherapee.RawTherapee \
    -o "$jpg" \
    -p "$SCRIPT_DIR/tg7-for-rawforge-dng-files.pp3" \
    -j100 \
    -c "$dng"

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
