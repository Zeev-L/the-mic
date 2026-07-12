#!/usr/bin/env python3
# מרנדר את משימות "היום + באיחור" כפריטי תפריט של SwiftBar.
# קורא JSON מ-stdin (מה-endpoint ?json=agenda). ארגומנטים: <plugin_path> <lang>
import sys, json, base64

plugin = sys.argv[1] if len(sys.argv) > 1 else ''
lang = sys.argv[2] if len(sys.argv) > 2 else 'he'

RLE = '‫'  # RIGHT-TO-LEFT EMBEDDING
PDF = '‬'  # POP DIRECTIONAL FORMATTING

def L(he, en):
    return en if lang == 'en' else he

def rtl(s):
    # עוטף שורת עברית ב-bidi ימין-לשמאל כדי שהשורות יֵראו אחידות (הדוט מימין, טקסט מיושר)
    return (RLE + s + PDF) if lang == 'he' else s

def esc(s):
    return str(s).replace('|', '¦').replace('\n', ' ').strip()

def act(label, tid, action, arg):
    b64 = base64.b64encode(tid.encode('utf-8')).decode('ascii')
    return ('--%s | bash="%s" param1=action param2=%s param3=%s param4=%s terminal=false refresh=true'
            % (rtl(label), plugin, action, b64, arg))

raw = sys.stdin.read()
try:
    d = json.loads(raw)
    tasks = d.get('tasks', []) if d.get('ok') else None
except Exception:
    tasks = None

if tasks is None:
    print("⚡")
    print("---")
    print(rtl(L("שגיאת חיבור למיק", "Mik connection error")) + " | color=#c0392b")
    sys.exit(0)

print("⚡" + (" %d" % len(tasks) if tasks else ""))
print("---")
print(rtl(L("משימות היום", "Today")) + " | size=11 color=#8a8a8a")
if not tasks:
    print(rtl(L("הכול נקי להיום 🎉", "All clear today 🎉")) + " | color=#8a8a8a")
    sys.exit(0)

DOT = {'OPEN': '🔵', 'IN PROGRESS': '🟡', 'DEPENDENT': '⚪'}
for t in tasks:
    tid = t.get('id', '')
    over = bool(t.get('overdue'))
    dot = '🔴' if over else DOT.get(t.get('status'), '🔵')
    cat = (esc(t.get('category')) + ' · ') if t.get('category') else ''
    tail = ('  ' + L('(באיחור)', '(overdue)')) if over else ''
    line = "%s %s%s%s" % (dot, cat, esc(t.get('task')), tail)
    print(rtl(line))
    print(act(L("✓ סמן כבוצע", "✓ Mark done"), tid, "setstatus", "done"))
    print(act(L("⏳ שנה לבתהליך", "⏳ In progress"), tid, "setstatus", "prog"))
    print(act(L("⏸ שנה לתלוי", "⏸ Blocked"), tid, "setstatus", "dep"))
    print(act(L("📅 דחה למחר", "📅 Snooze to tomorrow"), tid, "setdue", "+1"))
    print(act(L("📅 דחה לשבוע הבא", "📅 Snooze +1 week"), tid, "setdue", "+7"))
    print(act(L("🧹 הסר תאריך", "🧹 Clear date"), tid, "setdue", "clear"))
