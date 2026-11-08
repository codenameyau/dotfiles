# dotfiles

How dotfiles work and how to manage them: shell startup order, ways to install and sync
them, keeping secrets out, the XDG directories, macOS `defaults`, and testing changes
safely. For what's in *this* repository, see the [main README](../README.md).

## Table of Contents

- [What dotfiles are](#what-dotfiles-are)
- [Shell startup files](#shell-startup-files)
  - [Login vs interactive shells](#login-vs-interactive-shells)
  - [bash](#bash)
  - [zsh](#zsh)
  - [What to put where](#what-to-put-where)
  - [Checking which files ran](#checking-which-files-ran)
- [Ways to manage dotfiles](#ways-to-manage-dotfiles)
  - [Copy (what this repo does)](#copy-what-this-repo-does)
  - [Symlinks](#symlinks)
  - [GNU Stow](#gnu-stow)
  - [Bare git repository](#bare-git-repository)
  - [chezmoi](#chezmoi)
  - [Other tools](#other-tools)
  - [Choosing one](#choosing-one)
- [Machine-specific config and secrets](#machine-specific-config-and-secrets)
- [XDG base directories](#xdg-base-directories)
- [Git config tips](#git-config-tips)
- [macOS defaults](#macos-defaults)
- [Bootstrapping a new machine](#bootstrapping-a-new-machine)
- [Shell startup performance](#shell-startup-performance)
- [Testing changes safely](#testing-changes-safely)
- [Further reading](#further-reading)

## What dotfiles are

Unix programs read their per-user configuration from files and directories in your home
directory whose names start with a dot (`~/.zshrc`, `~/.gitconfig`, `~/.ssh/config`).
`ls` hides dotfiles by default (use `ls -A`), which kept home directories tidy and gave
the convention its name. Newer programs follow the
[XDG spec](#xdg-base-directories) and use `~/.config/<app>/` instead.

Keeping them in a git repository gives you:

- the same environment on every machine, set up in minutes,
- history and the ability to revert a bad change,
- a place to keep scripts, notes, and provisioning steps next to the config.

## Shell startup files

### Login vs interactive shells

A shell is:

- **login** if it is the first shell of a session: a macOS Terminal or iTerm2 window/tab,
  an SSH session, a Linux virtual console, or `bash -l` / `zsh -l`.
- **interactive** if it reads commands from you at a prompt. Scripts are
  non-interactive.

The two are independent: an SSH session is both; a new tab in GNOME Terminal is usually
interactive but not login; `ssh host 'cmd'` is non-interactive.

```bash
# Login shell?
shopt -q login_shell && echo login     # bash
[[ -o login ]] && echo login           # zsh

# Interactive?
[[ $- == *i* ]] && echo interactive    # bash and zsh
```

### bash

| Shell type | Files read, in order |
| ---------- | -------------------- |
| Login (interactive or not) | `/etc/profile`, then **only the first** that exists of `~/.bash_profile`, `~/.bash_login`, `~/.profile`. On logout: `~/.bash_logout`. |
| Interactive, non-login | `/etc/bash.bashrc` (Debian/Ubuntu builds), `~/.bashrc` |
| Non-interactive (scripts) | The file named in `$BASH_ENV`, if any |
| Invoked as `sh` | `/etc/profile`, `~/.profile` (login); `$ENV` (interactive) |

Special cases:

- bash run by `sshd` for a remote command (`ssh host cmd`) also reads `~/.bashrc` on
  most builds. This is why `.bashrc` should return early when not interactive:
  ```bash
  [[ $- != *i* ]] && return
  ```
- Because a login shell does **not** read `~/.bashrc`, the usual fix is to source it
  from `~/.bash_profile`:
  ```bash
  # ~/.bash_profile
  [ -f ~/.bashrc ] && . ~/.bashrc
  ```
- Creating `~/.bash_profile` on Ubuntu stops bash from reading the distro's
  `~/.profile`, which is what adds `~/.local/bin` and `~/bin` to `PATH`. Copy those
  lines over or source `~/.profile` from it.

### zsh

zsh reads up to five files, each first from `/etc` (or `/etc/zsh` on Debian) and then
from `$ZDOTDIR` (default `$HOME`):

| File | Login | Interactive | Script | Use for |
| ---- | :---: | :---------: | :----: | ------- |
| `.zshenv` | ✓ | ✓ | ✓ | Environment needed everywhere, including scripts (`ZDOTDIR`, minimal `PATH`). Keep it fast and quiet. |
| `.zprofile` | ✓ | | | Login-time setup, e.g. `eval "$(/opt/homebrew/bin/brew shellenv)"` |
| `.zshrc` | | ✓ | | Interactive setup: options, aliases, prompt, completions, plugins |
| `.zlogin` | ✓ | | | Runs after `.zshrc` in login shells; rarely needed |
| `.zlogout` | ✓ | | | On logout |

Order for an interactive login shell: `.zshenv` → `.zprofile` → `.zshrc` → `.zlogin`.

On macOS, `/etc/zprofile` runs `path_helper`, which **reorders `PATH`** using
`/etc/paths` and `/etc/paths.d/*`. Anything you prepend to `PATH` in `.zshenv` can end
up after the system directories in login shells. Set `PATH` in `.zprofile` or `.zshrc`
instead.

To keep zsh files out of `$HOME`, set `ZDOTDIR` in `~/.zshenv`:

```bash
# ~/.zshenv
export ZDOTDIR="$HOME/.config/zsh"
```

zsh then reads `~/.config/zsh/.zshrc`, and so on.

### What to put where

| Put this | In bash | In zsh |
| -------- | ------- | ------ |
| `PATH`, `EDITOR`, `LANG`, other exported variables | `~/.bash_profile` (login) or `~/.bashrc` | `~/.zprofile` (or `~/.zshenv` if scripts need it) |
| Aliases, functions, prompt, key bindings, completions, shell options | `~/.bashrc` | `~/.zshrc` |
| Things that print output or are slow | `~/.bashrc` only (never in files scripts read) | `~/.zshrc` only |
| Secrets and machine-specific overrides | An untracked file sourced from the above | Same |

Exported variables are inherited by child processes, so they only need to be set once
per session. Aliases, functions, and shell options are not inherited and must be set in
every interactive shell.

### Checking which files ran

```bash
# Trace every file and command zsh runs at startup.
zsh -xli -c exit 2>&1 | less

# Bash login shell.
bash -xli -c exit 2>&1 | less

# Where is an alias, function, or command defined?
type gs
which -a python3

# Bash: which file defined a function?
shopt -s extdebug; declare -F myfunc; shopt -u extdebug

# zsh: same.
whence -v myfunc
```

## Ways to manage dotfiles

### Copy (what this repo does)

`setup.sh` / `update.sh` `cp` files from the repo into `$HOME`.

- **Pros:** nothing to install; easy to understand; `$HOME` has no links back into the
  repo, so deleting the repo is harmless.
- **Cons:** two copies drift apart. Edits in `~` must be copied back by hand, and edits in
  the repo must be re-copied. A re-copy silently overwrites local changes.

### Symlinks

Link each file in `$HOME` to the file in the repo, so there is only one copy:

```bash
cd ~/Workspace/dotfiles
for f in .zshrc .gitconfig .gitignore_global .inputrc; do
  [ -e ~/"$f" ] && [ ! -L ~/"$f" ] && mv ~/"$f" ~/"$f.bak"
  ln -sfv "$PWD/shell/$f" ~/"$f"
done
```

- **Pros:** edit either path and you're editing the same file; `git diff` in the repo
  shows every change.
- **Cons:** the repo must stay at the same path; a few programs replace symlinks with
  regular files when they save their settings.

Find broken symlinks in your home directory:

```bash
find ~ -maxdepth 2 -type l ! -exec test -e {} \; -print
```

### GNU Stow

[GNU Stow](https://www.gnu.org/software/stow/) automates symlinking. Arrange the repo as
one directory ("package") per program, laid out the way it should appear under
`$HOME`:

```
~/dotfiles/
├── zsh/.zshrc
├── git/.gitconfig
└── nvim/.config/nvim/init.lua
```

```bash
brew install stow          # or: sudo apt install stow
```

```bash
cd ~/dotfiles && stow -v zsh git nvim     # create links in the parent directory (~)
```

```bash
stow -D zsh                               # remove a package's links
```

```bash
stow -R zsh                               # re-link after adding files
```

Stow links into the parent of the directory you run it in; use `-t ~` if the repo
lives somewhere else. It refuses to overwrite existing real files. Move them aside first,
or use `--adopt` to move them into the repo (then check `git diff` to see what changed).

### Bare git repository

Track files in `$HOME` directly, with no copies or links, by keeping the git directory
somewhere else:

```bash
git init --bare "$HOME/.dotfiles"
alias dot='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
dot config --local status.showUntrackedFiles no
dot add ~/.zshrc ~/.gitconfig
dot commit -m "Add zsh and git config"
```

On a new machine:

```bash
git clone --bare git@github.com:you/dotfiles.git "$HOME/.dotfiles"
alias dot='git --git-dir="$HOME/.dotfiles" --work-tree="$HOME"'
dot checkout        # fails if files already exist: back them up and retry
dot config --local status.showUntrackedFiles no
```

- **Pros:** no tooling, no links; files live exactly where programs expect them.
- **Cons:** easy to forget the alias and run plain `git` in `~`; no templating for
  per-machine differences; `git clean` with the alias can delete files across `$HOME`.

### chezmoi

[chezmoi](https://www.chezmoi.io/) keeps a source directory (`~/.local/share/chezmoi`)
and generates the real files from it. It has templates for per-machine differences, can
encrypt secrets, and integrates with password managers.

```bash
brew install chezmoi       # or: sh -c "$(curl -fsLS get.chezmoi.io)"
```

```bash
chezmoi init                       # create the source repository
chezmoi add ~/.zshrc               # start managing a file
chezmoi edit ~/.zshrc              # edit the source version
chezmoi diff                       # preview what would change in $HOME
chezmoi apply                      # write changes to $HOME
chezmoi cd                         # shell in the source repo; commit and push from here
```

New machine, one command:

```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply <github-username>
```

Templates (files named `*.tmpl`) use Go template syntax:

```
{{ if eq .chezmoi.os "darwin" }}
export HOMEBREW_PREFIX=/opt/homebrew
{{ else }}
alias pbcopy='xsel --clipboard --input'
{{ end }}
```

Secrets can come from 1Password, Bitwarden, `pass`, the system keychain, and others,
e.g. `{{ onepasswordRead "op://Personal/GitHub/token" }}`.

### Other tools

| Tool | Approach |
| ---- | -------- |
| [yadm](https://yadm.io/) | Bare-repo style git wrapper with alternate files per OS/host and encryption |
| [dotbot](https://github.com/anishathalye/dotbot) | YAML file listing symlinks and shell commands; vendored as a git submodule |
| [rcm](https://github.com/thoughtbot/rcm) | Symlink manager with host- and tag-specific files |
| [home-manager](https://github.com/nix-community/home-manager) | Declarative config through Nix; also installs the programs |
| Ansible | Full machine provisioning, including dotfiles, as idempotent playbooks |

### Choosing one

- One or two machines and you want something simple: **symlinks** or **Stow**.
- Several machines with OS or work/personal differences, or secrets: **chezmoi** (or
  yadm).
- You also want to declare which packages are installed and pin versions:
  **home-manager** or **Ansible**.

## Machine-specific config and secrets

Don't commit API tokens, passwords, private keys, or employer-internal hostnames to a
public dotfiles repo. Bots scan GitHub for leaked credentials within minutes of a push.

Keep one tracked file that sources an untracked local one:

```bash
# End of ~/.zshrc
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
```

```bash
# ~/.gitconfig: include an untracked file for work identity or signing keys.
[include]
  path = ~/.gitconfig.local

# Use a different identity for repos under ~/work/.
[includeIf "gitdir:~/work/"]
  path = ~/.gitconfig.work
```

Ways to supply the secrets themselves:

- A password manager CLI at the point of use, e.g. 1Password's
  `export GITHUB_TOKEN="$(op read 'op://Personal/GitHub/token')"`.
- The macOS Keychain: `security find-generic-password -s my-token -w`.
- Per-project `.envrc` files with [direnv](https://direnv.net/), added to
  `.gitignore`.
- chezmoi's encryption or password-manager templates.

Add a pre-commit secret scanner such as [gitleaks](https://github.com/gitleaks/gitleaks)
to the dotfiles repo, and turn on GitHub secret scanning and push protection. If a
secret is pushed, **revoke and rotate it first**. Rewriting git history afterwards (with
`git filter-repo`) doesn't help, because forks, caches, and scanners already have it.

Also be careful with:

- `~/.ssh`: commit `~/.ssh/config` only if it has no sensitive hostnames; never commit
  private keys.
- Shell history files (`.zsh_history`, `.bash_history`), which often contain tokens typed
  on the command line. Prefix a command with a space to keep it out of history
  (`HISTCONTROL=ignorespace` in bash, `setopt HIST_IGNORE_SPACE` in zsh; both are set in
  this repo).
- `~/.npmrc`, `~/.pypirc`, `~/.netrc`, `~/.docker/config.json`, `~/.aws/credentials`,
  `~/.kube/config`: these usually contain credentials.

## XDG base directories

The [XDG Base Directory spec](https://specifications.freedesktop.org/basedir-spec/latest/)
defines where programs should store files, so that `$HOME` isn't full of dotfiles:

| Variable | Default | Contents |
| -------- | ------- | -------- |
| `XDG_CONFIG_HOME` | `~/.config` | Configuration (what you put in a dotfiles repo) |
| `XDG_DATA_HOME` | `~/.local/share` | Data that should persist (history, plugins) |
| `XDG_STATE_HOME` | `~/.local/state` | State such as logs and recent files |
| `XDG_CACHE_HOME` | `~/.cache` | Caches; safe to delete |
| (not a variable) | `~/.local/bin` | User executables; add to `PATH` |

Programs that already read from `~/.config`: git (`~/.config/git/config` and
`~/.config/git/ignore`), Neovim, tmux 3.1+, fish, Alacritty, kitty, WezTerm, Ghostty,
htop, starship, fusuma, and many others. Others can be redirected with environment
variables, e.g. `export ZDOTDIR="$HOME/.config/zsh"` or
`export npm_config_userconfig="$XDG_CONFIG_HOME/npm/npmrc"`. The
[Arch Wiki XDG page](https://wiki.archlinux.org/title/XDG_Base_Directory) lists the
setting for hundreds of programs.

On macOS, GUI apps keep settings in `~/Library/Preferences` and
`~/Library/Application Support` rather than XDG paths, though many CLI tools still
respect `~/.config`.

## Git config tips

Useful settings beyond what's in [shell/.gitconfig](../shell/.gitconfig):

```ini
[init]
  defaultBranch = main
[pull]
  rebase = true            # or ff = only
[fetch]
  prune = true             # drop deleted remote branches on every fetch
[rebase]
  autoStash = true
  updateRefs = true        # move stacked branches along with a rebase (git 2.38+)
[rerere]
  enabled = true           # remember conflict resolutions
[diff]
  algorithm = histogram
  colorMoved = default
[merge]
  conflictStyle = zdiff3   # show the common ancestor in conflicts (git 2.35+)
[push]
  autoSetupRemote = true   # first push sets upstream (git 2.37+)
[branch]
  sort = -committerdate
[commit]
  verbose = true           # show the diff in the commit message editor
```

Sign commits with your SSH key (git 2.34+) instead of GPG:

```bash
git config --global gpg.format ssh
git config --global user.signingkey ~/.ssh/id_ed25519.pub
git config --global commit.gpgsign true
```

Add the same public key to GitHub as a **signing key** (separate from the
authentication key) to get the "Verified" badge.

See where each setting comes from:

```bash
git config --list --show-origin --show-scope
```

## macOS defaults

macOS stores app and system preferences in property lists that the `defaults` command
can read and write. [provision/osx/config.sh](../provision/osx/config.sh) is a collection
of them.

```bash
defaults read com.apple.dock                        # everything for a domain
defaults read com.apple.dock autohide               # one key
defaults write com.apple.dock autohide -bool true   # set it
defaults delete com.apple.dock autohide             # back to the default
defaults domains | tr ',' '\n' | grep -i finder     # find a domain
```

Most changes only take effect after the app restarts:

```bash
killall Dock Finder SystemUIServer
```

To find the key for a setting you changed in the GUI, take a snapshot before and after
and compare them:

```bash
defaults read > /tmp/before.txt
```

```bash
defaults read > /tmp/after.txt && diff /tmp/before.txt /tmp/after.txt
```

Caveats:

- Keys change between macOS releases, and old ones are silently ignored. Re-check a
  `defaults` script after each major upgrade.
- Some settings now require other tools or can only be set in the GUI or by MDM. For
  example, "require password after sleep" is `sysadminctl -screenLock immediate
  -password -` on current macOS.
- `defaults write` to some domains (Safari, Mail) requires granting Terminal Full Disk
  Access.

[mathiasbynens/dotfiles `.macos`](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
is the classic collection, though many entries in it are outdated too.

Install applications declaratively with a `Brewfile`:

```bash
brew bundle dump --file=~/Workspace/dotfiles/Brewfile --force   # snapshot what's installed
```

```bash
brew bundle --file=~/Workspace/dotfiles/Brewfile                # install everything in it
```

```bash
brew bundle cleanup --file=~/Workspace/dotfiles/Brewfile        # list what isn't in it (--force to remove)
```

A Brewfile can list formulae (`brew "jq"`), casks (`cask "iterm2"`), Mac App Store apps
(`mas "Xcode", id: 497799835`, needs `mas`), and VS Code extensions
(`vscode "esbenp.prettier-vscode"`).

## Bootstrapping a new machine

A rough order that avoids chicken-and-egg problems:

1. **Install the platform's developer tools.** macOS: `xcode-select --install` (provides
   `git`, `make`, `clang`). Debian/Ubuntu: `sudo apt install build-essential git curl`.
2. **Install a package manager.** macOS: [Homebrew](https://brew.sh). On Apple Silicon,
   then run `eval "$(/opt/homebrew/bin/brew shellenv)"` and add that line to
   `~/.zprofile`.
3. **Set up SSH (and signing) keys** and add them to GitHub:
   ```bash
   ssh-keygen -t ed25519 -C "you@example.com"
   ```
   On macOS, add `UseKeychain yes` and `AddKeysToAgent yes` to `~/.ssh/config` so the
   passphrase is stored in the keychain.
4. **Clone the dotfiles repo** and install it (copy, link, or `chezmoi init --apply`).
5. **Install packages** (`brew bundle`, `apt install ...`).
6. **Install language runtimes** through a version manager rather than system packages,
   e.g. [mise](https://mise.jdx.dev/) (handles Node, Python, Ruby, Go, and more),
   [nvm](https://github.com/nvm-sh/nvm) / [fnm](https://github.com/Schniz/fnm) / `n` for
   Node, [uv](https://docs.astral.sh/uv/) or [pyenv](https://github.com/pyenv/pyenv) for
   Python, [rbenv](https://github.com/rbenv/rbenv) for Ruby.
7. **Apply OS settings** (`provision/osx/config.sh`) and restart affected apps.
8. **Sign in to apps** and restore anything that isn't in the repo.

Write bootstrap scripts to be **idempotent**, so running them twice is harmless:

```bash
command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
grep -qxF 'source ~/.zshrc.local' ~/.zshrc || echo 'source ~/.zshrc.local' >> ~/.zshrc
```

Read `curl | sh` installers before running them, and prefer the project's official URL.

## Shell startup performance

A new terminal should be ready in well under a second. Measure:

```bash
time zsh -i -c exit
```

```bash
for i in $(seq 5); do /usr/bin/time zsh -i -c exit; done
```

Profile zsh by adding `zmodload zsh/zprof` at the very top of `~/.zshrc` and `zprof` at
the very bottom, then opening a new shell.

Common causes of slow startup and fixes:

- **Version managers** (`nvm`, `pyenv`, `rbenv` init scripts): load them lazily, or
  switch to faster ones (`fnm`, `mise`).
- **`$(brew --prefix)` calls**: each one runs Ruby. Hard-code the prefix, or call it once
  and store it in a variable.
- **`compinit`** running a full security check on every shell: run it once a day with
  a cached dump (`compinit -C`).
- **Too many oh-my-zsh plugins.** Remove ones you don't use, or switch to a lighter
  plugin manager ([antidote](https://getantidote.github.io/),
  [zinit](https://github.com/zdharma-continuum/zinit)) or a fast prompt such as
  [starship](https://starship.rs/) or [powerlevel10k](https://github.com/romkatv/powerlevel10k).
- **Network calls or `kubectl`/`gcloud` commands** in the prompt: cache their output.

## Testing changes safely

- Keep a terminal window open with a working shell while you edit startup files, so a
  syntax error can't lock you out.
- Syntax-check before reloading: `zsh -n ~/.zshrc`, `bash -n ~/.bashrc`.
- Lint with [ShellCheck](https://www.shellcheck.net/) (bash/sh only; it doesn't support
  zsh).
- Start a clean shell to rule out your config: `zsh -f` or `bash --norc --noprofile`.
- Try the whole setup in a throwaway environment:
  ```bash
  docker run --rm -it -v "$PWD":/dotfiles ubuntu:24.04 bash
  ```
  or with a separate home directory:
  ```bash
  HOME=$(mktemp -d) zsh -l
  ```
- Run ShellCheck and an install script in CI (e.g. a GitHub Actions job on
  `ubuntu-latest` and `macos-latest`) to catch breakage before it reaches a new machine.

## Further reading

- [dotfiles.github.io](https://dotfiles.github.io/): guides, tools, and example repos
- [Arch Wiki: Dotfiles](https://wiki.archlinux.org/title/Dotfiles)
- [Arch Wiki: XDG Base Directory](https://wiki.archlinux.org/title/XDG_Base_Directory)
- [Zsh manual: Startup/Shutdown Files](https://zsh.sourceforge.io/Doc/Release/Files.html)
- [Bash manual: Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html)
- [chezmoi: comparison table](https://www.chezmoi.io/comparison-table/)
- [Atlassian: The best way to store your dotfiles (bare repo)](https://www.atlassian.com/git/tutorials/dotfiles)
- [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles) and
  [holman/dotfiles](https://github.com/holman/dotfiles): well-known examples
