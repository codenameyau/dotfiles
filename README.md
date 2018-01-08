# dotfiles

## Table of Contents
- [Nifty Terminal Commands](#nifty-terminal-commands)
  * [Brace Expansion](#brace-expansion)
  * [Expressions](#expressions)
  * [Generate Timestamps](#generate-timestamps)

- [Running Scripts from Anywhere](#running-scripts-from-anywhere)
  * [Method 1: Bin Executable](#bin-executable)
  * [Method 2: Symbolic Link](#symbolic-link)
  * [Method 3: Aliases](#aliases)
  * [Method 4: Extend Path](#extend-path)

## Nifty Terminal Commands

### Brace Expansion
https://unix.stackexchange.com/questions/6035/when-do-you-use-brace-expansion
```bash
# Rename file (no spaces between commas).
mv myfile.{js,jsx}

# Create files with different extension.
touch myfile.{html,css,js,test.js,stories.js}
```

### Expressions
http://tldp.org/LDP/abs/html/string-manipulation.html

```bash
# Capturing substring in regex group match.
string="origin  https://github.com/USERNAME/REPOSITORY.git (fetch)"

# Capture the substring USERNAME
echo $(expr "$string" : .*github.com/'\(.*\)'/)

# Capture the substring REPOSITORY
echo $(expr "$string" : .*/'\(.*\).git')
```

### Generate Timestamps
https://stackoverflow.com/questions/1204669/how-can-i-generate-unix-timestamps

```bash
# Timestamp: Thu Dec 28 10:44:45 EST 2017
date

# Timestamp: 1514475851 (seconds)
date +%s

# Timestamp: 1514476017560 (milliseconds)
date +%s%3N

# Timestamp: 1514476088710684990 (nanoseconds)
date +%s%N
```

## Running Scripts from Anywhere

First you will need executable permission to run a script.

```bash
# Check to see what permissions files havev. Colors indicate permissions.
ls -la

# Grant user executable permission.
sudo chmod u+x <file-or-dir>
sudo chmod u+x script.sh

# Then run the script.
./script.sh
```

### Bin Executable
Add the script to your local bin directory with executable permission.

```bash
sudo chmod u+x <file>
sudo cp <file> /usr/local/bin/
```

### Symbolic Link
https://stackoverflow.com/questions/1951742/how-to-symlink-a-file-in-linux

```bash
sudo chmod u+x <file>

# Create a new symbolic link (will fail if already exist).
sudo ln -s <file> /usr/local/bin/<symlink-name>

# Create or update symbolic link.
sudo ln -sf <file> /usr/local/bin/<symlink-name>

# Example
sudo ln -s /usr/local/android-studio/bin/studio.sh /usr/local/bin/android-studio
```

### Aliases
If you don't have root permission, you can create an alias in your `.bashrc`

```bash
alias <alias-name>='<script-path>'
```

### Extend Path

You can also add any directory to be part of the bash executable path: `$PATH`

```bash
# Add the following line in your .bashrc (linux) / .bash_profile (OS X)
export PATH="<my-directory>":$PATH

# Example
export PATH="~/Workspace/dotfiles/bin":$PATH
```
