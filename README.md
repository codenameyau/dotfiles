# dotfiles

## Table of Contents
- [Bash Essentials](#bash-essentials)
  * [Debugging Scripts](#debugging-scripts)
  * [Brace Expansion](#brace-expansion)
  * [String Manipulation](#string-manipulation)
  * [Arithmetic Expressions](#arithmetic-expressions)
  * [Compound Commands](#compound-commands)
  * [Output Redirection](#output-redirection)
- [Nifty Terminal Commands](#nifty-terminal-commands)
  * [Generate Timestamps](#generate-timestamps)
- [Running Scripts from Anywhere](#running-scripts-from-anywhere)
  * [Method 1: Bin Executable](#bin-executable)
  * [Method 2: Symbolic Link](#symbolic-link)
  * [Method 3: Aliases](#aliases)
  * [Method 4: Extend Path](#extend-path)
- [Miscellaneous](#miscellaneous)
- [Bash Reference Sheet](https://mywiki.wooledge.org/BashSheet)

## Bash Essentials
This is the holy grail of bash reference sheeets:
https://mywiki.wooledge.org/BashSheet

### Debugging Scripts
- [Guide to bash debugging](https://mywiki.wooledge.org/BashGuide/Practices#Debugging)
- [Always quote variables](https://mywiki.wooledge.org/BashGuide/Practices#Quoting)

**Method 1:** Run your script with the `-x` flag.
```bash
$ bash -x myscript.sh
```

**Method 2:** Modify the script's interpreter directive to include the `-x` flag.
```bash
#!/bin/bash -x
```

**Method 3:** Selectively debug sections of code.
```bash
#!/bin/bash

# Turn on debugging.
set -x

# Turn off debugging.
set +x
```

### Brace Expansion
- https://unix.stackexchange.com/questions/6035/when-do-you-use-brace-expansion

```bash
# Rename file (no spaces between commas).
mv myfile.{js,jsx}

# Create files with different extension.
touch myfile.{html,css,js,test.js,stories.js}
```

### String Manipulation
- https://mywiki.wooledge.org/BashFAQ/100
- http://tldp.org/LDP/abs/html/string-manipulation.html

```bash
# Initialize variable with default value.
fruit=${1:-'orange'}

# String interpolation with variables.
echo "I want to eat $fruit"
> I want to eat orange

# Better string interpolation.
echo "I want to eat ${fruit}s"
> I want to eat oranges
```

```bash
# Capturing substring in regex group match.
string="origin  https://github.com/USERNAME/REPOSITORY.git (fetch)"

# Capture matched substring USERNAME
echo $(expr "$string" : .*github.com/'\(.*\)'/)
> USERNAME

# Capture matched substring REPOSITORY
echo $(expr "$string" : .*/'\(.*\).git')
> REPOSITORY
```

### Arithmetic Expressions
- Tutorial: https://mywiki.wooledge.org/ArithmeticExpression
- Full reference: http://wiki.bash-hackers.org/syntax/arith_expr

```bash
# Wrap expression with double parens to specify math context.
echo $((1 + 1))
> 2

echo $((3 < 2))
> 0

echo $((1 < 2))
> 1

# Using for loop. Spaces are allowed for assignment.
for ((i = 0; i < 10; i++)); do echo "$1"; done
```

### Compound Commands
- https://mywiki.wooledge.org/BashGuide/CompoundCommands
- https://mywiki.wooledge.org/BashGuide/TestsAndConditionals#Grouping_Statements

**SubShell:* will launch the command in subshell where cd and variables are not remembered.
It is always good practice to exit 1 if a directory doesn't exist and
will terminate the subshell but not the main shell.

```bash
(cd /tmp || exit 1; date > timestamp)
```

**Grouping Statements:** you can use short circuiting with guard `&&` and
default `||` statements for basic command grouping.

```bash
# Will exit the shell if cd exists.
cd /tmp && exit 1

# Will exit the shell if cd does not exist.
cd /tmp || exit 1
```

**Grouping Commands:** you can group commands with `{}` which you typically use
to run a series of commands whose final output would be piped to another command.

```bash
{command_1; command_2; command_3} | command_4
```

### Output Redirection


## Nifty Terminal Commands

### Generate Timestamps
- https://stackoverflow.com/questions/1204669/how-can-i-generate-unix-timestamps

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

## Miscellaneous

Your program's configuration files are stored here. They are not removed by apt purge.
```
cd ~/./config
```

