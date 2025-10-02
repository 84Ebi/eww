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
