# Clipboard Manager Widget for Eww

A clipboard history manager widget built with [Eww (ElKowars wacky widgets)](https://github.com/elkowar/eww) that tracks and displays your clipboard history with a clean, modern interface.

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- 📋 **Clipboard History Tracking** - Automatically saves up to 40 clipboard entries
- 🔄 **Cross-Platform Support** - Works with Wayland (`wl-clipboard`) and X11 (`xclip`/`xsel`)
- 🎨 **Modern UI** - Catppuccin-inspired color scheme with smooth scrolling
- 💾 **Persistent Storage** - History saved as base64-encoded entries
- ⚡ **Fast Access** - One-click to restore any previous clipboard entry
- 🔒 **Safe Encoding** - Handles special characters and multiline text

## Prerequisites

- [Eww](https://github.com/elkowar/eww) (ElKowars wacky widgets)
- Clipboard utilities:
  - **Wayland**: `wl-clipboard` (recommended)
  - **X11**: `xclip` or `xsel`
- `jq` (recommended for JSON processing) or `python3` (fallback)
- `base64` (usually pre-installed)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/84Ebi/eww.git
cd eww
git checkout clipboard-manager
```

2. Copy the widget files to your Eww config directory:
```bash
mkdir -p ~/.config/eww/scripts
cp "clipboard manager widget/scripts/"* ~/.config/eww/scripts/
chmod +x ~/.config/eww/scripts/clipboard_*.sh
```

3. Add the widget configuration to your `~/.config/eww/eww.yuck`:
```yuck
;; Poll clipboard history 
(defpoll clipboard-history :interval "1s" :initial "[]" 
  "bash ~/.config/eww/scripts/clipboard_history.sh")

;; Clipboard Widget
(defwidget clipboard-widget []
  (box :class "clipboard-outer" :orientation "vertical" :space-evenly false
    (label :class "clipboard-title" :text "Clipboard" :halign "center")
    (scroll :height 550 :vscroll true
      (box :class "clipboard-inner" :orientation "vertical" :space-evenly false
        (for entry in clipboard-history
          (button :class "clipboard-item"
                  :onclick `echo '${entry}' | bash ~/.config/eww/scripts/clipboard_copy.sh`
                  (label :class "clipboard-label" :text entry 
                         :wrap "true" :limit-width 250 :halign "start")))))))

;; Clipboard Window
(defwindow clipboard_window
  :monitor 0
  :geometry (geometry :x "115px" :y "330" :width "300px" :height "600px")
  :stacking "bg"
  :windowtype "dock"
  :wm-ignore false
  (clipboard-widget))
```

4. Add the styles from [clipboard manager widget/eww.scss](clipboard manager widget/eww.scss) to your Eww SCSS file.

## Usage

1. Start the clipboard widget:
```bash
eww open clipboard_window
```

2. Copy text as usual (Ctrl+C, right-click copy, etc.)

3. Click any entry in the widget to restore it to your clipboard

4. To close the widget:
```bash
eww close clipboard_window
```

## Configuration

### Maximum History Items

Edit [clipboard manager widget/scripts/clipboard_history.sh](clipboard manager widget/scripts/clipboard_history.sh):
```bash
MAX_ITEMS=40  # Change to your preferred number
```

### Update Interval

Modify the polling interval in your `eww.yuck`:
```yuck
(defpoll clipboard-history :interval "1s" ...)  # Change "1s" to your preference
```

### Widget Position and Size

Adjust in the `defwindow` geometry settings:
```yuck
:geometry (geometry :x "115px" :y "330" :width "300px" :height "600px")
```

## File Structure

```
clipboard manager widget/
├── eww.scss              # Widget styles
├── eww.yuck              # Widget configuration
└── scripts/
    ├── clipboard_copy.sh    # Copies text to system clipboard
    └── clipboard_history.sh # Manages clipboard history
```

## How It Works

1. **[clipboard_history.sh](clipboard manager widget/scripts/clipboard_history.sh)** polls the system clipboard every second
2. New clipboard content is base64-encoded and stored in `~/.config/eww/clipboard_history.b64`
3. The script outputs a JSON array of decoded entries for Eww to display
4. When you click an entry, **[clipboard_copy.sh](clipboard manager widget/scripts/clipboard_copy.sh)** restores it to the clipboard

## Troubleshooting

### Widget not showing clipboard entries
- Ensure clipboard utilities are installed: `wl-clipboard`, `xclip`, or `xsel`
- Check script permissions: `chmod +x ~/.config/eww/scripts/clipboard_*.sh`
- Verify the history file is being created: `ls -la ~/.config/eww/clipboard_history.b64`

### Entries appear as `[object Object]` or empty
- Install `jq` for proper JSON encoding: `sudo pacman -S jq` (Arch) or `sudo apt install jq` (Debian/Ubuntu)
- Alternatively, ensure `python3` is installed

### Widget position is wrong
- Adjust the `:geometry` values in `eww.yuck` to match your screen layout

## Customization

The widget uses Catppuccin Mocha colors by default. Customize in [eww.scss](clipboard manager widget/eww.scss):

```scss
.clipboard-item {
  background: #313244;  /* Item background */
}

.clipboard-item:hover {
  background: #45475a;  /* Hover color */
}

.clipboard-label {
  color: #f5e0dc;      /* Text color */
}
```

## License

This project is open source and available under the MIT License.

## Credits

- Built with [Eww](https://github.com/elkowar/eww) by elkowar
- Inspired by the Catppuccin color scheme

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests at:
https://github.com/84Ebi/eww/tree/clipboard-manager

---

**Full source code**: [https://github.com/84Ebi/eww/tree/clipboard-manager](https://github.com/84Ebi/eww/tree/clipboard-manager)

