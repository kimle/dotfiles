# chezmoi source tree

This directory is the chezmoi source for the dotfiles of the tools installed by
`setup/*.sh`. Files map to `$HOME` via the `dot_` prefix (`dot_tmux.conf` →
`~/.tmux.conf`) and `dot_config/` (`dot_config/fish/config.fish` →
`~/.config/fish/config.fish`).

## Applying after the setup script

`setup.sh` already runs `chezmoi apply` as its **last step** on a fresh machine,
so nothing extra is needed. To (re)apply manually:

```sh
chezmoi apply
```

## Day-to-day workflow

```sh
chezmoi edit ~/.tmux.conf   # edit the SOURCE file (opens $EDITOR)
chezmoi diff                # preview what would change
chezmoi apply               # write source -> $HOME
```

Other useful commands:

```sh
chezmoi cd       # shell inside the source dir
chezmoi managed  # list managed files
chezmoi data     # template data for this machine
chezmoi verify   # check managed files still match source
chezmoi add ~/.config/foo   # adopt an existing file into the source
```

## Per-machine config and secrets

`~/.config/chezmoi/chezmoi.toml` is generated per machine by
`setup_chezmoi()` (it prompts for git identity and signing key). It is **not**
in this repo and holds everything machine-specific under `[data]`.

Secrets never enter this repo:

- mise `[env]` renders only when the machine's config provides
  `[data.mise.deepseek_api_key]`
- git identity/signing key come from `[data.git]`, prompted for at setup time

## Templates

| Source file | What it does |
|---|---|
| `dot_gitconfig.tmpl` | renders git identity + signing key from `[data.git]` |
| `dot_config/starship.toml.tmpl` | hostname module only on linux |
| `dot_config/mise/config.toml.tmpl` | `[env]` block only when the machine has the key |
| `dot_config/atuin/config.toml.tmpl` | linux only (atuin is Fedora-only) |

## Agent skill

`.pi/skills/chezmoi.md` is a project-level pi skill encoding this workflow:
edit sources under `chezmoi/`, apply loop (`diff` → `apply` → `verify`), never
commit secrets or identity, nil-safe `index` for optional template blocks.

- It is **auto-loaded** by pi when a task matches its description (working on
dotfiles or `setup/*.sh` in this repo) — no action needed.
- It can also be invoked explicitly with `/skill:chezmoi` in the pi TUI.
- Keep it in sync with this file if the workflow changes.

## Ignored

`README.md` is excluded via `.chezmoiignore` — this file is documentation only
and is never installed to `$HOME`.
