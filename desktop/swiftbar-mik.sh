#!/usr/bin/env bash
# <xbar.title>מיק quick add</xbar.title>
# <xbar.desc>Add a task to מיק from the menu bar</xbar.desc>
# Install: symlink into your SwiftBar plugin dir as mik.1h.sh (see desktop/README / install.sh).
source "$HOME/.mik/config" 2>/dev/null
if [ "${1:-}" = "add" ]; then
  # אוסף את כל המשימות מיידית (בלי רשת בין החלונות → פתיחה חלקה),
  # ורק ב"שלח" שולח את כולן ל-webhook. כל הזנה = משימה נפרדת.
  TASKS=()
  while true; do
    n=${#TASKS[@]}
    if [ "$n" -eq 0 ]; then
      PROMPT="משימה חדשה  (קטגוריה - משימה):"
    else
      PROMPT="$n בהמתנה — הקלד עוד ('הוסף'), או 'שלח' לשליחה:"
    fi
    RES=$(osascript \
      -e "set r to display dialog \"$PROMPT\" default answer \"\" with title \"מיק ⚡\" buttons {\"שלח\",\"הוסף\"} default button \"הוסף\"" \
      -e "return (button returned of r) & tab & (text returned of r)" 2>/dev/null) || break   # Esc → סיום ושליחה
    BTN="${RES%%$'\t'*}"
    TXT="${RES#*$'\t'}"
    [ -n "${TXT// /}" ] && TASKS+=("$TXT")
    [ "$BTN" = "שלח" ] && break
  done
  cnt=${#TASKS[@]}
  if [ "$cnt" -gt 0 ]; then
    osascript -e "display notification \"שולח $cnt…\" with title \"מיק ⚡\"" >/dev/null 2>&1
    ok=0
    for t in "${TASKS[@]}"; do
      "$HOME/.mik/mik" "$t" 2>&1 | grep -q '"ok":true' && ok=$((ok + 1))
    done
    if [ "$ok" -eq "$cnt" ]; then
      MSG="$cnt משימות נוספו"; [ "$cnt" -eq 1 ] && MSG="משימה אחת נוספה"
    else
      MSG="$ok מתוך $cnt נוספו"
    fi
    osascript -e "display notification \"$MSG\" with title \"מיק — נוסף ✓\"" >/dev/null 2>&1
  fi
  exit 0
fi
echo "⚡"
echo "---"
echo "＋ הוסף משימות | bash='$HOME/.mik/swiftbar-mik.sh' param1=add terminal=false refresh=false"
echo "פתח את מיק | href=${MIK_APP_URL:-https://script.google.com}"
