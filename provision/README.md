# provision

Steps for setting up a new machine. The scripts automate most of it; the rest is a
manual checklist. Read each script before running it. They are safe to re-run: steps
that are already done are skipped.

| File | Platform | Run with |
| ---- | -------- | -------- |
| [`osx/setup.sh`](osx/setup.sh) | macOS | `bash provision/osx/setup.sh` |
| [`osx/config.sh`](osx/config.sh) | macOS | `bash provision/osx/config.sh` (asks for your password; restarts Dock and Finder) |
| [`linux-mint/setup.sh`](linux-mint/setup.sh) | Linux Mint / Ubuntu | `bash provision/linux-mint/setup.sh` |
| [`iterm2-profile.json`](iterm2-profile.json) | macOS | Import in iTerm2 |

## Order of operations (macOS)

1. Install the Xcode Command Line Tools (gives you `git`):
   ```bash
   xcode-select --install
   ```
2. Create an SSH key and add it to GitHub (see [Dev setup](#dev-setup)).
3. Clone this repo into `~/Workspace/dotfiles`.
4. Install and configure iTerm2 (see [iTerm2](#iterm2)).
5. Run `osx/setup.sh`. It adds Homebrew to `PATH` for the rest of the script and, via
   `~/.zprofile`, for future shells (needed on Apple Silicon, where Homebrew lives in
   `/opt/homebrew`).
6. Run `osx/config.sh`.
7. Work through the manual steps below.

## What `osx/setup.sh` installs

| Step | Details |
| ---- | ------- |
| `~/Workspace` | Created if missing |
| [Homebrew](https://brew.sh) | Installed if missing; `brew shellenv` added to `~/.zprofile` |
| [oh-my-zsh](https://ohmyz.sh) | Zsh framework used by `.zshrc`; installed unattended if `~/.oh-my-zsh` is missing |
| Core packages | `coreutils` (GNU `ls`, `date`, ... as `gls`, `gdate`), `cmake`, `ack`, `wget`, `curl`, `htop`, `git`, `python3`, `ruby`, `n` (Node version manager), `pipx` |
| Terminal tools | `source-highlight` (colored `less`), `bash-completion`, `git-extras`, `shellcheck`, `gpg`, `watchman`, `jq` |
| Dotfiles | Downloads `.gitconfig`, `.gitignore_global`, `.zshrc`, `.zshrc_extras`, `.ohmyzshrc` from this repo's `master` branch on GitHub (not from your local clone), replacing existing files |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder; generates `~/.fzf.zsh` (key bindings and completion), which `.zshrc` already sources |
| `gnu-sed` | GNU `sed` as `gsed` |
| Node.js | Current LTS via `sudo n lts` |
| Python tools | `virtualenv` via `pipx` (see [Installing Python packages](#installing-python-packages)) |
| npm globals | `http-server`, `eslint`, `webpack`, `jest`, `tldr` |
| [zsh-kubectl-prompt](https://github.com/superbrothers/zsh-kubectl-prompt) | Kubernetes context in the prompt (used by `.zshrc_extras`) |
| Vim | `.vimrc`, Vundle, and plugins (see [vim/README.md](../vim/README.md)) |

## What `osx/config.sh` changes

| Area | Change |
| ---- | ------ |
| Screenshots | Saved to the Desktop as PNG |
| Power | No system sleep while on AC power (`pmset -c sleep 0`); computer sleep off |
| Finder | Show all file extensions, status bar, and path bar; search the current folder by default; no warning when changing an extension; no `.DS_Store` files on network and USB volumes; show hard drives, servers, and removable media on the desktop |
| Security | Require the password immediately after sleep or screen saver (`sysadminctl -screenLock immediate`; prompts for your password) |
| Printing | Quit the printer app when jobs finish |
| Dock | Auto-hide with no delay; show indicator lights for open apps; translucent icons for hidden apps; no recent apps; don't reorder Spaces by most recent use |
| Apply | Restarts the Dock, Finder, and SystemUIServer at the end |

Undo any setting with `defaults delete <domain> <key>`, e.g.
`defaults delete com.apple.dock autohide && killall Dock`. More on `defaults` in
[docs/dotfiles.md](../docs/dotfiles.md#macos-defaults).

## What `linux-mint/setup.sh` installs

- `build-essential`, `curl`, git from the [git-core PPA](https://launchpad.net/~git-core/+archive/ubuntu/ppa), git-lfs
- `snapd` (removing Linux Mint's default `nosnap.pref` block), the Heroku CLI, `xsel` (clipboard), `terminator`, `jq`
- Node.js LTS from [NodeSource](https://github.com/nodesource/distributions) and the `tldr` and `http-server` npm packages
- [Brave](https://brave.com/linux/) from its apt repository, with the key in `/usr/share/keyrings`
- [fusuma](https://github.com/iberianpig/fusuma) touchpad gestures: adds you to the
  `input` group (log out and back in for it to apply), installs `libinput-tools` and
  `xdotool`, downloads [the gesture config](../shell/.config/fusuma/config.yml), and
  opens *Startup Applications* so you can add `fusuma -d` to run at login
- `~/Workspace`, plus `.bash_prompt` from
  [shiny-prompt](https://github.com/codenameyau/shiny-prompt) and the bash and git
  dotfiles from GitHub

To manage several Node versions instead of the single system-wide one, use a version
manager such as [fnm](https://github.com/Schniz/fnm):
`curl -fsSL https://fnm.vercel.app/install | bash`.

## App Installation

- [LICEcap](https://www.cockos.com/licecap/): record screen areas as GIFs
- [Postman](https://www.postman.com/downloads/): API client
- [GitKraken](https://www.gitkraken.com/): git GUI
- [VS Code](https://code.visualstudio.com/): see [vscode/readme.md](../vscode/readme.md)
- [1Password](https://1password.com/): password manager; its
  [CLI](https://developer.1password.com/docs/cli/) (`op`) can supply secrets to the shell
- [iTerm2](https://iterm2.com/): terminal

With Homebrew, these are all casks:

```bash
brew install --cask licecap postman gitkraken visual-studio-code 1password 1password-cli iterm2
```

## Dev Setup

- **SSH key for GitHub** ([docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)):
  ```bash
  ssh-keygen -t ed25519 -C "you@example.com"
  ```
  ```bash
  pbcopy < ~/.ssh/id_ed25519.pub
  ```
  Paste it into *GitHub → Settings → SSH and GPG keys*, then test with
  `ssh -T git@github.com`. This is required by the `insteadOf` rule in
  [`.gitconfig`](../shell/.gitconfig). To use more than one GitHub account, see
  [docs/multiple-ssh.md](../docs/multiple-ssh.md).
- **Signed commits** ([docs](https://docs.github.com/en/authentication/managing-commit-signature-verification)):
  with GPG, or with your SSH key (simpler; see
  [docs/dotfiles.md](../docs/dotfiles.md#git-config-tips)).
- **Syntax highlighting in `less`**: `brew install source-highlight`; the `LESSOPEN`
  setup is already in `.zshrc` and `.bash_profile`
  ([background](https://ole.michelsen.dk/blog/syntax-highlight-files-macos-terminal-less/)).
- **Dotfiles and git hooks**: see the [main README](../README.md).

## Mac Setup

### Default settings

- Hide the Dock: *System Settings → Desktop & Dock → Automatically hide and show the
  Dock* (also set by `config.sh`).
- Stop Spaces from reordering by recent use: *System Settings → Desktop & Dock →
  Mission Control → Automatically rearrange Spaces based on most recent use* (off; also
  set by `config.sh`).

### Keyboard shortcuts

- Remap <kbd>Cmd</kbd>+<kbd>Q</kbd> to *Show Desktop* in *System Settings → Keyboard →
  Keyboard Shortcuts → Mission Control → Show Desktop*, so an accidental
  <kbd>Cmd</kbd>+<kbd>Q</kbd> doesn't quit the app.
- Word-by-word movement in the terminal: see [iTerm2](#iterm2) below, or
  [this answer](https://stackoverflow.com/a/81299) for Terminal.app.

![Show Desktop](https://user-images.githubusercontent.com/3826772/268161284-ec16e492-bbf7-4783-8ea4-58f7baa5990f.png)

### iTerm2

1. Install [iTerm2](https://iterm2.com/) (`brew install --cask iterm2`).
2. Import the profile: *Settings → Profiles → Other Actions… → Import JSON Profiles…* and
   choose [`iterm2-profile.json`](iterm2-profile.json). Then select it and choose *Set as
   Default*.
3. Make <kbd>Option</kbd>+<kbd>←</kbd>/<kbd>→</kbd> move by word: in *Settings →
   Profiles → Keys → Key Mappings*, map <kbd>Option</kbd>+<kbd>←</kbd> to *Send Escape
   Sequence* `b` and <kbd>Option</kbd>+<kbd>→</kbd> to *Send Escape Sequence* `f` (use
   the escape-sequence action, not *Send Hex Code*). Or pick the *Natural Text Editing*
   preset from the *Presets…* menu, which also maps <kbd>Cmd</kbd>+<kbd>←</kbd>/<kbd>→</kbd>
   to start/end of line.

More terminal shortcuts are in [docs/keyboard-shortcuts.md](../docs/keyboard-shortcuts.md).

## Python Installation

macOS no longer includes Python 2, and `/usr/bin/python3` is a stub that prompts you to
install the Command Line Tools. Homebrew's Python is installed as `python3` and `pip3`;
plain `python` and `pip` are only linked into Homebrew's `libexec/bin` directory.

```bash
brew search python            # available versions
```

```bash
brew install python           # latest
```

```bash
brew install python@3.12      # a specific version
```

To make `python` and `pip` refer to Homebrew's Python 3, add this to `~/.zprofile`:

```bash
export PATH="$(brew --prefix python)/libexec/bin:$PATH"
```

Switch which versioned formula is linked:

```bash
brew unlink python@3.13 && brew link --overwrite python@3.12
```

```bash
brew link --overwrite --dry-run python@3.12    # list files that would be overwritten
```

Homebrew's prefix is `/opt/homebrew` on Apple Silicon and `/usr/local` on Intel Macs; see
the links with `ls -l "$(brew --prefix)"/bin/python*`.

### Installing Python packages

Homebrew's Python is marked "externally managed" (PEP 668), so `pip3 install` outside a
virtual environment fails with `error: externally-managed-environment`. Instead:

- **Command-line tools:** `brew install pipx && pipx install httpie`, or
  `uv tool install httpie`.
- **Project dependencies:** a virtual environment per project:
  ```bash
  python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
  ```
  or with [uv](https://docs.astral.sh/uv/): `uv venv && uv pip install -r requirements.txt`.
- **Multiple Python versions:** [pyenv](https://github.com/pyenv/pyenv), `uv python
  install 3.12`, or [mise](https://mise.jdx.dev/).

`.ohmyzshrc` shows the active virtualenv's name in the prompt.

## Ruby Installation

macOS's system Ruby is old and shouldn't be used for development. Install a current
Ruby through a version manager. The commands below use
[rbenv](https://github.com/rbenv/rbenv); [mise](https://mise.jdx.dev/) and
[chruby](https://github.com/postmodern/chruby) + ruby-install work too.

```bash
brew install rbenv ruby-build
```

```bash
echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc && exec zsh
```

```bash
rbenv install --list          # latest stable versions
```

```bash
latest=$(rbenv install --list 2>/dev/null | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | tail -1) && rbenv install "$latest" && rbenv global "$latest"
```

```bash
ruby -v && gem install bundler rails
```

Use `rbenv local <version>` inside a project to pin it (writes `.ruby-version`).

### Legacy: RVM with Ruby 2.2 and Rails 4.2

The original instructions used [RVM](https://rvm.io/) with Ruby 2.2.7 and Rails 4.2.8.
Both versions have been end-of-life for years and Ruby 2.2 doesn't build against
current OpenSSL. They are kept only for maintaining old apps:

```bash
brew install gnupg
gpg --keyserver keyserver.ubuntu.com --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
curl -sSL https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm install ruby-2.2.7
rvm use 2.2.7 --default
rvm use ruby-2.2.7@rails4.2.8 --create
gem install rails --version=4.2.8
```

Install RVM as your user (not with `sudo`). The GPG key IDs above are the ones published
on [rvm.io/rvm/security](https://rvm.io/rvm/security); check there in case they change.
