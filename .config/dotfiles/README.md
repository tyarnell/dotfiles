# dotfiles

Personal config tracked as a [bare git repo](https://www.atlassian.com/git/tutorials/dotfiles) in `$HOME` — no symlinks, no stow.

## What's tracked

| Path | |
|---|---|
| `.config/nushell/{env,config}.nu` | shell config |
| `.config/helix/{config,languages,external-snippets}.toml` | editor + LSP wiring |
| `.config/helix/snippets/` | hand-curated snippets |
| `.config/dotfiles/Brewfile` | brew formulae + casks |
| `.config/dotfiles/README.md` | this file |
| `bin/bootstrap` | one-shot installer for a new Mac |

## Daily use

The `dot` function (defined in `config.nu`) is just `git` scoped to this repo:

```nu
dot status
dot add ~/.config/helix/config.toml
dot commit -m "tweak rulers"
dot push
```

## New machine

```bash
curl -fsSL https://raw.githubusercontent.com/tyarnell/dotfiles/main/bin/bootstrap | bash
```

Defaults to cloning `https://github.com/tyarnell/dotfiles.git` (HTTPS so a brand-new box without SSH keys works). Override for forks: `DOTFILES_REMOTE=git@github.com:fork/dotfiles.git bash bootstrap`. After setup, switch the remote to SSH with `dot remote set-url origin git@github.com:tyarnell/dotfiles.git`.

The bootstrap script:

1. Installs Xcode Command Line Tools, then Homebrew
2. Clones this repo as a bare repo at `~/.dotfiles` and checks out into `$HOME`
3. On macOS, symlinks `~/Library/Application Support/nushell/{env,config}.nu` → `~/.config/nushell/...` so nushell finds its config at the macOS-native path
4. Runs `brew bundle` (Brewfile)
5. Installs rustup + `simple-completion-language-server`
6. Installs Go LSPs/tools: `gopls`, `dlv`, `goimports`, `gotests`, `staticcheck`
7. Adds `nu` to `/etc/shells` (run `chsh -s $(which nu)` to switch login shell)

## Bare repo, briefly

```bash
git init --bare ~/.dotfiles
git --git-dir=~/.dotfiles --work-tree=$HOME config status.showUntrackedFiles no
```

`status.showUntrackedFiles=no` is what makes this livable — without it, `dot status` would list every file in `$HOME`.
