#!/usr/bin/env bash
# <xbar.title>מיק</xbar.title>
# <xbar.desc>מיק — משימות היום + הוספה מהירה משורת התפריטים</xbar.desc>
# Install: symlink into your SwiftBar plugin dir as mik.15m.sh (see desktop/install.sh).
source "$HOME/.mik/config" 2>/dev/null
MIK_LANG="${MIK_LANG:-he}"                       # שפת הבר: he (ברירת מחדל) / en
L(){ if [ "$MIK_LANG" = "en" ]; then printf '%s' "$2"; else printf '%s' "$1"; fi; }
TITLE=$(L "מיק ⚡" "Mik ⚡")
SELF="$HOME/.mik/swiftbar-mik.sh"

# ---- action: update a task from the "today" submenu (mark status / change due) ----
if [ "${1:-}" = "action" ]; then
  [ -z "${MIK_URL:-}" ] && exit 0
  ACT="$2"
  ID=$(printf '%s' "$3" | base64 -D 2>/dev/null || printf '%s' "$3" | base64 -d 2>/dev/null)
  ARG="$4"; RESP=""
  if [ "$ACT" = "setstatus" ]; then
    case "$ARG" in done) ST="DONE";; prog) ST="IN PROGRESS";; dep) ST="DEPENDENT";; *) ST="OPEN";; esac
    RESP=$(curl -s -L --max-time 20 --data-urlencode "action=setstatus" --data-urlencode "id=$ID" --data-urlencode "status=$ST" "$MIK_URL")
    MSG=$(L "עודכן ✓" "Updated ✓")
  elif [ "$ACT" = "setdue" ]; then
    if [ "$ARG" = "clear" ]; then DUE=""; else N="${ARG#+}"; DUE=$(date -v+"${N}"d +%Y-%m-%d 2>/dev/null); fi
    RESP=$(curl -s -L --max-time 20 --data-urlencode "action=setdue" --data-urlencode "id=$ID" --data-urlencode "due=$DUE" "$MIK_URL")
    MSG=$(L "התאריך עודכן ✓" "Date updated ✓")
  fi
  if echo "$RESP" | grep -q '"ok":true'; then
    osascript -e "display notification \"$MSG\" with title \"$TITLE\"" >/dev/null 2>&1
  else
    osascript -e "display notification \"$(L 'שגיאה' 'Error')\" with title \"$TITLE\"" >/dev/null 2>&1
  fi
  exit 0
fi

# ---- add: multi-add loop (collect instantly, send on "Send") ----
if [ "${1:-}" = "add" ]; then
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
      -e "return (button returned of r) & tab & (text returned of r)" 2>/dev/null) || break
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

# ---- default: render menu — today's tasks (nested submenu) + quick actions ----
JSON=""
[ -n "${MIK_URL:-}" ] && JSON=$(curl -s -L --max-time 12 "${MIK_URL}?json=agenda" 2>/dev/null)
if command -v python3 >/dev/null 2>&1 && [ -n "$JSON" ]; then
  printf '%s' "$JSON" | python3 "$HOME/.mik/mik-agenda.py" "$SELF" "$MIK_LANG"
else
  echo "⚡"
fi
echo "---"
echo "$(L "＋ הוסף משימות" "＋ Add tasks") | bash=\"$SELF\" param1=add terminal=false refresh=false"
echo "$(L "🗓️ פתח את מיק" "🗓️ Open Mik") | href=${MIK_APP_URL:-https://script.google.com}"
echo "$(L "🔄 רענן" "🔄 Refresh") | refresh=true"
