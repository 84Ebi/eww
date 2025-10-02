# Simple Day Countdown Widget for Eww

A minimalist, lightweight countdown widget built with [Eww (ElKowars wacky widgets)](https://github.com/elkowar/eww) that displays the days remaining until your important dates with a clean, modern dark theme.

![License](https://img.shields.io/badge/license-MIT-blue.svg)

## Features

- ⏰ **Simple Day Counter** - Shows exactly how many days left until target date
- 🎯 **Multiple Countdowns** - Track multiple events simultaneously
- 🎨 **Dark Modern UI** - Catppuccin-inspired color scheme with rounded corners
- 📅 **Easy Configuration** - One-line date format (YYYY-MM-DD)
- 🔄 **Auto-refresh** - Updates every 60 seconds
- ⚡ **Lightweight** - Minimal resource usage
- 💾 **Persistent Display** - Stays visible as a dock window

## Screenshots

The widget displays:
- Event title (e.g., "SSL renew", "cPanel renew")
- Days remaining in a clean, readable format
- Automatically shows "Expired" when the date passes

## Prerequisites

- [Eww](https://github.com/elkowar/eww) (ElKowars wacky widgets)
- `bash` (usually pre-installed)
- `date` command (GNU coreutils)

## Installation

1. Clone this repository:
```bash
git clone https://github.com/84Ebi/eww.git
cd eww
git checkout simpledaycountdown
```

2. Copy the script to your Eww scripts directory:
```bash
mkdir -p ~/.config/eww/scripts
cp simplecountdown/scripts/day_countdown.sh ~/.config/eww/scripts/
chmod +x ~/.config/eww/scripts/day_countdown.sh
```

3. Add the widget configuration to your `~/.config/eww/eww.yuck`:
```yuck
;; Day Countdown Variable
(defpoll DAY_COUNTDOWN :interval "60s" 
  `bash ~/.config/eww/scripts/day_countdown.sh 2025-11-17`)

;; Countdown Widget
(defwidget countdown []
  (box :class "countdown-box" 
       :orientation "vertical" 
       :space-evenly false 
       :vexpand "false" 
       :hexpand "false"
    (label :class "countdown-title" 
           :text "SSL renew" 
           :halign "center")
    (label :class "countdown-label" 
           :halign "center" 
           :wrap "true" 
           :limit-width 200 
           :text DAY_COUNTDOWN)))

;; Countdown Window
(defwindow countdown
  :monitor 0
  :geometry (geometry :x "100px" :y "120px" :width "200px" :height "80px")
  :stacking "bg"
  :reserve (struts :distance "80px" :side "top")
  :windowtype "dock"
  :wm-ignore false
  (countdown))
```

4. Add the styles from `simplecountdown/eww.scss` to your Eww SCSS file:
```scss
* {
  all: unset;
}

.countdown-box {
  background-color: #1e1e2e;
  color: #cdd6f4;
  padding: 1rem;
  border-radius: 16px;
}

.countdown-title {
  font-family: "Fira Code", monospace;
  font-size: 0.9rem;
  font-weight: bold;
  color: #424d5e;
  margin-bottom: 5px;
}

.countdown-label {
  font-family: "Fira Code", monospace;
  font-size: 1.2rem;
  font-weight: bold;
  color: #a6e3a1;
}
```

## Usage

### Starting the Widget

```bash
eww daemon
eww open countdown
```

### Setting Your Target Date

Edit the `defpoll` line in your `eww.yuck`:

```yuck
;; Change the date (YYYY-MM-DD format)
(defpoll DAY_COUNTDOWN :interval "60s" 
  `bash ~/.config/eww/scripts/day_countdown.sh 2025-12-31`)
```

### Changing the Title

Modify the title text in the widget definition:

```yuck
(label :class "countdown-title" 
       :text "Your Event Name"  ;; Change this
       :halign "center")
```

### Creating Multiple Countdowns

You can track multiple events by creating additional countdown widgets:

```yuck
;; Second countdown
(defpoll DAY_COUNTDOWN1 :interval "60s" 
  `bash ~/.config/eww/scripts/day_countdown.sh 2026-07-30`)

(defwidget countdown1 []
  (box :class "countdown-box" :orientation "vertical" :space-evenly false
    (label :class "countdown-title" :text "cPanel renew" :halign "center")
    (label :class "countdown-label" :halign "center" :text DAY_COUNTDOWN1)))

(defwindow countdown1
  :monitor 0
  :geometry (geometry :x "100px" :y "220px" :width "200px" :height "80px")
  :stacking "bg"
  :windowtype "dock"
  :wm-ignore false
  (countdown1))
```

Then open both widgets:
```bash
eww open countdown
eww open countdown1
```

## Configuration

### Update Interval

Change how often the countdown updates:

```yuck
(defpoll DAY_COUNTDOWN :interval "60s" ...)  ;; Every 60 seconds
;; or
(defpoll DAY_COUNTDOWN :interval "3600s" ...) ;; Every hour (saves resources)
```

### Widget Position and Size

Adjust the geometry in your window definition:

```yuck
:geometry (geometry :x "100px"   ;; X position from left
                    :y "120px"   ;; Y position from top
                    :width "200px" 
                    :height "80px")
```

### Colors and Styling

Customize in `eww.scss`:

```scss
.countdown-box {
  background-color: #1e1e2e;  /* Box background */
  border-radius: 16px;         /* Corner roundness */
}

.countdown-title {
  color: #424d5e;              /* Title color */
  font-size: 0.9rem;           /* Title size */
}

.countdown-label {
  color: #a6e3a1;              /* Countdown number color (green) */
  font-size: 1.2rem;           /* Number size */
}
```

## File Structure

```
simplecountdown/
├── eww.scss              # Widget styles (dark theme)
├── eww.yuck              # Widget configuration
└── scripts/
    └── day_countdown.sh  # Countdown calculation script
```

## How It Works

1. **day_countdown.sh** takes a target date as argument
2. Calculates the difference between today and the target date
3. Converts seconds to days
4. Returns "X days left" or "Expired" if date has passed
5. Eww polls the script every 60 seconds and updates the display

## Script Details

The `day_countdown.sh` script is simple and efficient:

```bash
#!/bin/bash
# Usage: day_countdown.sh YYYY-MM-DD

target="$1"
today=$(date +%s)
end=$(date -d "$target" +%s)
diff=$(( (end - today) / 86400 ))

if [ $diff -ge 0 ]; then
    echo "$diff days left"
else
    echo "Expired"
fi
```

## Real-World Examples

Based on the example configuration:

### SSL Certificate Renewal
```yuck
(defpoll DAY_COUNTDOWN :interval "60s" 
  `bash ~/.config/eww/scripts/day_countdown.sh 2025-11-17`)
```

### cPanel License Renewal
```yuck
(defpoll DAY_COUNTDOWN1 :interval "60s" 
  `bash ~/.config/eww/scripts/day_countdown.sh 2026-07-30`)
```

### Other Use Cases
- Project deadlines
- Domain renewals
- Subscription expirations
- Birthday reminders
- Vacation countdowns
- Exam dates

## Troubleshooting

### Widget not showing
- Ensure Eww daemon is running: `eww daemon`
- Check if window is open: `eww windows`
- Verify script permissions: `chmod +x ~/.config/eww/scripts/day_countdown.sh`

### Wrong countdown value
- Verify date format is YYYY-MM-DD: `2025-12-31`
- Check system date is correct: `date`
- Test script manually: `bash ~/.config/eww/scripts/day_countdown.sh 2025-12-31`

### Font not displaying correctly
- Install the font: `sudo pacman -S ttf-fira-code` (Arch) or equivalent
- Change font in `eww.scss`:
  ```scss
  font-family: "JetBrains Mono", "monospace";
  ```

### Widget position wrong
- Adjust `:geometry` values in `eww.yuck`
- Try different `:stacking` values: `"fg"`, `"bg"`, `"overlay"`

## Tips & Tricks

### Auto-start on Login

Add to your window manager config or `.xinitrc`:
```bash
eww daemon &
eww open countdown &
eww open countdown1 &
```

### Quick Toggle Script

Create `~/.local/bin/toggle-countdown.sh`:
```bash
#!/bin/bash
if eww windows | grep -q "countdown"; then
  eww close countdown
else
  eww open countdown
fi
```

### Color Schemes

**Catppuccin Mocha (default)**:
- Background: `#1e1e2e`
- Title: `#424d5e`
- Number: `#a6e3a1` (green)

**Custom Blue Theme**:
```scss
.countdown-label {
  color: #89b4fa;  /* Blue */
}
```

**Red Alert Theme** (for urgent deadlines):
```scss
.countdown-label {
  color: #f38ba8;  /* Red */
}
```

## Integration with Other Widgets

This widget works alongside other Eww widgets. You can integrate it with:
- Clock widget
- Clipboard manager widget
- System monitors
- Weather widgets

## License

This project is open source and available under the MIT License.

## Credits

- Built with [Eww](https://github.com/elkowar/eww) by elkowar
- Inspired by Catppuccin color scheme
- Font: Fira Code / JetBrains Mono

## Contributing

Contributions are welcome! Feel free to open issues or submit pull requests at:
https://github.com/84Ebi/eww/tree/simpledaycountdown

---

**Full source code**: [https://github.com/84Ebi/eww/tree/simpledaycountdown](https://github.com/84Ebi/eww/tree/simpledaycountdown)

**Happy counting down! ⏰**