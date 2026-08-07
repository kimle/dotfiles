---
name: review
description: Review changes before committing or pushing in this repo. Use before any commit or push to catch secrets, identity, and junk files.
---

# Review gate

Nothing sensitive is EVER pushed from this repo. Review the diff before every
commit and again before any push.

## Blocked — never commit

- Private keys, API tokens (AWS/GitHub/Slack/Stripe/OpenAI/...), age-encrypted
  blobs, `.env` files
- Git identity: the repo's identity emails and `signingkey` lines
- Absolute machine home paths (e.g. `/home/<user>/`)
- Junk in a dotfiles repo: `id_rsa*`, `*.pem`/`*.p12`/`*.key`, files >1 MiB
- Merge-conflict markers (`<<<<<<<`, `>>>>>>>`)

## How to check

- `git diff` / `git diff --cached` — scan added lines for the patterns above
- If chezmoi files are involved: `chezmoi verify`, and confirm identity and
  secrets live only in machine-local `~/.config/chezmoi/chezmoi.toml`
  (`[data]`), never in the `chezmoi/` sources
- Fix anything found; do not commit or push a diff that contains a hit
