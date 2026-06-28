#!/usr/bin/env bash
# <xbar.title>מיק quick add</xbar.title>
# <xbar.desc>Add a task to מיק from the menu bar</xbar.desc>
# Install: symlink into your SwiftBar plugin dir as mik.1h.sh (see desktop/README / install.sh).
source "$HOME/.mik/config" 2>/dev/null
if [ "${1:-}" = "add" ]; then
  TASK=$(osascript -e 'text returned of (display dialog "משימה חדשה  (קטגוריה - משימה):" default answer "" with title "מיק ⚡" buttons {"ביטול","הוסף"} default button "הוסף")' 2>/dev/null) || exit 0
  [ -z "${TASK// /}" ] && exit 0
  RESP=$("$HOME/.mik/mik" "$TASK" 2>&1)
  if echo "$RESP" | grep -q '"ok":true'; then
    osascript -e "display notification \"$TASK\" with title \"מיק — נוספה ✓\"" >/dev/null 2>&1
  else
    osascript -e "display notification \"$RESP\" with title \"מיק — שגיאה ✗\"" >/dev/null 2>&1
  fi
  exit 0
fi
echo "⚡"
echo "---"
echo "＋ הוסף משימה | bash='$HOME/.mik/swiftbar-mik.sh' param1=add terminal=false refresh=false"
echo "פתח את מיק | href=${MIK_APP_URL:-https://script.google.com}"
