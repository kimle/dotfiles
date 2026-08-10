# Plan: taking chezmoi into use

Scope: **only tools actually installed/configured by `setup/*.sh`**.
Anything not installed by the setup scripts (zsh/.zshrc, bashrc, i3, ncmpcpp, mpd,
ghostty, powerline, sublime-text, fontconfig, Xresources, xinitrc, iterm2,
prettierrc, awesome) is **out of scope** and stays untouched.

## 1. Inventory — what the setup scripts install vs. what chezmoi manages

| Tool | Installed by setup | Config file | Currently handled by | chezmoi action |
|---|---|---|---|---|
| tmux | dnf/brew | `~/.tmux.conf` | `setup_tmux` copies repo root `.tmux.conf` | **Manage** (`dot_tmux.conf`) |
| vim | dnf/brew | `~/.vimrc`, `~/.vim/` | `setup_vim` copies both | **Manage** `.vimrc`; keep `.vim/` (vendor + submodules) as setup copy |
| fish | dnf/brew | `~/.config/fish/config.fish` | `setup_fish` heredoc | **Manage** (`dot_config/fish/config.fish`); delete heredoc |
| starship | official installer | `~/.config/starship.toml` | `setup_starship` copies + appends block | **Manage** — consolidate the two repo copies |
| mise | official installer | `~/.config/mise/config.toml` | already in `chezmoi/dot_config/mise/` | **Manage** — reconcile with live file |
| atuin | official installer (Fedora only) | `~/.config/atuin/config.toml` | `setup_atuin` heredoc (only if missing) | **Manage** as template, linux-only |
| git + git-delta | dnf/brew | `~/.gitconfig` | *not managed anywhere* (lives on machine only) | **Manage** (`dot_gitconfig`) — delta is already wired in, currently lost on new machines |
| bat | dnf/brew | `~/.config/bat/config` + theme | `setup_bat` curl + append | **Decision**: download vs manage (see §4) |
| eza | dnf/brew | `~/.config/eza/theme.yml` | `setup_eza` curl | **Decision**: download vs manage (see §4) |
| delta | dnf/brew | `~/.config/delta/catppuccin.gitconfig` | `setup_delta` curl | **Decision**: download vs manage (see §4) |
| fzf | dnf/brew (+ clone) | `~/.fzf/`, rc lines | `setup_fzf` clone; rc lines in config.fish heredoc | binary stays script; rc lines covered via managed config.fish |
| zoxide | dnf/brew | none (init line in config.fish) | heredoc line | covered via managed config.fish |
| nvm / node | fish plugin | none (universal vars) | `setup_nvm` | nothing (fish state, not files) |
| docker, podman, ripgrep, jq, gcc, fastfetch, fd, ncurses, netcat, man-db, man-pages, curl | dnf/brew | none | — | nothing |
| fish completions (`chezmoi.fish`, `mise.fish`, `eza.fish`, `atuin.fish`) | generated | `~/.config/fish/completions/` | setup functions | **not** chezmoi (version-locked generated content) |
| `fish_plugins`, `fish_variables` | fisher state | `~/.config/fish/` | `setup_fish`/`setup_nvm` | **not** chezmoi (machine state) |

## 2. Target architecture

Keep the `chezmoi/` subdir as the source tree (the repo root also carries
non-managed files, so a subdir keeps scope tight — this is also what the branch
already started).

```
~/.config/chezmoi/chezmoi.toml        sourceDir = "~/misc/dotfiles/chezmoi"
~/misc/dotfiles/chezmoi/              the source tree (dot_ prefix = $HOME mapping)
    dot_tmux.conf
    dot_vimrc
    dot_gitconfig
    dot_config/fish/config.fish
    dot_config/starship.toml
    dot_config/mise/config.toml
    dot_config/atuin/config.toml.tmpl   (linux-only)
```

`setup/*.sh` keep doing **packages + binaries + vendor clones + completions**;
chezmoi owns **user-editable dotfiles**. New-machine flow:

1. `setup.sh` → dnf/brew installs packages (incl. `chezmoi`, `age`)
2. `setup.sh` clones `git@github.com:kimle/dotfiles.git` → `~/misc/dotfiles`
3. `chezmoi --source ~/misc/dotfiles/chezmoi apply` (no persistent config needed;
   the config file is only a convenience for daily `chezmoi edit/add`)

## 3. Migration steps (on this machine first)

**Phase 1 — install & configure chezmoi locally**

```bash
sudo dnf install chezmoi                      # already in fedora.sh package list
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<'EOF'
sourceDir = "~/misc/dotfiles/chezmoi"
EOF
chezmoi cd                                    # sanity: lands in source dir
chezmoi data                                  # sanity: template data available
```

