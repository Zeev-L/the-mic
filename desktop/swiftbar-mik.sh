#!/usr/bin/env bash
# <xbar.title>מיק quick add</xbar.title>
# <xbar.desc>Add a task to מיק from the menu bar</xbar.desc>
# Install: symlink into your SwiftBar plugin dir as mik.1h.sh (see desktop/README / install.sh).
source "$HOME/.mik/config" 2>/dev/null
if [ "${1:-}" = "add" ]; then
  # לולאה: אחרי כל "הוסף" החלון נפתח מיד למשימה הבאה, עד "סיום"/Esc או שדה ריק.
  ADDED=0
  while true; do
    if [ "$ADDED" -eq 0 ]; then
      PROMPT="משימה חדשה  (קטגוריה - משימה):"
    else
      PROMPT="נוספו $ADDED ✓ — הקלד משימה נוספת, או 'סיום' לסיום:"
    fi
    TASK=$(osascript -e "text returned of (display dialog \"$PROMPT\" default answer \"\" with title \"מיק ⚡\" buttons {\"סיום\",\"הוסף\"} default button \"הוסף\" cancel button \"סיום\")" 2>/dev/null) || break
    [ -z "${TASK// /}" ] && break
    RESP=$("$HOME/.mik/mik" "$TASK" 2>&1)
    if echo "$RESP" | grep -q '"ok":true'; then
      ADDED=$((ADDED + 1))
    else
      osascript -e "display notification \"$RESP\" with title \"מיק — שגיאה ✗\"" >/dev/null 2>&1
    fi
  done
  if [ "$ADDED" -gt 0 ]; then
    MSG="$ADDED משימות נוספו"; [ "$ADDED" -eq 1 ] && MSG="משימה אחת נוספה"
    osascript -e "display notification \"$MSG\" with title \"מיק — נוסף ✓\"" >/dev/null 2>&1
  fi
  exit 0
fi
echo "⚡"
echo "---"
echo "＋ הוסף משימות | bash='$HOME/.mik/swiftbar-mik.sh' param1=add terminal=false refresh=false"
echo "פתח את מיק | href=${MIK_APP_URL:-https://script.google.com}"
