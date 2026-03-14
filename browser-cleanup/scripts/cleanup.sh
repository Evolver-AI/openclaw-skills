#!/usr/bin/env bash
# browser-cleanup: kill orphaned Puppeteer/Chrome for Testing processes
# Safe to run manually or via cron — skips if browser is actively in use

set -euo pipefail

PROCESS_PATTERN="Google Chrome for Testing"
CRASHPAD_PATTERN="chrome_crashpad_handler"

count_procs() {
  pgrep -f "$PROCESS_PATTERN" 2>/dev/null | wc -l | tr -d ' '
}

COUNT=$(count_procs)

if [ "$COUNT" -eq 0 ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): No orphaned browser processes found"
  exit 0
fi

# Check if OpenClaw browser is actively being used
BROWSER_ACTIVE=false
if command -v openclaw &>/dev/null; then
  STATUS=$(openclaw browser --browser-profile openclaw status 2>&1 || true)
  if echo "$STATUS" | grep -qiE "running|connected|active|pages:.[1-9]"; then
    BROWSER_ACTIVE=true
  fi
fi

if [ "$BROWSER_ACTIVE" = true ]; then
  echo "$(date '+%Y-%m-%d %H:%M:%S'): Browser actively in use, skipping cleanup ($COUNT processes)"
  exit 0
fi

# Kill orphaned processes
pkill -f "$PROCESS_PATTERN" 2>/dev/null || true
pkill -f "$CRASHPAD_PATTERN" 2>/dev/null || true
sleep 1

REMAINING=$(count_procs)
KILLED=$((COUNT - REMAINING))

echo "$(date '+%Y-%m-%d %H:%M:%S'): Killed $KILLED orphaned browser processes (was: $COUNT, remaining: $REMAINING)"
