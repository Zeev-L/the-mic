#!/usr/bin/env bash
# <xbar.title>מיק quick add</xbar.title>
# <xbar.desc>Add a task to מיק from the menu bar</xbar.desc>
# Install: symlink into your SwiftBar plugin dir as mik.1h.sh (see desktop/README / install.sh).
source "$HOME/.mik/config" 2>/dev/null
MIK_LANG="${MIK_LANG:-he}"                       # שפת הבר: he (ברירת מחדל) / en — תואם לשפת האפליקציה
L(){ if [ "$MIK_LANG" = "en" ]; then printf '%s' "$2"; else printf '%s' "$1"; fi; }
TITLE=$(L "מיק ⚡" "Mik ⚡")

if [ "${1:-}" = "add" ]; then
  # אוסף את כל המשימות מיידית (בלי רשת בין החלונות → פתיחה חלקה),
  # ורק ב"שלח" שולח את כולן ל-webhook. כל הזנה = משימה נפרדת.
  BTN_SEND=$(L "שלח" "Send"); BTN_ADD=$(L "הוסף" "Add")
  TASKS=()
  while true; do
    n=${#TASKS[@]}
    if [ "$n" -eq 0 ]; then
      PROMPT=$(L "משימה חדשה  (קטגוריה - משימה):" "New task  (Category - Task):")
    else
      PROMPT=$(L "$n בהמתנה — הקלד עוד, או 'שלח' לשליחה:" "$n pending — type another, or 'Send':")
    fi
    RES=$(osascript \
      -e "set r to display dialog \"$PROMPT\" default answer \"\" with title \"$TITLE\" buttons {\"$BTN_SEND\",\"$BTN_ADD\"} default button \"$BTN_ADD\"" \
      -e "return (button returned of r) & tab & (text returned of r)" 2>/dev/null) || break   # Esc → סיום ושליחה
    BTN="${RES%%$'\t'*}"
    TXT="${RES#*$'\t'}"
    [ -n "${TXT// /}" ] && TASKS+=("$TXT")
    [ "$BTN" = "$BTN_SEND" ] && break
  done
  cnt=${#TASKS[@]}
  if [ "$cnt" -gt 0 ]; then
    osascript -e "display notification \"$(L "שולח $cnt…" "Sending $cnt…")\" with title \"$TITLE\"" >/dev/null 2>&1
    ok=0
    for t in "${TASKS[@]}"; do
      "$HOME/.mik/mik" "$t" 2>&1 | grep -q '"ok":true' && ok=$((ok + 1))
    done
    if [ "$ok" -eq "$cnt" ]; then
      if [ "$cnt" -eq 1 ]; then MSG=$(L "משימה אחת נוספה" "1 task added"); else MSG=$(L "$cnt משימות נוספו" "$cnt tasks added"); fi
    else
      MSG=$(L "$ok מתוך $cnt נוספו" "$ok of $cnt added")
    fi
    osascript -e "display notification \"$MSG\" with title \"$(L "מיק — נוסף ✓" "Mik — added ✓")\"" >/dev/null 2>&1
  fi
  exit 0
fi
echo "⚡"
echo "---"
echo "$(L "＋ הוסף משימות" "＋ Add tasks") | bash='$HOME/.mik/swiftbar-mik.sh' param1=add terminal=false refresh=false"
echo "$(L "פתח את מיק" "Open Mik") | href=${MIK_APP_URL:-https://script.google.com}"
