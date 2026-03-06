#!/usr/bin/env bash
# Usage: reddit-onboard.sh <client_name> <website_url>
# Generates a client config stub and triggers AI analysis

set -euo pipefail

CLIENT="${1:?Usage: reddit-onboard.sh <client_name> <website_url>}"
URL="${2:?}"

SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="${SKILL_DIR}/references/clients"
CONFIG_FILE="${CONFIG_DIR}/${CLIENT}.yaml"

mkdir -p "$CONFIG_DIR"

if [[ -f "$CONFIG_FILE" ]]; then
  echo "⚠️  Config already exists: $CONFIG_FILE"
  echo "Delete it first if you want to regenerate."
  exit 1
fi

cat > "$CONFIG_FILE" << EOF
# Auto-generated stub for: ${CLIENT}
# Website: ${URL}
# Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)
#
# TODO: Fill in after AI analysis of website content
client: ${CLIENT}
product_url: ${URL}
product_description: # AI will fill this
reddit_username: # configure after browser login
target_subreddits: []  # AI will recommend
keywords: []  # AI will recommend
brand_voice: |
  # AI will generate based on website tone
daily_limit: 5
require_approval: true
min_gap_minutes: 30
max_per_subreddit_per_day: 2
EOF

echo "✅ Stub created: $CONFIG_FILE"
echo "Next: AI agent will analyze ${URL} and fill in recommendations."
