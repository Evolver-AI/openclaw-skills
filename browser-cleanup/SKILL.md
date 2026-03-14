---
name: browser-cleanup
description: Detect and kill orphaned browser processes (Chrome/Chromium/Brave) left behind by OpenClaw browser automation. Use when the user reports high memory usage, orphaned Chrome processes, or wants to set up automatic browser cleanup. Also useful as a periodic maintenance check.
---

# Browser Cleanup

OpenClaw's browser automation spawns Chromium-based processes (via Puppeteer) for tasks like web scraping, screenshots, and page interaction. These processes can accumulate if sessions don't close cleanly — eating RAM silently.

This skill detects orphaned browser processes and cleans them up, either on-demand or automatically via cron.

## On-Demand Cleanup

Run the cleanup script to kill orphaned browser processes:

```bash
bash <skill_dir>/scripts/cleanup.sh
```

The script:
1. Counts running "Chrome for Testing" / Puppeteer processes
2. Checks if the OpenClaw browser is actively in use (`openclaw browser status`)
3. If browser is idle, kills all orphaned processes and reports freed count
4. If browser is active, skips cleanup and reports status

## Automatic Cleanup (Cron)

To set up hourly automatic cleanup, add a cron entry to `~/.openclaw/openclaw.json`:

```json
{
  "cron": [
    {
      "schedule": "0 * * * *",
      "command": "bash <skill_dir>/scripts/cleanup.sh",
      "label": "browser-cleanup"
    }
  ]
}
```

Then restart the gateway: `openclaw gateway restart`

## Heartbeat Integration

For users with heartbeat enabled, add this check to `HEARTBEAT.md`:

```markdown
## Browser cleanup check
- Run `pgrep -f "Google Chrome for Testing" | wc -l`
- If >10 and no browser task is active: `bash <skill_dir>/scripts/cleanup.sh`
```

## What Gets Cleaned

- `Google Chrome for Testing` — Puppeteer-managed Chromium instances
- `chrome_crashpad_handler` — associated crash handler processes
- Only targets automation browsers, never the user's personal Chrome/Brave/Edge

## Platform Support

- **macOS**: Full support (pgrep/pkill)
- **Linux**: Full support (pgrep/pkill)
- **Windows/WSL**: Linux layer supported; native Windows not yet covered
