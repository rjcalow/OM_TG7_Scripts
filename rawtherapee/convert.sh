#!/bin/bash
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")
PROFILE="$SCRIPT_DIR/kodak-portra-160-vc-3-plus.pp3"
files=()

usage() {
  cat <<EOF
Usage: $0 [-p profile.pp3] file1.ORF [file2.ORF ...]

Options:
  -p, --profile  Path to a RawTherapee pp3 profile.
  -h, --help     Show this help message.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -p|--profile)
      shift
      if [[ -z "$1" ]]; then
        echo "Error: missing profile path after -p"
        usage
        exit 1
      fi
      PROFILE="$1"
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    *)
      files+=("$1")
      shift
      ;;
  esac
done

if [[ ${#files[@]} -eq 0 ]]; then
  echo "Error: no input files provided."
  usage
  exit 1
fi

if [[ ! -f "$PROFILE" ]]; then
  if [[ "$PROFILE" != */* && -f "$SCRIPT_DIR/$PROFILE" ]]; then
    PROFILE="$SCRIPT_DIR/$PROFILE"
  else
    echo "Error: profile not found: $PROFILE"
    exit 1
  fi
fi

for f in "${files[@]}"; do
  dir=$(dirname "$f")
  name=$(basename "$f" .ORF)
  outdir="$dir/converted"
  mkdir -p "$outdir"
  flatpak run --command=rawtherapee-cli com.rawtherapee.RawTherapee \
    -o "$outdir/${name}.jpg" \
    -p "$PROFILE" \
    -j95 \
    -c "$f"
done

echo "Done."