**Phase 2 — adopt files into the source tree**

```bash
# tmux / vim / git (moves repo root copies into chezmoi/ as dot_*)
git mv .tmux.conf chezmoi/dot_tmux.conf
git mv .vimrc     chezmoi/dot_vimrc
cp ~/.gitconfig   chezmoi/dot_gitconfig       # review first — contains user+work data
chezmoi add ~/.config/fish/config.fish
chezmoi add ~/.config/starship.toml
chezmoi add ~/.config/atuin/config.toml
# mise: reconcile chezmoi/dot_config/mise/config.toml with live ~/.config/mise/config.toml
```

Then delete the **duplicate** root `.config/starship.toml` (keep only
`chezmoi/dot_config/starship.toml`, folding in the `[username]/[container]`
disabled block that `setup_starship` currently appends).

**Phase 3 — templates & per-machine data**

- `dot_config/atuin/config.toml.tmpl`:
  ```tmpl
  {{ if eq .chezmoi.os "linux" }}enter_accept = false

  [tmux]
  enabled = true
  {{ end }}
  ```
  (atuin is Fedora-only; `.chezmoi.os == "linux"` is the discriminator since the
  dispatcher only supports fedora + macos.)
- `dot_gitconfig.tmpl` if needed (work `includeIf` path is machine-specific;
  the signing key in `~/.gitconfig` is the **public** SSH key, so it's safe to
  commit — no age needed).
- Add `.chezmoidata.yaml` only if real per-machine values appear (e.g. git
  email); skip for now.

**Phase 4 — refactor setup scripts (hand files to chezmoi)**

| Function | Change |
|---|---|
| `setup_chezmoi` | after completions: `chezmoi --source "$HOME/misc/dotfiles/chezmoi" apply` |
| `setup_tmux` | keep catppuccin plugin clone; **delete** the `cp .tmux.conf` |
| `setup_vim` | keep `.vim/` copy + catppuccin colors; **delete** the `.vimrc` copy |
| `setup_fish` | keep chsh, fisher, theme, forgit, completions; **delete** config.fish heredoc |
| `setup_starship` | keep binary install; **delete** cp + append block |
| `setup_atuin` | keep installer + completions; **delete** config heredoc |
| `setup_chezmoi` bootstrap order | add `git clone` of dotfiles repo before the `apply` (new machines) |

New-machine order inside `main()`: packages → vendor/plugin clones → completions
→ clone dotfiles repo → `chezmoi apply` (last).

**Phase 5 — validate**

- `chezmoi verify` — all managed files match source (idempotency).
- Run `setup.sh` twice on this machine; second run must be a no-op for files.
- `chezmoi diff` after any manual edit to a home file.

## 4. Decisions to make

1. **bat / eza / delta themes**: currently `curl`-ed from upstream each setup.
   Options: (a) keep as downloads (always fresh, setup-owned), or (b) manage via
   chezmoi (pinned, but you must update them like any dotfile).
   Recommendation: keep downloads — they're vendor assets, not user edits.
2. **gitconfig**: recommended to manage (delta wiring + aliases currently exist
   only on this machine). But it contains `[user] name/email` and a work
   `includeIf` — either accept as-is or template the work path.
3. **mise config**: two divergent versions exist (repo `chezmoi/...` has the full
   `[tools]` list incl. chezmoi/sops; live `~/.config/mise/config.toml` has
   `node = "latest"`, `[env]`, `experimental`). Must pick one source of truth
   during Phase 2.
4. **starship**: consolidate the two copies into `chezmoi/dot_config/starship.toml`
   (root `.config/starship.toml` + `chezmoi/dot_config/starship.toml` + the
   appended block are all drifting).

## 5. Out of scope (not installed by setup scripts)

`.zshrc`, `.bashrc`, `.fzf-functions.zsh`, `.key-bindings.zsh`, `.Xresources`,
`.xinitrc`, `.i3/`, `.ncmpcpp/`, `.config/{mpd,ghostty,powerline,sublime-text-2,
fontconfig,awesome}`, `iterm2/`, `.prettierrc.yaml`, `install_bat_themes.sh`,
`tmux.sh`. Leave untouched; can be migrated later if their tools get added to setup.

## 6. Definition of done

- [ ] `chezmoi verify` passes on this machine
- [ ] setup scripts contain no `cp`/heredoc for any dotfile listed in §1
- [ ] one starship.toml, one mise config.toml
- [ ] atuin config only lands on linux
- [ ] fresh machine bootstrap: `setup.sh` → working tmux/vim/fish/starship/mise/git
