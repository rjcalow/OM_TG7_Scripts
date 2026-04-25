#!/bin/bash
# Develop DNG with RawTherapee using specified profile

SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Default profile
PROFILE="rawforge"

# Parse options
while getopts "p:" opt; do
  case $opt in
    p) PROFILE="$OPTARG" ;;
    *) echo "Usage: $0 [-p profile] file1.dng [file2.dng ...]"
       echo "Profiles: rawforge (default), superia"
       exit 1 ;;
  esac
done
shift $((OPTIND - 1))

# Set profile file based on choice
if [ "$PROFILE" = "superia" ]; then
  PP3_FILE="$SCRIPT_DIR/superia.pp3"
elif [ "$PROFILE" = "rawforge" ]; then
  PP3_FILE="$SCRIPT_DIR/tg7-for-rawforge-dng-files.pp3"
else
  echo "Unknown profile: $PROFILE"
  echo "Available: rawforge, superia"
  exit 1
fi

total=$#
count=0
start_time=$(date +%s)

for dng in "$@"; do
  count=$((count + 1))
  file_start=$(date +%s)
  
  dir=$(dirname "$dng")
  name=$(basename "$dng" .dng)
  if [ "$PROFILE" = "rawforge" ]; then
    jpg="$dir/${name}_enhanced.jpg"
  else
    jpg="$dir/${name}_enhanced_${PROFILE}.jpg"
  fi

  echo ""
  echo "===================================================="
  echo "[$count/$total] Developing: $name.dng with $PROFILE profile"
  echo "===================================================="

  echo "→ RawTherapee developing..."
  flatpak run --command=rawtherapee-cli com.rawtherapee.RawTherapee \
    -o "$jpg" \
    -p "$PP3_FILE" \
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