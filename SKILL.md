---
name: reddit-brand-agent
description: >
  Manage a brand's Reddit account via browser automation. Search subreddits for relevant discussions,
  generate brand-voice replies, and post using the brand's own Reddit account through a real browser session.
  Use when: (1) monitoring Reddit for brand-relevant conversations, (2) replying to Reddit posts/comments
  in brand voice, (3) building Reddit presence for a client, (4) searching Reddit for keyword mentions.
  Triggers on "reddit", "subreddit", "reddit marketing", "reddit reply", "reddit post", "reddit monitor".
---

# Reddit Brand Agent

Operate a brand's Reddit account via browser automation (OpenClaw `browser` tool). No API keys needed — uses real browser sessions to avoid bot detection.

## Prerequisites

- Brand's Reddit account must be logged in via the browser profile before first use
- Client config in `references/clients/` (one YAML per client)

## Onboarding (New Client Setup)

When adding a new client, run the onboarding flow instead of manually configuring:

### Step 1: Scrape Brand Website
```
web_fetch → brand URL → extract: product name, value prop, target audience, tone, use cases
```

### Step 2: Analyze & Recommend
Based on website content, AI generates:
- **Product summary** (1-2 sentences)
- **Target audience segments** (who uses this product)
- **Recommended subreddits** (where target audience hangs out)
- **Keyword list** (what target audience searches for on Reddit)
- **Brand voice profile** (tone, persona, dos/don'ts)
- **Competitor mentions to monitor** (competing products discussed on Reddit)

### Step 3: Search Reddit to Validate
```
web_search → site:reddit.com "{product category}" → verify subreddits are active
web_search → site:reddit.com "{competitor names}" → find where competitors get discussed
```

Validate each recommended subreddit:
- Has recent activity (posts in last 7 days)
- Allows text posts / product discussion
- Not explicitly anti-promotion
- Has 10k+ members (worth the effort)

### Step 4: Generate Client Config
Write validated config to `references/clients/{client}.yaml`
Present to user for review before finalizing.

Helper script: `scripts/reddit-onboard.sh <client_name> <website_url>` (creates stub)

---

## Core Workflow

### 1. Login Check

```
browser → navigate to reddit.com → snapshot → verify logged-in state
```

If not logged in, prompt user to manually log in (never store passwords in config).

### 2. Search for Relevant Posts

```
browser → navigate to reddit.com/search?q={keywords}&type=comment&t=week
  OR → navigate to reddit.com/r/{subreddit}/search?q={keywords}&restrict_sr=on&t=week
→ snapshot → extract post titles, URLs, scores, ages
→ AI filters for relevance + engagement opportunity
```

**Search strategies (pick based on goal):**
- **Keyword search**: `/search?q={keyword}&sort=new&t=week` — find fresh mentions
- **Subreddit browse**: `/r/{subreddit}/new/` — monitor target communities
- **Comment search**: `/search?q={keyword}&type=comment&t=day` — find conversations to join

### 3. Evaluate Posts

For each candidate post, score on:
- **Relevance** (0-10): How related to brand's domain?
- **Engagement opportunity** (0-10): Can we add genuine value?
- **Risk** (low/med/high): Self-promo risk, mod strictness, community culture
- **Freshness**: Prefer posts < 24h old (still getting traffic)

Skip posts where:
- Brand mention would be forced/unnatural
- Subreddit explicitly bans promotional content
- Post already has 100+ comments (buried)
- Post is < 1 hour old (wait for organic discussion)

### 4. Generate Reply

For detailed comment writing tactics, see `references/reddit-playbook.md`.

**5-Part Comment Formula:**
1. **Empathy Hook** — Mirror OP's pain ("I had the same issue...")
2. **Mini Story** — Believable personal anecdote
3. **Subtle Recommendation** — Soft brand mention, NO links
4. **Social Proof/Comparison** — Fair competitor comparison
5. **Exit Line** — Casual close ("not sponsored or anything lol")

**Style rules (critical for survival):**
- Lowercase for realism, add line breaks
- Drop a small typo once per paragraph (imperfection = trust)
- Never bold/italicize — looks like marketing
- 1-2 sentences for fast threads, 3-5 for product discussions, 6-10 for high-value ranking threads
- Match subreddit tone (casual in r/ChatGPT, academic in r/MachineLearning)

**Brand mention is OPTIONAL** — most replies should be pure value with zero brand mention.

### 5. Post Reply via Browser

```
browser → navigate to post URL
→ snapshot → find reply input
→ act: click reply box → type reply text → click submit
→ snapshot → verify reply posted
```

### 6. Log Activity

After each action, append to the activity log:
```
scripts/reddit-log.sh <client> <action> <subreddit> <post_url> "<reply_summary>"
```

## Google Thread Hijacking (SEO Play)

The highest-ROI Reddit tactic: find threads already ranking on Google and comment in them.

1. Search Google: `best [product category] site:reddit.com`
2. Identify threads ranking top 5 with ≥20 comments
3. Drop a natural comment using the 5-part formula
4. That comment now gets organic Google traffic for 12-36 months
5. Google AI Overviews also pull Reddit mentions into snippets

**Prioritize threads by keyword tier:**
- Tier 1 (High buyer intent): "best X", "top X" → comment early, prioritize
- Tier 2 (Medium): Brand comparisons, reviews → participate lightly
- Tier 3 (Awareness): Opinions, experiences → brand mention only, no links

## Account Warm-Up SOP

New accounts MUST be warmed before any brand activity:
- **Week 1:** Lurk only. Join subreddits, upvote. No comments.
- **Week 2:** 3-5 casual comments/day. Mix tones. No links/brand.
- **Week 3:** Post one harmless thread. Build karma.
- **Week 4:** Start soft mentions ("tried [Brand], not bad")
- **Week 5+:** Fully active

## Shadowban Detection

After each comment, verify it's visible:
```
browser → log out or incognito → navigate to comment URL → check if visible
```
If 404 or missing → account is shadowbanned. Stop using it immediately.

## Rate Limits & Safety

| Rule | Limit |
|------|-------|
| Replies per day | ≤ 5 (Phase 1), ≤ 10 (Phase 2) |
| Replies per subreddit per day | ≤ 2 |
| Min gap between replies | 30+ minutes |
| Self-promo ratio | < 10% of all activity |
| Consecutive days without non-promo activity | 0 (always mix in genuine engagement) |

## Approval Modes

- **`require_approval: true`** (default Phase 1): Show draft reply to user, wait for approval before posting
- **`require_approval: false`** (Phase 2+): Auto-post, log for review

## Client Configuration

Store per-client configs in `references/clients/{client}.yaml`:

```yaml
client: writeninja
reddit_username: (logged in via browser)
target_subreddits:
  - ChatGPT
  - ArtificialIntelligence
  - writing
  - college
  - freelanceWriters
  - professors
keywords:
  - AI detection
  - humanize AI text
  - AI writing tool
  - chatgpt detection
  - turnitin AI
  - AI content detector
brand_voice: |
  Helpful power user who writes a lot. Casually experienced with AI writing tools.
  Never salesy. Share tips and workarounds first. Mention WriteNinja only when
  directly asked for tool recommendations or when sharing personal workflow.
daily_limit: 5
require_approval: true
```

## Scripts

### `scripts/reddit-log.sh`
Append activity to `data/{client}/activity.log` (TSV: timestamp, action, subreddit, url, summary).

### `scripts/reddit-stats.sh`
Print activity summary for a client (total replies, by subreddit, last 7 days).

## File Structure

```
reddit-brand-agent/
├── SKILL.md
├── scripts/
│   ├── reddit-log.sh
│   └── reddit-stats.sh
├── references/
│   └── clients/
│       └── writeninja.yaml
└── data/
    └── {client}/
        └── activity.log
```
