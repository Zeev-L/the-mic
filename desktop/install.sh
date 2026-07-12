#!/usr/bin/env bash
# Installs מיק desktop quick-capture: CLI (mik) + optional SwiftBar menu-bar item.
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
MIKDIR="$HOME/.mik"
mkdir -p "$MIKDIR"
cp "$HERE/mik" "$MIKDIR/mik"; chmod +x "$MIKDIR/mik"
cp "$HERE/swiftbar-mik.sh" "$MIKDIR/swiftbar-mik.sh"; chmod +x "$MIKDIR/swiftbar-mik.sh"
cp "$HERE/mik-agenda.py" "$MIKDIR/mik-agenda.py"   # renders today's tasks in the SwiftBar menu
if [ ! -f "$MIKDIR/config" ]; then
  cp "$HERE/config.example" "$MIKDIR/config"; chmod 600 "$MIKDIR/config"
  echo "→ created ~/.mik/config — EDIT IT and paste your webhook URL."
fi
# shell alias (zsh)
RC="$HOME/.zshrc"
grep -q 'alias mik=' "$RC" 2>/dev/null || echo 'alias mik="$HOME/.mik/mik"' >> "$RC"
# SwiftBar plugin (optional)
PLUGDIR="$(defaults read com.ameba.SwiftBar PluginDirectory 2>/dev/null || true)"
if [ -n "${PLUGDIR:-}" ] && [ -d "$PLUGDIR" ]; then
  rm -f "$PLUGDIR/mik.1h.sh"   # remove older interval if present
  ln -sf "$MIKDIR/swiftbar-mik.sh" "$PLUGDIR/mik.15m.sh"
  echo "→ SwiftBar plugin linked (refreshes every 15m). Restart SwiftBar so it scans the new plugin (quit + reopen)."
else
  echo "→ SwiftBar not detected. The 'mik' CLI works regardless; for a menu-bar/hotkey trigger use SwiftBar, Raycast, or Alfred to run: mik \"...\""
fi
echo "Done. Edit ~/.mik/config (paste your Anyone webhook URL), open a new terminal, then:  mik \"category - task\""
