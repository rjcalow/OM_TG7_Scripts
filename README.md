# OM TG-7 RAW Processor

A small RawTherapee-based workflow for OM System TG-7 `.ORF` files, tuned to deliver a warm, film-like snapshot look.

## What’s new in `rawtherapee/kodak-portra-160-vc-3-plus.pp3`

- Film Simulation using `Kodak Portra 160 VC`
- SoftLight blend for a subtle analog feel
- Split-tone color toning for warm highlights and cooler shadows
- Gentle film-style curve and local contrast
- Highlight recovery, chromatic aberration correction, and purple fringe cleanup
- Fine-tuned sharpening and noise reduction for TG-7 RAW

## Workflows

### Standard
`rawtherapee/convert.sh` + `rawtherapee/kodak-portra-160-vc-3-plus.pp3`

Direct ORF → JPEG. Fast and suitable for most TG-7 files.

### ML denoise (optional)
`rawforge/rawforge.sh` → `rawtherapee/develop-dng.sh -p rawforge`

Uses RawForge to denoise the RAW before RawTherapee development.

## Profiles

- `rawtherapee/kodak-portra-160-vc-3-plus.pp3`: standard TG-7 snapshot profile
- `rawtherapee/tg7-rawforge.pp3`: RawForge DNG workflow profile
- `rawtherapee/superia.pp3`: Superia-style film variant

## Requirements

- RawTherapee
- `exiftool`
- Optional: Python + RawForge for ML denoise

## Usage

```bash
./rawtherapee/convert.sh /path/to/file.ORF
./rawforge/rawforge.sh /path/to/file.ORF
./rawtherapee/develop-dng.sh -p rawforge /path/to/file_rawforge.dng
```

## Notes

- `Kodak Portra 160 VC 3 +.pp3` is tuned for a film-snapshot aesthetic rather than a neutral, clinical render.
- The RawForge workflow disables RawTherapee denoise and applies a white-point fix for RawForge DNGs.
- TG-7 lens correction uses embedded ORF metadata because LensFun has no TG-7 profile.

## License

MIT
