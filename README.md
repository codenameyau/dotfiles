# dotfiles

Personal shell, git, and editor configuration, machine provisioning scripts, small
command-line utilities, and a collection of reference notes for macOS and Linux
(Linux Mint / Ubuntu / Raspberry Pi OS).

> **Heads up:** these files are tuned for one person (Jorge Yau). `shell/.gitconfig`
> contains a real name and email, and several scripts assume particular branch names
> or registries. Read [Before you install](#before-you-install) and
> [Caveats](#caveats) before copying anything over your own config.

## Table of Contents

- [Quick start](#quick-start)
- [Before you install](#before-you-install)
- [Repository layout](#repository-layout)
- [How installation works](#how-installation-works)
  - [setup.sh](#setupsh)
  - [update.sh](#updatesh)
  - [Installing a single file](#installing-a-single-file)
  - [Keeping configs in sync](#keeping-configs-in-sync)
- [Shell configuration](#shell-configuration)
  - [Which file gets loaded when](#which-file-gets-loaded-when)
  - [Bash: .bash_profile (macOS) and .bashrc (Linux)](#bash-bash_profile-macos-and-bashrc-linux)
  - [Zsh: .zshrc, .zshrc_extras, .ohmyzshrc](#zsh-zshrc-zshrc_extras-ohmyzshrc)
  - [Shell aliases and functions](#shell-aliases-and-functions)
  - [Readline: .inputrc](#readline-inputrc)
  - [ack: .ackrc](#ack-ackrc)
  - [Trackpad gestures: fusuma](#trackpad-gestures-fusuma)
- [Git configuration](#git-configuration)
  - [.gitconfig](#gitconfig)
  - [.gitignore_global](#gitignore_global)
  - [Git hooks](#git-hooks)
- [Command-line utilities (bin/)](#command-line-utilities-bin)
- [Other scripts (scripts/)](#other-scripts-scripts)
- [Editors](#editors)
- [Machine provisioning](#machine-provisioning)
- [Reference docs](#reference-docs)
- [Caveats](#caveats)
- [Customizing for yourself](#customizing-for-yourself)
- [License](#license)

## Quick start

```bash
git clone git@github.com:codenameyau/dotfiles.git ~/Workspace/dotfiles
```

```bash
cd ~/Workspace/dotfiles
```

Back up what you already have, then copy the dotfiles into `$HOME`:

```bash
mkdir -p ~/dotfiles-backup && cp -v ~/.bashrc ~/.bash_profile ~/.zshrc ~/.gitconfig ~/.gitignore_global ~/.bash_aliases ~/dotfiles-backup/ 2>/dev/null
```

```bash
./update.sh
```

Open a new terminal (or `source` the changed file) to pick up the changes.

To make the scripts in [`bin/`](bin) runnable from anywhere, add the directory to your
`PATH` in `~/.zshrc` or `~/.bash_profile` / `~/.bashrc`:

```bash
export PATH="$HOME/Workspace/dotfiles/bin:$PATH"
```

For a brand-new Mac, see [Machine provisioning](#machine-provisioning) instead.

## Before you install

- **The install scripts copy, they don't symlink.** `setup.sh` and `update.sh` run
  `cp -v`, overwriting files in `$HOME` without a backup. Edits you make in `~` are
  not reflected in the repo; edits in the repo need to be re-copied.
- **Run them from the repo root.** Both scripts use relative paths (`shell/.bashrc`,
  `git-hooks/...`, `.git/hooks/...`).
- **Bash files are only copied if they already exist.** `~/.bashrc` is overwritten only
  if a `~/.bashrc` already exists, and likewise for `~/.bash_profile` and `~/.zshrc`.
  This is how the scripts tell macOS (which uses `.bash_profile`/`.zshrc`) from Linux
  (which uses `.bashrc`).
- **Change the git identity.** `shell/.gitconfig` sets `user.name`/`user.email` and the
  `changes`, `contributions`, and `flow` aliases filter on `--author="codenameyau"`.
- **HTTPS GitHub URLs are rewritten to SSH.** `.gitconfig` has
  `url."git@github.com:".insteadOf = https://github.com/`, so every `git clone
  https://github.com/...` goes over SSH. You need an SSH key registered with GitHub
  ([docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)), or
  remove that block.
- **`.zshrc` is built around oh-my-zsh.** It loads `~/.oh-my-zsh` if installed, then
  `~/.ohmyzshrc`, `~/.zshrc_extras`, and `~/.zshrc.local` if they exist. Each of these is
  optional, so the file also works in a plain zsh, just without the theme and plugins.

## Repository layout

```
dotfiles/
├── setup.sh                 # First-time install: copy dotfiles + install post-commit hook
├── update.sh                # Re-copy dotfiles (bash, zsh, git) into $HOME
├── shell/                   # Dotfiles destined for $HOME
│   ├── .bash_profile        #   macOS bash login shell
│   ├── .bashrc              #   Linux bash interactive shell
│   ├── .bash_aliases        #   Git shortcuts and helper functions (bash)
│   ├── .bash_extras         #   Empty placeholder for machine-local bash config
│   ├── .zshrc               #   Zsh + oh-my-zsh config, history, aliases
│   ├── .zshrc_extras        #   kubectl context in RPROMPT (zsh-kubectl-prompt)
│   ├── .ohmyzshrc           #   Custom prompt: virtualenv, exit status, git branch
│   ├── .gitconfig           #   Git identity, aliases, colors, push/URL behavior
│   ├── .gitignore_global    #   Global ignore list (node_modules, .DS_Store, ...)
│   ├── .inputrc             #   GNU Readline key bindings
│   ├── .ackrc               #   ack search defaults
│   └── .config/fusuma/      #   Linux touchpad gesture config
├── bin/                     # Standalone CLI utilities (add to PATH)
├── git-hooks/               # Reusable git hooks: <hook-name>--<purpose>
├── scripts/
│   ├── exercises/           #   Bash practice scripts
│   ├── open-source/         #   Vendored third-party scripts
│   └── workflow/            #   Release/deploy automation
├── provision/               # New-machine setup
│   ├── README.md            #   Manual setup checklist (apps, Python, Ruby)
│   ├── osx/setup.sh         #   Homebrew, oh-my-zsh, fzf, node, vim
│   ├── osx/config.sh        #   macOS `defaults write` tweaks
│   ├── linux-mint/setup.sh  #   apt packages, git-lfs, node, Brave, fusuma
│   └── iterm2-profile.json  #   iTerm2 profile (colors, keys)
├── vim/                     # .vimrc (Vundle) + install notes
├── vscode/                  # VS Code user settings, launch.json, extension list
├── sublime/                 # Sublime Text preferences
├── docs/                    # Reference notes (bash, git, networking, servers, Pi)
└── reference/bash-sheet.md  # Annotated copy of Greg's Wiki BashSheet
```

## How installation works

### setup.sh

[`setup.sh`](setup.sh) is meant to be run once, from the repo root, on a machine that
already has this repo cloned:

1. `chmod u+x git-hooks/*`.
2. Installs [`git-hooks/post-commit--dotfiles`](git-hooks/post-commit--dotfiles) as this
   repo's own `.git/hooks/post-commit`, so committing a change to a dotfile re-copies it
   into `$HOME` (see [Git hooks](#git-hooks)).
3. Copies `.bash_aliases`, `.gitconfig`, and `.gitignore_global` into `$HOME`.
4. Copies `.bashrc` if `~/.bashrc` exists and `.bash_profile` if `~/.bash_profile` exists.

It does **not** copy the zsh files, `.bash_extras`, `.inputrc`, `.ackrc`, or the vim
config.

### update.sh

[`update.sh`](update.sh) re-copies dotfiles after you pull or edit them:

| Source in `shell/`      | Copied to `~/` when          |
| ----------------------- | ---------------------------- |
| `.bash_aliases`         | always                       |
| `.gitconfig`            | always                       |
| `.gitignore_global`     | always                       |
| `.bashrc`, `.bash_extras` | `~/.bashrc` exists         |
| `.bash_profile`, `.bash_extras` | `~/.bash_profile` exists |
| `.zshrc`, `.zshrc_extras` | `~/.zshrc` exists          |

> If you have a customized `~/.bash_extras` or `~/.zshrc_extras`, `update.sh` will
> overwrite it with the repo version (an empty file and the kubectl prompt,
> respectively). Keep machine-local secrets and tweaks in `~/.zshrc.local`, which
> `.zshrc` sources last and nothing in this repo overwrites.

### Installing a single file

Every file is plain text, so you can grab one without cloning:

```bash
curl -fsSL -o ~/.gitignore_global https://raw.githubusercontent.com/codenameyau/dotfiles/master/shell/.gitignore_global
```

```bash
git config --global core.excludesfile ~/.gitignore_global
```

The vim config is installed the same way; see [vim/README.md](vim/README.md).

### Keeping configs in sync

The copy-based approach is simple but drifts: change `~/.zshrc` directly and the repo
never learns about it. To see what has drifted:

```bash
for f in .bashrc .bash_profile .bash_aliases .zshrc .zshrc_extras .gitconfig .gitignore_global; do [ -f ~/$f ] && ! cmp -s shell/$f ~/$f && echo "differs: $f"; done
```

```bash
diff -u shell/.zshrc ~/.zshrc
```

If you'd rather edit in one place, replace the copies with symlinks (run from the repo
root):

```bash
ln -sfv "$PWD/shell/.zshrc" ~/.zshrc
```

Symlinks, GNU Stow, bare git repos, and chezmoi are compared in
[docs/dotfiles.md](docs/dotfiles.md#ways-to-manage-dotfiles).

## Shell configuration

### Which file gets loaded when

Which startup file runs depends on the shell and on whether it is a *login* and/or
*interactive* shell. This is the single most common source of "my alias doesn't work"
confusion.

| Shell | Login (macOS Terminal/iTerm2 tab, `ssh`, `bash -l`) | Interactive non-login (new tab in most Linux terminals, typing `bash`) | Non-interactive (scripts) |
| ----- | ----- | ----- | ----- |
| bash  | `/etc/profile`, then the **first** of `~/.bash_profile`, `~/.bash_login`, `~/.profile` | `~/.bashrc` (Debian/Ubuntu also read `/etc/bash.bashrc`) | `$BASH_ENV`, if set |
| zsh   | `~/.zshenv` → `~/.zprofile` → `~/.zshrc` → `~/.zlogin` | `~/.zshenv` → `~/.zshrc` | `~/.zshenv` |

Consequences for this repo:

- macOS has defaulted to **zsh** since Catalina (10.15). On a Mac, `~/.zshrc` is what
  matters; `.bash_profile` is only used if you switch back with `chsh -s /bin/bash`.
- macOS terminals start *login* shells, which is why the macOS bash file is
  `.bash_profile`. Linux terminal emulators usually start non-login shells, so the
  Linux file is `.bashrc`.
- A common pattern is to have `.bash_profile` just source `.bashrc` so both cases
  behave the same:
  ```bash
  [ -f ~/.bashrc ] && . ~/.bashrc
  ```
- Reload after editing with `source ~/.zshrc` (or the `sp` alias in bash), or
  `exec zsh` for a clean restart of the shell.

More detail, including `$ZDOTDIR` and the XDG directories, is in
[docs/dotfiles.md](docs/dotfiles.md#shell-startup-files).

### Bash: .bash_profile (macOS) and .bashrc (Linux)

[`shell/.bash_profile`](shell/.bash_profile) (macOS):

- Appends `/opt/cabal/bin` (Haskell) to `PATH`.
- History: `HISTCONTROL=ignoreboth` (skip duplicates and lines starting with a space),
  `HISTIGNORE='cd*:rm*'` (never record `cd`/`rm` commands), 100 lines in memory and 200
  on disk.
- Colors: `CLICOLOR=1` and a BSD `LSCOLORS` palette.
- `less` syntax highlighting through `src-hilite-lesspipe.sh` from Homebrew's
  `source-highlight` package, with `LESS=' -R -X -F '` (pass colors through, don't clear
  the screen, quit if the output fits on one screen).
- Homebrew's `bash-completion`.
- Sources, if present: `~/.bash_prompt` (from
  [shiny-prompt](https://github.com/codenameyau/shiny-prompt)), `~/.bash_aliases`,
  `~/.bash_extras`.

[`shell/.bashrc`](shell/.bashrc) (Linux) starts from the Ubuntu default and adds:

- Returns early when the shell is not interactive, so `scp`/`rsync` and scripts aren't
  affected.
- Appends `/opt/cabal/bin` and `/snap/bin` to `PATH`.
- History: `ignoreboth`, `HISTIGNORE='cd*:rm*:ls*'`, `histappend`, 9999 lines.
- `VISUAL`/`EDITOR` set to `vim`.
- `checkwinsize` and `globstar` (`**` matches recursively).
- Colored `ls` (directories first, human-readable sizes) and **`grep` aliased to
  `grep --color=auto -E`**, so plain `grep` uses extended regex.
- Aliases: `..`, `...`, `ll`, `la`, `l`, `alert` (desktop notification when a long
  command finishes: `sleep 10; alert`), and `pbcopy`/`pbpaste` implemented with `xsel`.
- fzf key bindings (`~/.fzf.bash`).
- Sources, if present: `~/.bash_prompt`, `~/.bash_aliases`, `~/.bash_extras`.

[`shell/.bash_extras`](shell/.bash_extras) is an empty placeholder.

### Zsh: .zshrc, .zshrc_extras, .ohmyzshrc

[`shell/.zshrc`](shell/.zshrc):

- Loads [oh-my-zsh](https://ohmyz.sh/) from `$HOME/.oh-my-zsh`, if installed, with the
  `robbyrussell` theme and the
  [`git` plugin](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git).
- Options: `EXTENDED_GLOB`, `RM_STAR_WAIT` (10-second pause before `rm *` runs),
  `AUTO_CD` (type a directory name to `cd` into it), `SHARE_HISTORY` across sessions,
  and the `HIST_*` options that drop duplicate and space-prefixed entries.
- Effectively unlimited history (`HISTSIZE=SAVEHIST=999999999`).
- `less` highlighting via `source-highlight`, same as bash.
- fzf (`~/.fzf.zsh`) for fuzzy <kbd>Ctrl</kbd>+<kbd>R</kbd> history search,
  <kbd>Ctrl</kbd>+<kbd>T</kbd> file search, and <kbd>Alt</kbd>+<kbd>C</kbd> `cd`.
- Sets the terminal tab title to the current directory before each prompt (a `precmd`
  hook).
- The same git aliases as `.bash_aliases` plus `tickets`.
- Sources, if present: `~/.ohmyzshrc` (only when oh-my-zsh loaded, since it needs
  `git_prompt_info`), `~/.zshrc_extras`, and `~/.zshrc.local` for untracked
  machine-specific settings.

[`shell/.zshrc_extras`](shell/.zshrc_extras) shows the current Kubernetes context in the
right-hand prompt using
[zsh-kubectl-prompt](https://github.com/superbrothers/zsh-kubectl-prompt). It turns
white when the kube user contains `admin`, as a warning. It also loads
[git-extras](https://github.com/tj/git-extras) completions. Both are Homebrew packages,
found under `$HOMEBREW_PREFIX` (`/opt/homebrew` on Apple Silicon, `/usr/local` on
Intel), and each is skipped if not installed.

[`shell/.ohmyzshrc`](shell/.ohmyzshrc) defines a custom prompt: the active Python
virtualenv name, a green or red `➜` depending on the last exit code, the current
directory, and `git:(branch)` with a yellow `✗` when the tree is dirty. It replaces the
`robbyrussell` prompt. `provision/osx/setup.sh` downloads it; delete `~/.ohmyzshrc` to go
back to the theme's prompt.

### Shell aliases and functions

Defined in [`shell/.bash_aliases`](shell/.bash_aliases) (bash) and repeated in
`.zshrc` (zsh).

| Alias | Expands to | Notes |
| ----- | ---------- | ----- |
| `sp`  | `source ~/.bashrc` or `source ~/.bash_profile` | bash only |
| `ga`  | `git add -A` | stage everything, including deletions |
| `gb`  | `git branch --sort=committerdate \| tail -20` | 20 most recently committed branches |
| `gc`  | `git commit` | |
| `gs`  | `git status` | |
| `gg`  | `git checkout -` | toggle to the previous branch |
| `gd [N]` | `git diff HEAD~N HEAD` | diff of the last N commits (default 1); a function |
| `gl`  | `git log --no-merges` | |
| `gr`  | `git reset` | unstage |
| `gp`  | `git push` | |
| `git-pull-all` | `git pull` in every repo up to 3 levels below `.` | |
| `git-prune` | delete local branches merged into the current branch, then `git fetch --prune` | run from your main branch |
| `git-hide` / `git-hide-undo` | `git update-index --[no-]skip-worktree` | keep local edits to a tracked file out of `git status` |
| `git-ignore` / `git-ignore-undo` | `git update-index --[no-]assume-unchanged` | performance hint; can be reset by git |
| `git-ignore-list` | `git ls-files -v \| grep ^h` | list assume-unchanged files (skip-worktree shows as `S`) |
| `git-changelog` | log since the latest tag, `[hash] subject` | |
| `projects` | list `*/*/` directories under the directory where the alias was defined | bash only |
| `find-quickly <name>` | `find` to depth 3, skipping `node_modules`/`bower` | bash only |

| Function | Usage | What it does |
| -------- | ----- | ------------ |
| `kill-port` | `kill-port 3000` | Kills whatever is LISTENing on a TCP port (bash only) |
| `timestamps` | `timestamps 4 "-CREATE-"` | Prints N consecutive Unix timestamps with a suffix (bash only) |
| `git-replace` | `git-replace 'src/js' old new` | `sed`-replaces a string in tracked files whose path matches (GNU `sed -i`; bash only) |
| `ggg` | `ggg` | Merges `master` → `staging` → `edge` and pushes each (bash only) |
| `tickets` | `tickets v1.2.0 v1.3.0` | Lists Jira ticket URLs (`AG-123`, `DASH-45`) referenced between two refs |

`git-hide` vs `git-ignore`: use **skip-worktree** for "this tracked file has local
changes I never want to commit" (e.g. a local config). **assume-unchanged** only tells
git not to bother checking the file, and git may drop the flag on checkout or pull.

### Readline: .inputrc

[`shell/.inputrc`](shell/.inputrc) configures GNU Readline, the line editor used by bash
and many REPLs (`python`, `psql`, `mysql`, ...). It enables 8-bit input/output, and in
emacs mode binds Home/End, Delete/Insert, and <kbd>Ctrl</kbd>+<kbd>←</kbd>/<kbd>→</kbd> /
<kbd>Alt</kbd>+<kbd>←</kbd>/<kbd>→</kbd> to word movement. Readline reads `~/.inputrc`
(or `$INPUTRC`) and falls back to `/etc/inputrc`. Zsh uses its own line editor (ZLE)
and ignores this file. To see the escape sequence a key sends, press
<kbd>Ctrl</kbd>+<kbd>V</kbd> followed by the key. Install it manually:

```bash
cp shell/.inputrc ~/.inputrc
```

### ack: .ackrc

[`shell/.ackrc`](shell/.ackrc) makes [ack](https://beyondgrep.com/) skip
`node_modules`, `bower_components`, and `jspm_packages`, and defines `--plaintext`
(`.md`, `.markdown`, `.rst`, `.txt`) and `--sass` (`.sass`, `.scss`) file types. Copy it
to `~/.ackrc`. (Modern alternative: [ripgrep](https://github.com/BurntSushi/ripgrep),
which honors `.gitignore` automatically.)

### Trackpad gestures: fusuma

[`shell/.config/fusuma/config.yml`](shell/.config/fusuma/config.yml) is for
[fusuma](https://github.com/iberianpig/fusuma) on Linux (X11). Three- and four-finger
swipes switch workspaces via `xdotool key alt+ctrl+<arrow>` and pinches zoom
(`ctrl+plus`/`ctrl+minus`). `provision/linux-mint/setup.sh` installs it. Under Wayland,
`xdotool` can't send keys; use `ydotool` or the desktop environment's built-in gestures
instead.

## Git configuration

### .gitconfig

[`shell/.gitconfig`](shell/.gitconfig):

| Setting | Effect |
| ------- | ------ |
| `core.editor = vim` | Commit message editor |
| `core.ignorecase = false` | Detect case-only renames (matters on case-insensitive macOS filesystems) |
| `core.excludesfile = ~/.gitignore_global` | Global ignore list |
| `grep.lineNumber`, `grep.extendRegexp` | `git grep` shows line numbers and uses ERE |
| `color.*` | Colored branch/diff/status output with custom colors |
| `filter "lfs"` | Git LFS smudge/clean filters (what `git lfs install` writes) |
| `push.default = current` | `git push` pushes the current branch to a same-named remote branch, even if no upstream is set |
| `url."git@github.com:".insteadOf` | Rewrites `https://github.com/` to SSH for every fetch and push |

Aliases (use as `git <alias>`):

| Alias | Command | Use |
| ----- | ------- | --- |
| `c`   | `commit` | |
| `s`   | `status` | |
| `d`   | `diff` | |
| `b`   | `branch --sort=committerdate` | branches, most recent last |
| `g`   | `grep --break --heading --line-number` | grouped `git grep` output |
| `prune` | `fetch origin --prune` | drop remote-tracking branches deleted on origin |
| `ls`  | one line per commit: hash, date, author, subject, refs | |
| `ll`  | colored log with per-file line counts (`--numstat`) | |
| `search <regex>` | case-insensitive ERE search of commit messages | `git search 'fix.*login'` |
| `changes` | your commit subjects on `HEAD` that aren't on `develop` | release notes |
| `contributions` | every commit you authored, with timestamps | |
| `flow` | your commits with `--stat` | "what did I do this week" |

The last three filter on `--author="codenameyau"`; change it to your own name or email.
More git recipes are in [docs/git.md](docs/git.md).

### .gitignore_global

[`shell/.gitignore_global`](shell/.gitignore_global) ignores, in every repository:
`node_modules`, `jspm_packages`, `bower_components`, `artillery_report*`, Python
bytecode (`*.py[cod]`), `*.egg`, `venv`, `.sass-cache`, `*.css.map`, `*.sqlite*`,
`.cache`, editor backups (`*~`), JetBrains `.idea*`, `.DS_Store`, and `thumbs.db`.

Keep this list to things specific to *your machine and tools* (OS cruft, editor files).
Project build output belongs in each project's own `.gitignore` so collaborators get it
too. Check why a file is ignored with `git check-ignore -v <path>`.

### Git hooks

[`git-hooks/`](git-hooks) holds hooks named `<git-hook-name>--<purpose>`. To use one,
copy it into a repo's `.git/hooks/` under the bare hook name and make it executable.
Each file's header has install instructions.

| Hook | Install as | What it does |
| ---- | ---------- | ------------ |
| [`post-commit--dotfiles`](git-hooks/post-commit--dotfiles) | `.git/hooks/post-commit` in this repo (done by `setup.sh`) | After a commit here, copies each changed bash, zsh, and git dotfile in `shell/` to `$HOME`, if that file already exists there. Open a new terminal afterwards. |
| [`post-merge--npm`](git-hooks/post-merge--npm) | `.git/hooks/post-merge` | After `git pull`/`git merge`, runs `npm install && npm prune` if `package.json` changed |
| [`post-merge--yarn`](git-hooks/post-merge--yarn) | `.git/hooks/post-merge` | Runs `yarn install` if `yarn.lock` changed |
| [`pre-push--env`](git-hooks/pre-push--env) | `.git/hooks/pre-push` | Blocks a push if a `process.env.FOO` used in `src/**/*.js` isn't listed in `app.json` and `.env-template` |

```bash
cp git-hooks/post-merge--npm /path/to/repo/.git/hooks/post-merge && chmod +x /path/to/repo/.git/hooks/post-merge
```

Hooks in `.git/hooks/` are local and are not committed or shared. To version hooks
inside a project, keep them in a tracked directory and point git at it with
`git config core.hooksPath .githooks`. Skip hooks for one command with
`git commit --no-verify` / `git push --no-verify`.

## Command-line utilities (bin/)

Extension-less executables. Add `bin/` to `PATH` (see [Quick start](#quick-start)) or
symlink individual scripts into `~/.local/bin` or `/usr/local/bin`.

| Script | Usage | Description | Requires |
| ------ | ----- | ----------- | -------- |
| [`check-env-vars`](bin/check-env-vars) | `check-env-vars` | Finds `process.env.*` used in `src/` and `server/` JS files and reports any missing from `app.json`, `template.env`, and `canary-public-env/*.env`. Exits 1 if any are missing. | git |
| [`find-unique`](bin/find-unique) | `find-unique 'datatron-\w+'` | Unique regex matches under `app/` | grep |
| [`git-https-to-ssh`](bin/git-https-to-ssh) | `git-https-to-ssh` | Converts `origin` from `https://github.com/u/r(.git)` to `git@github.com:u/r.git` | git |
| [`heroku-prebuild`](bin/heroku-prebuild) | run as a Heroku prebuild step | Appends a GitHub Packages registry entry and `$GITHUB_PACKAGE_REGISTRY_TOKEN` to `.npmrc` | |
| [`mac-lookup`](bin/mac-lookup) | `mac-lookup D0:B2:C4:3E:8C:9F` | Looks up a MAC address vendor in the IEEE OUI list; downloads it to `/var/lib/ieee-data/oui.txt` on first run (sudo, about 6 MB) | wget |
| [`otp.py`](bin/otp.py) | `otp.py` | Prints a new random base32 secret and the current TOTP code for a hard-coded example secret | `pip install pyotp` |
| [`quick-deploy`](bin/quick-deploy) | `quick-deploy` | Clean-tree check, then back-merges `master` → `staging` → `edge` and promotes `edge` → `staging` → `master`, pushing each | git |
| [`quick-release`](bin/quick-release) | `quick-release [patch\|minor\|major]` | Promotes `staging` → `master`, bumps the version with `yarn version`, then back-merges down to `edge` | git, yarn v1 |
| [`rename-all`](bin/rename-all) | `rename-all Starter Badass` | Renames files starting with `$1` and replaces `$1` with `$2` inside every file under `.` | GNU `sed` |
| [`rename-mp3`](bin/rename-mp3) | `rename-mp3` | Lowercases `**/*.mp3`, strips `ft.`, turns spaces/dashes into `-`. Prints a dry run, then renames. | Perl `rename`, bash 4+ |
| [`resize-img`](bin/resize-img) | `resize-img -w 900` or `-h 700` | Resizes every `.jpg`/`.png` in the current directory **in place**, keeping the aspect ratio | ImageMagick (`mogrify`) |
| [`snap-clean`](bin/snap-clean) | `sudo snap-clean` | Removes disabled (old) snap revisions to free disk space | snapd |
| [`vpnautoconnect`](bin/vpnautoconnect) | see script header | Brings up the first NetworkManager VPN connection; meant for `/etc/network/if-up.d/` | nmcli |

Things to know before running them:

- `rename-all` and `git-replace` edit files in place with no undo. Commit or stash first.
- On macOS, `sed -i` needs an argument (`sed -i ''`). Install GNU sed
  (`brew install gnu-sed`, run as `gsed`) or use Linux.
- `rename-mp3` needs the Perl `rename` (Debian/Ubuntu: `sudo apt install rename`;
  macOS: `brew install rename`), not the util-linux `rename` that Fedora/Arch ship.
- `quick-deploy`, `quick-release`, `check-env-vars`, and `heroku-prebuild` were written
  for a specific job's `master`/`staging`/`edge` workflow and file layout.
- `vpnautoconnect`: `/etc/network/if-up.d/` is used by ifupdown. On systems where
  NetworkManager manages the network (most desktops), put it in
  `/etc/NetworkManager/dispatcher.d/` instead.

## Other scripts (scripts/)

| Path | Description |
| ---- | ----------- |
| [`exercises/fizzbuzz`](scripts/exercises/fizzbuzz) | FizzBuzz 1–100 using `$(( ))` arithmetic |
| [`exercises/rand-phone`](scripts/exercises/rand-phone) | `rand-phone 5` prints 5 random `(123) 456-7890` numbers (`shuf`, `sed` groups) |
| [`exercises/mouse-circle`](scripts/exercises/mouse-circle) | WIP: compute circle coordinates around the mouse with `xdotool` and `bc` |
| [`workflow/deploy`](scripts/workflow/deploy) | `deploy patch\|minor\|major`: back-merge `master` → `staging` → `edge`, tag a version with `yarn version` |
| [`open-source/git-lfs-install.sh`](scripts/open-source/git-lfs-install.sh) | packagecloud's apt/yum repository installer for git-lfs |
| [`open-source/googliser.sh`](scripts/open-source/googliser.sh) | [googliser](https://github.com/teracow/googliser): bulk Google Images downloader (GPLv3). Google's markup changes often, so it may no longer work. |
| [`open-source/kill-ipcs`](scripts/open-source/kill-ipcs) | Removes your user's System V shared memory segments, semaphores, and message queues (`ipcs`/`ipcrm`) |

## Editors

| Editor | Files | Details |
| ------ | ----- | ------- |
| Vim | [`vim/.vimrc`](vim/.vimrc) | Vundle plugins, 2-space indents, smartcase search, `jj`/`kk` to leave insert mode. See [vim/README.md](vim/README.md). |
| VS Code | [`vscode/`](vscode) | User settings, a Node attach debug config, and an extension list. See [vscode/readme.md](vscode/readme.md). |
| Sublime Text | [`sublime/preferences`](sublime/preferences) | Copy into `Preferences.sublime-settings`: 2-space tabs, 80-column ruler, trim trailing whitespace, newline at EOF, Vintage mode disabled. |

Sublime's user settings file lives at:

- macOS: `~/Library/Application Support/Sublime Text/Packages/User/Preferences.sublime-settings`
- Linux: `~/.config/sublime-text/Packages/User/Preferences.sublime-settings`

(Sublime Text 3 uses `Sublime Text 3` / `sublime-text-3` in those paths.) The
`color_scheme` references a SublimeLinter theme that must be installed for it to apply.

## Machine provisioning

| File | What it does |
| ---- | ------------ |
| [`provision/README.md`](provision/README.md) | Manual checklist: apps, SSH/GPG keys, Dock and keyboard settings, iTerm2, Python and Ruby setup |
| [`provision/osx/setup.sh`](provision/osx/setup.sh) | Installs Homebrew, oh-my-zsh, CLI packages (`coreutils`, `git`, `jq`, `shellcheck`, `fzf`, `gnu-sed`, ...), Node via `n`, global npm/pip tools, zsh-kubectl-prompt, and the vim config; downloads the zsh and git dotfiles from GitHub |
| [`provision/osx/config.sh`](provision/osx/config.sh) | `defaults write` tweaks: screenshots as PNG on the Desktop, no sleep on AC power, Finder extensions/status bar/path bar, no `.DS_Store` on network/USB drives, auto-hide Dock with no delay, no Space reordering, no recent apps in the Dock |
| [`provision/linux-mint/setup.sh`](provision/linux-mint/setup.sh) | `build-essential`, git from the git-core PPA, git-lfs, snapd, Heroku CLI, `xsel`, `terminator`, `jq`, Node.js, Brave, fusuma gestures, and the bash dotfiles |
| [`provision/iterm2-profile.json`](provision/iterm2-profile.json) | iTerm2 profile. Import via *Settings → Profiles → Other Actions → Import JSON Profiles*. |

Read these scripts before running them; [provision/README.md](provision/README.md) lists
what each step does. They are safe to re-run: steps that are already done are skipped.
`config.sh` asks for your login password (to set the screen lock) and restarts the Dock,
Finder, and menu bar when it finishes.

## Reference docs

Notes collected in [`docs/`](docs) and [`reference/`](reference):

| Topic | Doc |
| ----- | --- |
| **Dotfiles concepts**: startup files, symlinks vs Stow vs bare repo vs chezmoi, secrets, XDG, macOS defaults, testing | [docs/dotfiles.md](docs/dotfiles.md) |
| **Bash scripting**: PATH, safe mode, expansions, tests, loops, functions, redirection, debugging, colors | [docs/bash.md](docs/bash.md) |
| Bash syntax reference (from Greg's Wiki) | [reference/bash-sheet.md](reference/bash-sheet.md) |
| Git recipes: log search, diffs, stashes, merge bases, amending, ignoring changes | [docs/git.md](docs/git.md) |
| Multiple GitHub accounts with SSH host aliases | [docs/multiple-ssh.md](docs/multiple-ssh.md) |
| Cron syntax and running Node from crontab | [docs/cron.md](docs/cron.md) |
| Terminal and app keyboard shortcuts | [docs/keyboard-shortcuts.md](docs/keyboard-shortcuts.md) |
| Networking basics, MAC addresses, ARP | [docs/computer-networks.md](docs/computer-networks.md) |
| tcpdump | [docs/tcpdump.md](docs/tcpdump.md) |
| HTTPie | [docs/httpie.md](docs/httpie.md) |
| RESTful API design | [docs/restful-api.md](docs/restful-api.md) |
| nginx local reverse proxy, HSTS | [docs/nginx.md](docs/nginx.md) |
| Caddy reverse proxy with local HTTPS | [docs/caddy.md](docs/caddy.md) |
| Raspberry Pi headless setup and configuration | [docs/raspberrypi.md](docs/raspberrypi.md) |
| Pi-hole DNS ad blocking | [docs/pi-hole.md](docs/pi-hole.md) |
| Linux boot time and fstab UUIDs | [docs/speed-up-boot.md](docs/speed-up-boot.md) |
| rsync | [docs/rsync.md](docs/rsync.md) |
| Pen-testing tools | [docs/pen-testing.md](docs/pen-testing.md) |
| Auth0 | [docs/auth0.md](docs/auth0.md) |

## Caveats

Things to be aware of that are by design or not worth changing:

- **Copy, not symlink.** See [Keeping configs in sync](#keeping-configs-in-sync).
- **Job-specific scripts.** `quick-deploy`, `quick-release`, `check-env-vars`,
  `heroku-prebuild`, `scripts/workflow/deploy`, `ggg`, and `tickets` assume a particular
  `master`/`staging`/`edge` branch layout, file names, or Jira projects.
- **GNU vs BSD tools.** `rename-all` and `git-replace` use GNU `sed -i`, and the `.bashrc`
  aliases assume GNU `ls`/`dircolors`. On macOS use `gsed` (`brew install gnu-sed`).
- **oh-my-zsh git plugin.** `.zshrc` now loads it, which adds
  [its aliases](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git) (`gco`,
  `gst`, `gcm`, ...). The aliases defined later in `.zshrc` take precedence for the names
  they share: in particular `gl` is `git log --no-merges` here, not oh-my-zsh's
  `git pull`.
- **Vundle** still works but hasn't had a release in years; see
  [vim/README.md](vim/README.md) for alternatives.
- **Provisioning scripts aren't tested end to end** on a fresh machine. They were
  updated for current macOS (15) and Linux Mint/Ubuntu, but read them before running.

## Customizing for yourself

If you fork this repo:

1. In `shell/.gitconfig`, change `[user]` and the `--author="codenameyau"` filters, and
   remove the `[url "git@github.com:"]` block if you don't use SSH for GitHub.
2. Remove the `tickets` function (Jira project keys and URL) and `ggg` (branch names).
3. Replace the `raw.githubusercontent.com/codenameyau/...` URLs in `provision/` with your
   fork.
4. Put machine-specific settings and secrets (API tokens, work proxies, `AWS_PROFILE`)
   in `~/.zshrc.local`. `.zshrc` sources it last, and it isn't in the repo.
5. Lint shell changes before committing:
   ```bash
   shellcheck bin/* git-hooks/* setup.sh update.sh provision/*/*.sh
   ```
   ```bash
   zsh -n shell/.zshrc && bash -n shell/.bashrc
   ```

## License

[GNU General Public License v3.0](LICENSE).
