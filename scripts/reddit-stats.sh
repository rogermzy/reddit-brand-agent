#!/usr/bin/env bash
# Usage: reddit-stats.sh <client> [days=7]
# Shows activity summary for a client

set -euo pipefail

CLIENT="${1:?Usage: reddit-stats.sh <client> [days]}"
DAYS="${2:-7}"

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_FILE="${SKILL_DIR}/data/${CLIENT}/activity.log"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "No activity logged for client: $CLIENT"
  exit 0
fi

CUTOFF=$(date -u -v-${DAYS}d +%Y-%m-%dT%H:%M:%SZ 2>/dev/null || date -u -d "${DAYS} days ago" +%Y-%m-%dT%H:%M:%SZ)

echo "=== Reddit Activity: ${CLIENT} (last ${DAYS} days) ==="
echo ""

TOTAL=$(awk -F'\t' -v cutoff="$CUTOFF" '$1 >= cutoff' "$LOG_FILE" | wc -l | tr -d ' ')
echo "Total actions: $TOTAL"
echo ""

echo "By action:"
awk -F'\t' -v cutoff="$CUTOFF" '$1 >= cutoff {print $2}' "$LOG_FILE" | sort | uniq -c | sort -rn
echo ""

echo "By subreddit:"
awk -F'\t' -v cutoff="$CUTOFF" '$1 >= cutoff && $3 != "" {print $3}' "$LOG_FILE" | sort | uniq -c | sort -rn
echo ""

echo "Recent activity:"
tail -10 "$LOG_FILE" | awk -F'\t' '{printf "%s | %-8s | r/%-20s | %s\n", $1, $2, $3, $5}'
