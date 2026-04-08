# OM TG-7 RAW Processor

Batch convert OM System TG-7 `.ORF` RAW files to enhanced JPEGs using RawTherapee CLI, with optional ML denoising via [RawForge](https://github.com/rymuelle/RawForge).

## What it does

Applies a tuned processing profile to TG-7 RAW files, producing better results than the camera's built-in JPEG processing:

- Highlight recovery
- Edge-preserving local contrast
- Sharpening with post-demosaic pass
- Noise reduction with detail preservation
- Purple/blue fringe removal
- Chromatic aberration correction
- Mild dehaze
- Hot pixel removal
- Lens distortion correction (from camera metadata)

Output files are saved alongside the originals as `filename_enhanced.jpg`.

## Two workflows

### Standard: `convert.sh` + `tg7.pp3`

Direct ORF → JPEG via RawTherapee. Fast, good for most shots.

### ML-denoised: `rawforge.sh` + `tg7-for-rawforge-dng-files.pp3`

ORF → RawForge denoise → DNG → RawTherapee → JPEG. Slower (~30s+ per file) but cleans up noise at the RAW level using a neural network. Best for higher-ISO shots where standard NR smears detail.

The RawForge variant uses a separate profile with denoising disabled in RawTherapee (since RawForge already handled it) and a white-point correction (`PreExposure=1.31`) to compensate for RawForge's DNG metadata quirk that otherwise causes magenta highlight clipping.

## Requirements

- [RawTherapee](https://rawtherapee.com/) installed via Flatpak:
  ```bash
  flatpak install flathub com.rawtherapee.RawTherapee
  ```

- For the RawForge workflow, a Python venv with RawForge installed:
  ```bash
  python3 -m venv ~/path/to/env
  source ~/path/to/env/bin/activate
  pip install rawforge
  ```
  Then update the `source` line at the top of `rawforge.sh` to point at your venv.

## Usage

### Thunar Custom Action (recommended)

1. Open Thunar → **Edit** → **Configure Custom Actions** → **Add**
2. Set:
   - **Name:** `Process ORF` (or `Process ORF (RawForge)`)
   - **Command:** `/path/to/convert.sh %F` (or `rawforge.sh %F`)
   - **Appearance Conditions:** File Pattern `*.ORF`, tick **Other Files**
3. Select ORF files → right-click → **Process ORF**

### Command line

```bash
./convert.sh /path/to/file1.ORF /path/to/file2.ORF
./rawforge.sh /path/to/file1.ORF
```

## Customising profiles

Open any `.ORF` in RawTherapee GUI, tweak settings, then save the profile as `tg7.pp3` (or `tg7-for-rawforge-dng-files.pp3`) in this folder to override the defaults.

## Known issues

- **RawForge DNG highlight clipping:** RawForge writes DNGs with a white level that RawTherapee misreads, causing magenta-clipped highlights. The rawforge profile compensates with `PreExposure=1.31`. Reported upstream.
- **TG-7 lens distortion:** RawTherapee's `lfauto` lensfun mode does not have a TG-7 profile. Both pp3s use `LcMode=metadata` instead, which reads the correction coefficients embedded in the ORF by the camera.
- **f/8 on the TG-7 is not a real aperture:** It's f/2.8 with an internal ND filter. There is no diffraction penalty, but no extra depth of field either. Shoot wide open for sharpest results.

## License

MIT
