#!/usr/bin/env bash
# Usage: reddit-log.sh <client> <action> <subreddit> <post_url> "<summary>"
# Actions: reply, post, upvote, search, login_check

set -euo pipefail

CLIENT="${1:?Usage: reddit-log.sh <client> <action> <subreddit> <post_url> <summary>}"
ACTION="${2:?}"
SUBREDDIT="${3:-}"
POST_URL="${4:-}"
SUMMARY="${5:-}"

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
DATA_DIR="${SKILL_DIR}/data/${CLIENT}"
LOG_FILE="${DATA_DIR}/activity.log"

mkdir -p "$DATA_DIR"

# TSV format: timestamp, action, subreddit, url, summary
printf '%s\t%s\t%s\t%s\t%s\n' \
  "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  "$ACTION" \
  "$SUBREDDIT" \
  "$POST_URL" \
  "$SUMMARY" \
  >> "$LOG_FILE"

echo "✅ Logged: ${ACTION} in r/${SUBREDDIT}"
