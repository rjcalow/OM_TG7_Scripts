# OM TG-7 RAW Processor

Batch convert OM System TG-7 `.ORF` RAW files to enhanced JPEGs using RawTherapee CLI.

## What it does

Applies a tuned processing profile (`tg7.pp3`) to TG-7 RAW files, producing better results than the camera's built-in JPEG processing:

- Highlight recovery
- Edge-preserving local contrast
- Sharpening with post-demosaic pass
- Noise reduction with detail preservation
- Purple fringe removal
- Chromatic aberration correction
- Mild dehaze
- Hot pixel removal
- Lens distortion correction

Output files are saved alongside the originals as `filename_enhanced.jpg`.

## Requirements

- [RawTherapee](https://rawtherapee.com/) installed via Flatpak:
  ```
  flatpak install flathub com.rawtherapee.RawTherapee
  ```

## Usage

### Option 1: Thunar Custom Action (recommended)

1. Open Thunar → **Edit** → **Configure Custom Actions** → **Add**
2. Set:
   - **Name:** `Process ORF`
   - **Command:** `/path/to/convert.sh %F`
   - **Appearance Conditions:** File Pattern `*.ORF`, tick **Other Files**
3. Select ORF files → right-click → **Process ORF**

### Option 2: Desktop file

1. Right-click `Process-ORF.desktop` → **Properties** → **Permissions** → tick **Allow this file to run as a program**
2. Drag and drop ORF files onto it

### Option 3: Command line

```bash
./convert.sh /path/to/file1.ORF /path/to/file2.ORF
```

## Customising the profile

Open any `.ORF` in RawTherapee GUI, tweak settings, then save the profile as `tg7.pp3` in this folder to override the defaults.

## License

MIT
