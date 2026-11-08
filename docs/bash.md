# bash

A practical guide to bash for scripting and everyday terminal work. Examples target
bash 4+ unless noted. macOS ships bash **3.2** at `/bin/bash` (Apple stopped updating
it because of the GPLv3 license); run `brew install bash` for a current version, and use
`#!/usr/bin/env bash` so scripts pick it up from `PATH`.

## Helpful Resources

- [GNU Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html), the official reference
- [BashGuide](https://mywiki.wooledge.org/BashGuide) and [BashFAQ](https://mywiki.wooledge.org/BashFAQ) on Greg's Wiki, the best tutorial-style sources
- [BashSheet](https://mywiki.wooledge.org/BashSheet), with an annotated copy in [reference/bash-sheet.md](../reference/bash-sheet.md)
- [BashPitfalls](https://mywiki.wooledge.org/BashPitfalls), common mistakes and their fixes
- [ShellCheck](https://www.shellcheck.net/), a linter that catches most of those pitfalls (`brew install shellcheck` / `apt install shellcheck`)
- [explainshell.com](https://explainshell.com/), which breaks down what each part of a command does
- `help <builtin>` (e.g. `help set`) and `man bash` for offline docs

## Table of Contents

- [Running Scripts from Anywhere](#running-scripts-from-anywhere)
  - [Shebang and permissions](#shebang-and-permissions)
  - [Bin directory](#bin-directory)
  - [Symbolic link](#symbolic-link)
  - [Aliases](#aliases)
  - [Extend PATH](#extend-path)
- [Script Configurations](#script-configurations)
  - [Bash strict mode](#bash-strict-mode)
  - [Other set options](#other-set-options)
  - [shopt options](#shopt-options)
- [Quoting](#quoting)
- [Brace Expansion](#brace-expansion)
- [Variable Expansion](#variable-expansion)
  - [String interpolation](#string-interpolation)
  - [Default values](#default-values)
  - [Pattern matching](#pattern-matching)
  - [Substrings, length, replacement, case](#substrings-length-replacement-case)
  - [Regex group matching](#regex-group-matching)
- [Arrays](#arrays)
- [Arithmetic Expressions](#arithmetic-expressions)
- [Tests and Conditionals](#tests-and-conditionals)
- [Loops](#loops)
- [Functions](#functions)
- [Script Arguments](#script-arguments)
- [Compound Commands](#compound-commands)
  - [Grouping with && and ||](#grouping-with--and-)
  - [Subshells](#subshells)
  - [Command groups](#command-groups)
- [Redirection and Pipes](#redirection-and-pipes)
- [Exit Codes, Traps, and Cleanup](#exit-codes-traps-and-cleanup)
- [Networks](#networks)
- [Nifty Terminal Commands](#nifty-terminal-commands)
  - [Timestamps](#timestamps)
  - [Set operations](#set-operations)
  - [Rerunning commands](#rerunning-commands)
- [Miscellaneous](#miscellaneous)
  - [Config files](#config-files)
  - [Colors](#colors)
  - [Debugging scripts](#debugging-scripts)
- [Script Template](#script-template)

## Running Scripts from Anywhere

### Shebang and permissions

The first line (the *shebang*) picks the interpreter. The file also needs execute
permission.

```bash
#!/usr/bin/env bash
```

```bash
# Check permissions: look for x in -rwxr--r--.
ls -l script.sh

# Give your user execute permission (no sudo needed for files you own).
chmod u+x script.sh

# Run it from the current directory.
./script.sh

# Or run it without execute permission by naming the interpreter.
bash script.sh
```

`./script.sh` runs the script in a **new process**, so variables and `cd` inside it don't
affect your shell. `source script.sh` (or `. script.sh`) runs it **in the current
shell**, which is how `.bashrc` and similar files are loaded.

### Bin directory

Executables in a directory on your `PATH` can be run by name. By convention they have
no file extension.

```bash
# Per-user, no sudo needed (add ~/.local/bin to PATH if it isn't already).
mkdir -p ~/.local/bin && cp script ~/.local/bin/

# System-wide.
sudo cp script /usr/local/bin/
```

On Apple Silicon Macs, `/usr/local/bin` may not exist and Homebrew uses
`/opt/homebrew/bin`; prefer `~/.local/bin`.

### Symbolic link

A symlink keeps a single copy of the script (e.g. in this repo) and exposes it on
`PATH`. Edits to the original take effect immediately.

```bash
# Create a symbolic link (fails if the link already exists).
ln -s "$PWD/sherlock.py" ~/.local/bin/sherlock

# Create or replace a symbolic link.
ln -sf "$PWD/sherlock.py" ~/.local/bin/sherlock

# Example
sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio

# See where a link points.
readlink ~/.local/bin/sherlock
```

The link stores the path exactly as you typed it, so use an absolute target (`$PWD/...`)
unless you specifically want a relative link.

### Aliases

Add to `~/.bashrc` (or `~/.zshrc`):

```bash
alias deploy='~/Workspace/dotfiles/scripts/workflow/deploy'
```

Aliases only work in interactive shells, can't take positional arguments (`$1`), and
are expanded when a line is read. Use a function when you need arguments:

```bash
mkcd() { mkdir -p "$1" && cd "$1"; }
```

Check what a name resolves to with `type mkcd`, `type -a ls`, or `command -v git`.

### Extend PATH

```bash
# In ~/.bash_profile, ~/.bashrc, or ~/.zshrc.
export PATH="$HOME/Workspace/dotfiles/bin:$PATH"
```

- Use `$HOME`, not `~`, inside double quotes: `"~/bin"` is **not** expanded and adds a
  literal `~/bin` directory to `PATH`.
- Directories earlier in `PATH` win. Prepend to override system tools, append to fall
  back to them.
- After installing something new, run `hash -r` (bash) or `rehash` (zsh) if the shell
  keeps finding the old location.

Print one entry per line:

```bash
tr ':' '\n' <<< "$PATH"
```

## Script Configurations

`set -o <option>` turns an option on and `set +o <option>` turns it off. Short forms:
`set -e` / `set +e`. `set -o` with no argument lists current settings.

### Bash strict mode

```bash
set -Eeuo pipefail
```

| Option | Long form | Effect |
| ------ | --------- | ------ |
| `-e` | `errexit` | Exit when a command fails (non-zero status). Does not apply to commands in `if`/`while` conditions, or anything left of `&&`/`\|\|`. |
| `-u` | `nounset` | Treat an unset variable as an error. Use `${VAR:-}` when a variable is optional. |
| `-o pipefail` | | A pipeline fails if *any* command in it fails, not only the last one. |
| `-E` | `errtrace` | `ERR` traps also fire inside functions and subshells. |

`set -e` has many surprising edge cases (see
[BashFAQ/105](https://mywiki.wooledge.org/BashFAQ/105)): for example, `local x=$(false)`
does not exit because `local` itself succeeds. Treat it as a safety net, and check
important commands explicitly:

```bash
cd "$dir" || { echo "cannot cd to $dir" >&2; exit 1; }
```

### Other set options

```bash
# Automatically export every variable that gets assigned.
set -o allexport   # e.g. before `source .env`, then `set +o allexport`

# Print each command before running it (debugging).
set -x

# Don't let > overwrite existing files (use >| to force).
set -o noclobber

# Enable command history (on by default in interactive shells).
set -o history

# Switch command-line editing to vi keys (default is emacs).
set -o vi
```

Loading a `.env` file into the environment:

```bash
set -o allexport; source .env; set +o allexport
```

### shopt options

```bash
shopt -s globstar     # ** matches files in all subdirectories (bash 4+)
shopt -s nullglob     # a glob with no matches expands to nothing instead of itself
shopt -s extglob      # extended patterns: !(*.js), +(a|b), @(x|y)
shopt -s nocaseglob   # case-insensitive globbing
shopt -s histappend   # append to history instead of overwriting it
shopt -s checkwinsize # update LINES/COLUMNS after each command
shopt                 # list all
```

## Quoting

Quoting is the main source of shell bugs. The rule: **always double-quote expansions**
(`"$var"`, `"$(cmd)"`, `"${arr[@]}"`) unless you specifically want word splitting and
glob expansion.

```bash
file="my report.txt"

rm $file      # WRONG: tries to remove "my" and "report.txt"
rm "$file"    # right

echo '$HOME'  # single quotes: everything literal  -> $HOME
echo "$HOME"  # double quotes: expands variables   -> /Users/you
echo $'a\tb'  # ANSI-C quoting: escape sequences   -> a<TAB>b
```

## Brace Expansion

Brace expansion generates strings *before* any other expansion. It isn't globbing; the
files don't need to exist. No spaces are allowed around the commas.

```bash
# Rename a file.
mv myfile.{js,jsx}            # mv myfile.js myfile.jsx

# Make a backup.
cp config.yml{,.bak}          # cp config.yml config.yml.bak

# Create files with different extensions.
touch myfile.{html,css,js,test.js,stories.js}

# Sequences, with optional step and zero padding.
echo {1..5}                   # 1 2 3 4 5
echo {0..20..5}               # 0 5 10 15 20
echo {01..03}                 # 01 02 03
echo {a..e}                   # a b c d e

# Cartesian products.
echo {a,b,c}/{1,2,3} | xargs -n1
mkdir -p ./{ComponentA,ComponentB}/{test,stories}
mkdir -p ./{1..5}/{1..5}
```

Ranges can't come from variables (`{1..$n}` doesn't work). Use `seq 1 "$n"` or a C-style
`for` loop.

## Variable Expansion

- [BashFAQ/100: string manipulation](https://mywiki.wooledge.org/BashFAQ/100)
- [Shell Parameter Expansion (GNU manual)](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)

### String interpolation

```bash
fruit=orange
echo "I want to eat $fruit"
> I want to eat orange

# Braces separate the name from the following text.
echo "I want to eat ${fruit}s"
> I want to eat oranges
```

Assignments have **no spaces** around `=`: `fruit = orange` runs a command called
`fruit`.

### Default values

| Syntax | If `var` is unset or empty |
| ------ | -------------------------- |
| `${var:-default}` | use `default` (doesn't assign) |
| `${var:=default}` | assign `default` to `var` and use it |
| `${var:?message}` | print `message` to stderr and exit |
| `${var:+alt}` | use `alt` only if `var` **is** set (otherwise empty) |

Without the colon (`${var-default}`), only *unset* triggers the default; an empty value
is kept.

```bash
fruit=${1:-orange}
echo "I want to eat ${fruit}s"
> I want to eat oranges

: "${API_KEY:?API_KEY must be set}"
```

### Pattern matching

`#` removes from the start and `%` from the end. Doubling them (`##`, `%%`) makes the
match greedy (longest match).

```bash
url='https://github.com/codenameyau/intro-to-bash'

# Remove the shortest match of */*/ from the start: user and repo.
echo "${url#*//*/}"
> codenameyau/intro-to-bash

# Remove the longest match of */ from the start: the last path segment (like basename).
echo "${url##*/}"
> intro-to-bash

# Remove the shortest match of /* from the end: the user profile URL (like dirname).
echo "${url%/*}"
> https://github.com/codenameyau

# Remove two segments from the end: the origin.
echo "${url%/*/*}"
> https://github.com

# Remove the longest match of ://* from the end: the protocol.
echo "${url%%://*}"
> https

# File extensions.
file=archive.tar.gz
echo "${file%.*}"    # archive.tar
echo "${file%%.*}"   # archive
echo "${file##*.}"   # gz
```

### Substrings, length, replacement, case

```bash
s="hello world"

echo "${#s}"            # 11 (length)
echo "${s:0:5}"         # hello (offset 0, length 5)
echo "${s: -5}"         # world (note the space before -)
echo "${s/o/0}"         # hell0 world (first match)
echo "${s//o/0}"        # hell0 w0rld (all matches)
echo "${s/#hello/bye}"  # bye world (only at start)
echo "${s^^}"           # HELLO WORLD (bash 4+)
echo "${s^}"            # Hello world
echo "${s,,}"           # hello world

# Strip colons from a MAC address and take the vendor prefix (see bin/mac-lookup).
mac="D0:B2:C4:3E:8C:9F"
prefix=${mac//:/}
echo "${prefix:0:6}"
> D0B2C4

# Indirect expansion: the value of the variable named by $name.
name=HOME; echo "${!name}"
```

### Regex group matching

Bash's `=~` operator inside `[[ ]]` uses POSIX extended regex and puts capture groups
in `BASH_REMATCH`. Store the regex in a variable to avoid quoting problems.

```bash
string="origin  https://github.com/USERNAME/REPOSITORY.git (fetch)"
re='github\.com/([^/]+)/([^/ ]+)\.git'

if [[ $string =~ $re ]]; then
  echo "${BASH_REMATCH[1]}"   # USERNAME
  echo "${BASH_REMATCH[2]}"   # REPOSITORY
fi
```

The older POSIX `expr` form (used in [bin/git-https-to-ssh](../bin/git-https-to-ssh))
anchors at the start of the string and returns the `\( \)` group:

```bash
expr "$string" : '.*github.com/\(.*\)/'
> USERNAME

expr "$string" : '.*/\(.*\)\.git'
> REPOSITORY
```

## Arrays

```bash
# Indexed arrays.
fruits=(apple banana "dragon fruit")
echo "${fruits[0]}"        # apple
echo "${fruits[@]}"        # all elements, each as a separate word when quoted
echo "${#fruits[@]}"       # 3
fruits+=(cherry)           # append
for f in "${fruits[@]}"; do echo "$f"; done
echo "${!fruits[@]}"       # indices: 0 1 2 3

# Read lines of output into an array (bash 4+).
mapfile -t files < <(git ls-files '*.sh')

# Associative arrays (bash 4+).
declare -A port=([http]=80 [https]=443)
echo "${port[https]}"      # 443
for k in "${!port[@]}"; do echo "$k=${port[$k]}"; done
```

`"${arr[@]}"` expands to one word per element; `"${arr[*]}"` joins all elements into a
single word (separated by the first character of `IFS`).

## Arithmetic Expressions

- [Tutorial: ArithmeticExpression](https://mywiki.wooledge.org/ArithmeticExpression)

`$(( ))` evaluates integer math and expands to the result. `(( ))` evaluates without
output and sets the exit status (0 if the result is non-zero), which makes it useful in
`if` and `while`.

```bash
echo $((1 + 1))
> 2

echo $((7 / 2)) $((7 % 2)) $((2 ** 10))
> 3 1 1024

echo $((3 < 2))
> 0

echo $((1 < 2))
> 1

# Variables don't need $ inside (( )).
count=0
((count++))
((count += 5))

if ((count > 3)); then echo "big"; fi

# C-style for loop; spaces are allowed inside (( )).
for ((i = 0; i < 10; i++)); do echo "$i"; done
```

Bash only does integer math. For decimals, use `bc` or `awk`:

```bash
echo "scale=2; 10 / 3" | bc
> 3.33

awk 'BEGIN { printf "%.2f\n", 10 / 3 }'
> 3.33
```

Under `set -e` in bash 4.1 and later, `((count++))` exits the script when `count` was 0,
because the expression evaluates to 0 (false). macOS's bash 3.2 doesn't exit, so a
script can work on a Mac and fail on Linux. Use `count=$((count + 1))` instead.

## Tests and Conditionals

- [BashGuide: Tests and Conditionals](https://mywiki.wooledge.org/BashGuide/TestsAndConditionals)

`[[ ... ]]` is a bash keyword: it doesn't word-split variables, supports `&&`, `||`,
`=~`, and glob patterns, and is the recommended form in bash. `[ ... ]` is the POSIX
`test` command: portable to `sh`, but variables must be quoted and `<`/`>` are treated as
redirections.

```bash
# Numbers: -eq -ne -lt -le -gt -ge, or (( )).
if [[ $a -lt $b ]]; then echo "less"; fi
if ((a < b)); then echo "less"; fi

# Strings: = (or ==), !=, and < > for lexical (dictionary) order.
if [[ $name == "admin" ]]; then echo "hi admin"; fi
if [[ $file == *.txt ]]; then echo "text file"; fi   # glob match (unquoted right side)
if [[ -z $var ]]; then echo "empty"; fi
if [[ -n $var ]]; then echo "not empty"; fi

# Files.
[[ -e $p ]]   # exists
[[ -f $p ]]   # regular file
[[ -d $p ]]   # directory
[[ -L $p ]]   # symlink
[[ -r $p ]]   # readable    (-w writable, -x executable)
[[ -s $p ]]   # size > 0
[[ $a -nt $b ]]  # a is newer than b

# Commands: if checks the exit status directly.
if grep -q "TODO" notes.md; then echo "has todos"; fi
if command -v brew >/dev/null; then echo "brew installed"; fi
```

Inside `[[ ]]`, `<` compares strings, not numbers: `[[ 10 < 9 ]]` is **true** because
`"1"` sorts before `"9"`. Use `-lt` or `(( ))` for numbers.

```bash
is_less_than() {
  if (( $1 < $2 )); then echo 1; else echo 0; fi
}

is_less_than 1 2   # 1
is_less_than 10 9  # 0
```

With single brackets, `[ "$1" < "$2" ]` redirects from a file named `$2`. Use `-lt`,
or `\<` for a string comparison. These are equivalent:

```bash
if [ "$1" -lt "$2" ]; then echo 1; fi
if test "$1" -lt "$2"; then echo 1; fi
```

`case` is cleaner than a chain of `elif` for matching patterns:

```bash
case "$1" in
  start|up)   echo "starting" ;;
  stop)       echo "stopping" ;;
  *.tar.gz)   echo "archive" ;;
  *)          echo "usage: $0 {start|stop}" >&2; exit 1 ;;
esac
```

## Loops

```bash
# Over words or a list.
for f in *.jpg; do echo "$f"; done

# Over a range.
for i in {1..5}; do echo "$i"; done

# Read a file line by line. IFS= keeps leading spaces; -r keeps backslashes.
while IFS= read -r line; do
  echo "$line"
done < file.txt

# Read command output line by line.
while IFS= read -r branch; do
  echo "$branch"
done < <(git branch --format='%(refname:short)')

# Loop until something succeeds.
until curl -fs localhost:8080/health >/dev/null; do sleep 1; done
```

- Don't loop over `$(ls)` or `$(find ...)`: filenames with spaces get split. Use globs,
  or `find ... -print0 | while IFS= read -r -d '' f; do ...; done`.
- `cmd | while read ...` runs the loop in a subshell, so variables set inside are lost
  when it ends. Use `while ...; done < <(cmd)` (process substitution) to keep them.
- `break` and `continue` work as in other languages.

## Functions

These are all the ways to declare a function. The first, POSIX form is preferred.

```bash
echo_hello1() {
  echo "${1:-hello world}"
}

function echo_hello2 {
  echo "${1:-hello world 2}"
}

function echo_hello3() {
  echo "${1:-hello world 3}"
}

echo_hello1 "lol"
echo_hello2 "lol"
echo_hello3 "lol"
```

- Arguments are `$1`, `$2`, ..., `"$@"` (all), and `$#` (count), the same as for scripts.
- Variables are **global** unless declared with `local`.
- `return N` sets the exit status (0–255). To "return" a value, `echo` it and capture it
  with `$(...)`.

```bash
greet() {
  local name=${1:?name required}
  echo "Hello, $name"
}

msg=$(greet "Jorge")
```

## Script Arguments

| Variable | Meaning |
| -------- | ------- |
| `$0` | Script name |
| `$1` … `$9`, `${10}` | Positional arguments |
| `$#` | Number of arguments |
| `"$@"` | All arguments, each as a separate word (use this one) |
| `"$*"` | All arguments joined into a single word |
| `$?` | Exit status of the last command |
| `$$` | PID of the current shell |
| `$!` | PID of the last background job |
| `$_` | Last argument of the previous command |

Parse short options with `getopts` (see [bin/resize-img](../bin/resize-img)):

```bash
verbose=false
while getopts ":vo:" opt; do
  case "$opt" in
    v) verbose=true ;;
    o) output=$OPTARG ;;
    :) echo "-$OPTARG requires an argument" >&2; exit 1 ;;
    \?) echo "invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
shift $((OPTIND - 1))   # "$@" is now the remaining non-option arguments
```

`getopts` only handles short options (`-v`). For `--long` options, loop over `"$@"` with
`case` and `shift`.

## Compound Commands

- [BashGuide: Compound Commands](https://mywiki.wooledge.org/BashGuide/CompoundCommands)

### Grouping with && and ||

`a && b` runs `b` only if `a` succeeds. `a || b` runs `b` only if `a` fails.

```bash
# Exits the shell if cd succeeds.
cd /tmp && exit 1

# Exits the shell if cd fails (the usual guard).
cd /tmp || exit 1

# Combine with a group to run several commands on failure.
mkdir -p build || { echo "mkdir failed" >&2; exit 1; }
```

`a && b || c` is **not** an if/else: `c` also runs when `b` fails. Use a real `if` when
that matters.

### Subshells

Commands inside `( )` run in a child process. Variable changes, `cd`, and `set` options
disappear when it finishes.

```bash
# Your shell's working directory ($PWD) is unaffected.
(cd /tmp || exit 1; date > timestamp)
```

`$(command)` (command substitution) and pipeline stages also run in subshells.

### Command groups

`{ }` groups commands in the *current* shell, sharing its variables, so their combined
output can be redirected or piped. There must be spaces inside the braces and a `;` or
newline before the closing `}`.

```bash
{ command_1; command_2; command_3; } | command_4

{ echo "# Report"; date; uptime; } > report.txt
```

## Redirection and Pipes

```bash
cmd > out.txt          # stdout to file (overwrite)
cmd >> out.txt         # stdout to file (append)
cmd 2> err.txt         # stderr to file
cmd > all.txt 2>&1     # stdout and stderr to file (order matters)
cmd &> all.txt         # same, bash shorthand
cmd 2>/dev/null        # discard errors
cmd < in.txt           # stdin from file
echo "error" >&2       # write to stderr

cmd1 | cmd2            # stdout of cmd1 to stdin of cmd2
cmd1 |& cmd2           # stdout and stderr (bash 4+)
cmd | tee out.txt      # show output and save it

# Here-doc: multi-line stdin. Quote the delimiter ('EOF') to disable expansion.
cat <<EOF > config.ini
user=$USER
home=$HOME
EOF

# Here-string.
grep -c a <<< "banana"

# Process substitution: treat command output as a file.
diff <(sort a.txt) <(sort b.txt)
```

## Exit Codes, Traps, and Cleanup

Every command returns 0 for success and 1–255 for failure. Check `$?` immediately, since
the next command overwrites it.

```bash
grep -q needle haystack.txt
echo $?   # 0 if found, 1 if not, 2 on error
```

`trap` runs code on exit or on a signal, which is the reliable way to clean up temporary
files:

```bash
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

trap 'echo "failed at line $LINENO" >&2' ERR
trap 'echo "interrupted"; exit 130' INT
```

## Networks

Find and kill whatever is using a port (see also the `kill-port` function in
[shell/.bash_aliases](../shell/.bash_aliases)):

```bash
# PID(s) listening on port 8000.
lsof -t -i :8000

kill $(lsof -t -i :8000)

# Details: command, PID, user, address.
lsof -nP -iTCP:8000 -sTCP:LISTEN
```

List listening ports:

```bash
# Linux (ss replaces netstat): TCP, UDP, listening, process, numeric.
sudo ss -tulpn

# Linux, older net-tools.
sudo netstat -tulpn

# macOS.
sudo lsof -nP -iTCP -sTCP:LISTEN
```

More in [computer-networks.md](computer-networks.md) and [tcpdump.md](tcpdump.md).

## Nifty Terminal Commands

### Timestamps

```bash
# Human readable: Thu Dec 28 10:44:45 EST 2017
date

# ISO 8601: 2017-12-28T10:44:45-05:00
date -Iseconds                  # GNU (macOS: date +%Y-%m-%dT%H:%M:%S%z)

# Unix seconds: 1514475851
date +%s

# Unix milliseconds: 1514476017560
date +%s%3N                     # GNU only; BSD/macOS prints a literal "3N"
gdate +%s%3N                    # macOS with `brew install coreutils`
python3 -c 'import time; print(int(time.time() * 1000))'   # anywhere

# Convert seconds to a date.
date -d @1514475851             # GNU
date -r 1514475851              # BSD/macOS

# Bash 5 built-ins (no subprocess).
echo "$EPOCHSECONDS" "$EPOCHREALTIME"
```

### Set operations

`comm` compares two **sorted** files and prints three columns: lines only in file1, only
in file2, and in both. `-1`, `-2`, `-3` hide those columns.

```bash
# Lines in both files.
comm -12 file1 file2

# Lines only in file1.
comm -23 file1 file2

# Lines only in file2.
comm -13 file1 file2

# Sort on the fly with process substitution.
comm -13 <(sort file1) <(sort file2)
comm -23 <(sort file1) <(sort file2)

# Paste lines, sort them, keep the ones not in s1, copy to clipboard (Ctrl+D to end input).
cat | sort | comm -13 s1 - | pbcopy
```

Other set-like idioms:

```bash
sort -u a b                 # union
sort a b | uniq -d          # intersection (if each file has no duplicates)
sort a b b | uniq -u        # a minus b
sort file | uniq -c | sort -rn | head   # most frequent lines
```

### Rerunning commands

```bash
# Rerun the previous command with sudo.
sudo !!

# Rerun the previous command with the first "before" replaced by "after".
^before^after

# Last argument of the previous command (also Alt+. / Esc+.).
cd !$

# Run the most recent command starting with "git".
!git

# Edit the previous command in $EDITOR, then run it.
fc

# Search history interactively (or use fzf, as configured in this repo).
# Press Ctrl+R and type.
```

## Miscellaneous

### Config files

Per-user application config lives in `~/.config` (`$XDG_CONFIG_HOME`), caches in
`~/.cache`, and data in `~/.local/share`. `apt purge` only removes system-wide config
under `/etc`, so these per-user directories may still hold old application data after
you uninstall something.

```bash
cd ~/.config

# Find the biggest directories.
du -sh ~/.config/* ~/.cache/* 2>/dev/null | sort -h | tail
```

See [dotfiles.md](dotfiles.md#xdg-base-directories) for more.

### Colors

- [How to change the output color of echo](https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux)

ANSI escape codes are `\033[<style>;<color>m`. Style `0` is normal, `1` bold, `4`
underline; colors `30`–`37` are foreground and `40`–`47` background.

```
Black        0;30     Dark Gray     1;30
Red          0;31     Light Red     1;31
Green        0;32     Light Green   1;32
Brown/Orange 0;33     Yellow        1;33
Blue         0;34     Light Blue    1;34
Purple       0;35     Light Purple  1;35
Cyan         0;36     Light Cyan    1;36
Light Gray   0;37     White         1;37
```

```bash
# Reset colors
Color_Off='\033[0m'       # Text Reset

# Regular colors
Black='\033[0;30m'        # Black
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue
Purple='\033[0;35m'       # Purple
Cyan='\033[0;36m'         # Cyan
White='\033[0;37m'        # White

# Bold
BBlack='\033[1;30m'       # Black
BRed='\033[1;31m'         # Red
BGreen='\033[1;32m'       # Green
BYellow='\033[1;33m'      # Yellow
BBlue='\033[1;34m'        # Blue
BPurple='\033[1;35m'      # Purple
BCyan='\033[1;36m'        # Cyan
BWhite='\033[1;37m'       # White

# Underline
UBlack='\033[4;30m'       # Black
URed='\033[4;31m'         # Red
UGreen='\033[4;32m'       # Green
UYellow='\033[4;33m'      # Yellow
UBlue='\033[4;34m'        # Blue
UPurple='\033[4;35m'      # Purple
UCyan='\033[4;36m'        # Cyan
UWhite='\033[4;37m'       # White
```

Use them with `printf` (portable) or `echo -e` (bash):

```bash
printf "${Red}error:${Color_Off} %s\n" "file not found"
```

`tput` looks up the right codes for the current terminal and is safer in scripts:

```bash
red=$(tput setaf 1); bold=$(tput bold); reset=$(tput sgr0)
echo "${bold}${red}error${reset}"
```

Only print colors when writing to a terminal, so piped output and log files stay clean:

```bash
if [[ -t 1 ]]; then Red='\033[0;31m'; Color_Off='\033[0m'; else Red=''; Color_Off=''; fi
```

In prompts (`PS1`), wrap escape codes in `\[ \]` (bash) or `%{ %}` (zsh) so the shell
calculates the prompt width correctly. Otherwise long lines wrap in the wrong place.

### Debugging scripts

- [BashGuide: Debugging](https://mywiki.wooledge.org/BashGuide/Practices#Debugging)
- [Always quote variables](https://mywiki.wooledge.org/BashGuide/Practices#Quoting)

**Method 1:** Run the script with `-x` to print every command (after expansion) before
it runs.
```bash
bash -x myscript.sh
```

**Method 2:** Add `-x` to the shebang.
```bash
#!/bin/bash -x
```

**Method 3:** Trace only part of a script.
```bash
#!/bin/bash

# Turn on tracing.
set -x

# Turn off tracing.
set +x
```

**Method 4:** Show file, line, and function in the trace output.
```bash
export PS4='+ ${BASH_SOURCE}:${LINENO}:${FUNCNAME[0]:-main}: '
bash -x myscript.sh
```

Other checks:

```bash
# Syntax check without running.
bash -n myscript.sh

# Static analysis.
shellcheck myscript.sh
```

## Script Template

A starting point that uses the practices above:

```bash
#!/usr/bin/env bash
#
# Description: what this script does.
# Usage: script-name [-v] <input>

set -Eeuo pipefail

usage() {
  echo "Usage: ${0##*/} [-v] <input>" >&2
  exit 1
}

main() {
  local verbose=false
  while getopts ":v" opt; do
    case "$opt" in
      v) verbose=true ;;
      *) usage ;;
    esac
  done
  shift $((OPTIND - 1))

  [[ $# -ge 1 ]] || usage
  local input=$1

  local tmp
  tmp=$(mktemp -d)
  trap 'rm -rf "$tmp"' EXIT

  "$verbose" && echo "processing $input" >&2
  # ...
}

main "$@"
```
