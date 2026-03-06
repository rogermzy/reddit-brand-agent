# Reddit Brand Agent

An [OpenClaw](https://github.com/openclaw/openclaw) skill for managing brand Reddit accounts via browser automation. No API keys needed — operates through real browser sessions to avoid bot detection.

## What It Does

- **Onboard new clients** — Input a website URL, auto-analyze brand voice, recommend subreddits & keywords
- **Monitor Reddit** — Search target subreddits for relevant conversations by keyword
- **Generate replies** — AI creates brand-voice responses that prioritize genuine value over promotion
- **Post via browser** — Submit replies through a real browser session (indistinguishable from manual use)
- **Track activity** — Log all actions, enforce rate limits, maintain safety rules

## How It Works

```
Website URL → Brand Analysis → Subreddit Discovery → Keyword Monitoring
    → Post Evaluation → AI Reply Generation → Human Review → Browser Post
```

All Reddit interactions happen through OpenClaw's `browser` tool — real Chrome sessions with persistent cookies. Reddit sees a normal user, not a bot.

## Safety Rules (Built-in)

| Rule | Default |
|------|---------|
| Max replies/day | 5 |
| Max per subreddit/day | 2 |
| Min gap between replies | 30 min |
| Self-promo ratio | < 10% |
| Human approval required | Yes (Phase 1) |

## Installation

### Via ClawHub (recommended)
```bash
clawhub install reddit-brand-agent
```

### Manual
Clone into your OpenClaw skills directory:
```bash
git clone https://github.com/rogermzy/reddit-brand-agent.git ~/clawd/skills/reddit-brand-agent
```

## Setup

1. **Log into Reddit** via the browser profile OpenClaw uses
2. **Create a client config** — copy `references/clients/example.yaml` and customize:
   ```bash
   cp references/clients/example.yaml references/clients/my-brand.yaml
   ```
3. **Or use auto-onboarding** — just give the skill your website URL and it will recommend subreddits, keywords, and brand voice

## File Structure

```
reddit-brand-agent/
├── SKILL.md                        # Core instructions for the AI agent
├── README.md                       # This file
├── scripts/
│   ├── reddit-onboard.sh           # Client onboarding helper
│   ├── reddit-log.sh               # Activity logging
│   └── reddit-stats.sh             # Activity statistics
└── references/
    └── clients/
        └── example.yaml            # Template client config
```

## Client Config

Each client gets a YAML config defining:
- **Target subreddits** (tiered by relevance)
- **Keywords** to monitor
- **Competitors** to watch
- **Brand voice** (persona, tone, dos/don'ts, when to mention brand)
- **Rate limits** and approval settings

See [`references/clients/example.yaml`](references/clients/example.yaml) for the full template.

## Requirements

- [OpenClaw](https://github.com/openclaw/openclaw) with browser tool enabled
- A Reddit account logged in via the browser profile
- No Reddit API keys needed

## License

MIT
