# dotfiles

## Table of Contents
- [Running Scripts from Anywhere](#running-scripts-from-anywhere)
  - [Bin Executable](#bin-executable)
  - [Symbolic Link](#symbolic-link)
  - [Aliases](#aliases)
  - [Extend Path](#extend-path)
- [Bash Essentials](#bash-essentials)
  - [Set Arguments](#set-arguments)
  - [Debugging Scripts](#debugging-scripts)
  - [Brace Expansion](#brace-expansion)
  - [String Manipulation](#string-manipulation)
  - [Arithmetic Expressions](#arithmetic-expressions)
  - [Compound Commands](#compound-commands)
  - [Output Redirection](#output-redirection)
- [Nifty Terminal Commands](#nifty-terminal-commands)
  - [Generate Timestamps](#generate-timestamps)
  - [Ports](#ports)
  - [Set Operations](#set-operations)
- [Miscellaneous](#miscellaneous)
  - [Config Files](#config-files)
  - [Colors](#colors)

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
sudo ln -s /opt/android-studio/bin/studio.sh /usr/local/bin/android-studio
```

### Aliases
If you don't have root permission, you can create an alias in your `.bashrc`

```bash
alias <alias-name>='<script-path>'
```

### Extend Path

You can also add any directory to be part of the bash executable path: `$PATH`

```bash
# Add the following line in your `.bash_profile`.
export PATH="<my-directory>":$PATH

# Example
export PATH="~/Workspace/dotfiles/bin":$PATH
```


## Bash Essentials
This is the holy grail of bash reference sheeets:
https://mywiki.wooledge.org/BashSheet

### Set Arguments
Use `set -o` to turn on a feature and `set +o` to turn it off.

```bash
# Bash strict mode shorthand notation.
set -euo pipefail

# Exit script if you try to use an uninitialized variable.
set -o nounset

# Exit script if a statement returns a non-true return value.
set -o errexit

# Use the error status of the first failure rather than last item in a pipe.
set -o pipefail

# Export any variables that are defined.
set -o allexport
```

```
# Enable bash history.
set -o history
```

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
```

### Ports
Run this command kill a process running on specific port.
```bash
lsof -t -i :8000

kill $(lsof -t -i :8000)
```

Run this command to see a list of open ports on a system.

```bash
# Show tcp, udp, listening ports, pid, numeric hosts, ipv4
sudo netstat -tulpn4
```

### Set Operations

These operations must have files sorted first.

```bash
# Get lines common to both files.
comm -12 file1 file2

# Read from std-in, sort, get lines in common, and copy to clipboard.
cat | sort | comm -13 - s1 | pbcopy

# Get lines only found in file1.
comm -23 file1 file2

# Sort files as well.
comm -13 <(sort file1) <(sort file2)
comm -23 <(sort file1) <(sort file2)
```

## Miscellaneous

### Config Files
Your program's configuration files are stored here. They are not removed by apt purge
and may often contain unnecessary application data.
```
cd ~/./config
```

### Colors
https://stackoverflow.com/questions/5947742/how-to-change-the-output-color-of-echo-in-linux

```bash
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
