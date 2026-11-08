# vscode

Visual Studio Code configuration.

| File | Copy to | Contents |
| ---- | ------- | -------- |
| [`preferences`](preferences) | User `settings.json` | Editor, file, search, and lint settings |
| [`settings`](settings) | A project's `.vscode/settings.json` | Purple title bar and status bar, to tell this window apart from others |
| [`launch.json`](launch.json) | A project's `.vscode/launch.json` | "Attach to Backend" debug config for a running Node process |

## Installing the settings

The user `settings.json` lives at:

| OS | Path |
| -- | ---- |
| macOS | `~/Library/Application Support/Code/User/settings.json` |
| Linux | `~/.config/Code/User/settings.json` |
| Windows | `%APPDATA%\Code\User\settings.json` |

You can also open it from the Command Palette (<kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>P</kbd>)
with **Preferences: Open User Settings (JSON)**.

```bash
cp vscode/preferences ~/Library/Application\ Support/Code/User/settings.json
```

VS Code's built-in **Settings Sync** (Accounts menu → *Backup and Sync Settings*) syncs
settings, keybindings, snippets, and extensions through a GitHub or Microsoft account.
**Profiles** (*File → Preferences → Profiles*) can export a whole setup as a
`.code-profile` file or a GitHub gist.

### What `preferences` sets

| Setting | Value |
| ------- | ----- |
| `workbench.colorTheme` | Monokai |
| `editor.fontSize` | 14 |
| `editor.tabSize` | 2 (4 for Python) |
| `editor.rulers` | Column 80 |
| `editor.renderWhitespace` | `boundary` (show leading/trailing and repeated spaces) |
| `editor.multiCursorModifier` | `ctrlCmd`: add cursors with <kbd>Cmd</kbd>/<kbd>Ctrl</kbd>+click; <kbd>Alt</kbd>+click opens links |
| `editor.formatOnPaste` | on |
| `files.trimTrailingWhitespace`, `files.insertFinalNewline` | on |
| `files.exclude`, `search.exclude` | Hide `.git`, `node_modules`, `lib`, `.DS_Store`; skip `bower_components` and `coverage` in search |
| `emmet.includeLanguages`, `emmet.triggerExpansionOnTab` | Emmet in JSX and Vue templates, expanded with <kbd>Tab</kbd> |
| `eslint.run` | `onSave` |
| `telemetry.telemetryLevel` | `off` |

VS Code greys out any key it no longer recognizes in `settings.json`, which is a quick
way to spot retired settings. (`telemetry.telemetryLevel` replaced the older
`telemetry.enableTelemetry` and `telemetry.enableCrashReporter` in VS Code 1.61.)

### `launch.json`

Attaches the debugger to a Node process you pick from a list, skipping `node_modules`
and `lib` in stack traces. Start your app with `node --inspect app.js` (or
`--inspect-brk` to pause on the first line), then run **Attach to Backend** from the
Run and Debug view.

## Extensions

Copy the list of installed extensions:

```bash
code --list-extensions | pbcopy
```

Merge it with another list and remove duplicates:

```bash
pbpaste | sort -u | pbcopy
```

Install extensions from a list on the clipboard:

```bash
pbpaste | xargs -L 1 code --install-extension
```

Or save the list to a file and install from it:

```bash
code --list-extensions > vscode/extensions.txt
```

```bash
xargs -L 1 code --install-extension < vscode/extensions.txt
```

On Linux, `pbcopy`/`pbpaste` are provided by the aliases in
[shell/.bashrc](../shell/.bashrc) (using `xsel`). The `code` command needs to be on
`PATH`: in VS Code on macOS, run **Shell Command: Install 'code' command in PATH** from
the Command Palette.

### Current extensions

| Extension ID | Purpose |
| ------------ | ------- |
| `alefragnani.project-manager` | Save and switch between projects |
| `ChakrounAnas.turbo-console-log` | Insert labeled `console.log` statements |
| `christian-kohler.npm-intellisense` | Autocomplete npm module names in imports |
| `dbaeumer.vscode-eslint` | ESLint |
| `dsznajder.es7-react-js-snippets` | React/Redux snippets |
| `eamodio.gitlens` | Inline blame, history, and comparisons |
| `esbenp.prettier-vscode` | Prettier formatter |
| `fabiospampinato.vscode-diff` | Diff two files or the clipboard |
| `jpoissonnier.vscode-styled-components` | styled-components syntax highlighting |
| `hashicorp.terraform` | Terraform (replaces the deprecated `mauve.terraform`) |
| `mikestead.dotenv` | `.env` syntax highlighting |
| `ms-azuretools.vscode-docker` | Docker |
| `ms-python.python` | Python |
| `ms-vscode.atom-keybindings` | Atom keyboard shortcuts |
| `nhoizey.gremlins` | Highlight invisible and confusable Unicode characters |
| `pflannery.vscode-versionlens` | Show latest package versions in `package.json` |
| `redhat.vscode-yaml` | YAML with schema validation |
| `scala-lang.scala` | Scala syntax |
| `silvenon.mdx` | MDX |
| `timonwong.shellcheck` | ShellCheck linting for shell scripts |
| `torn4dom4n.latex-support` | LaTeX |

To install them all at once:

```bash
cat <<'EOF' | xargs -L 1 code --install-extension
alefragnani.project-manager
ChakrounAnas.turbo-console-log
christian-kohler.npm-intellisense
dbaeumer.vscode-eslint
dsznajder.es7-react-js-snippets
eamodio.gitlens
esbenp.prettier-vscode
fabiospampinato.vscode-diff
jpoissonnier.vscode-styled-components
hashicorp.terraform
mikestead.dotenv
ms-azuretools.vscode-docker
ms-python.python
ms-vscode.atom-keybindings
nhoizey.gremlins
pflannery.vscode-versionlens
redhat.vscode-yaml
scala-lang.scala
silvenon.mdx
timonwong.shellcheck
torn4dom4n.latex-support
EOF
```
