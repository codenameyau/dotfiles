# dotfiles


## Nifty terminal commands

### Brace expansion
https://unix.stackexchange.com/questions/6035/when-do-you-use-brace-expansion
```bash
# Rename file (no spaces between commas).
mv myfile.{js,jsx}

# Create files with different extension.
touch myfile.{html,css,js,test.js,stories.js}
```

### Symbolic Links
https://stackoverflow.com/questions/1951742/how-to-symlink-a-file-in-linux

```bash
# Create a new symbolic link (will fail if already exist).
ln -s /path/to/file /path/to/symlink

# Create or update symbolic link.
ln -sf /path/to/file /path/to/symlink
```

## Running script anywhere from terminal

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

#### Method 1: Bin Executable
Add the script to your local bin directory with executable permission.

```bash
sudo chmod u+x <file>
sudo mv <file> /usr/local/bin/
```

#### Method 2: Symbolic Link

```bash
sudo chmod u+x <file>
sudo ln -s <file> /usr/local/bin/<file>

# Example
sudo ln -s /usr/local/android-studio/bin/studio.sh /usr/local/bin/android-studio
```

#### Method 3: Aliases
If you don't have root permission, you can create an alias in your `.bashrc`

```bash
alias <alias-name>='<script-path>'
```

#### Method 4: Extend path

You can also add any directory to be part of the bash executable path: `$PATH`

```bash
# Add the following line in your .bashrc (linux) / .bash_profile (OS X)
export PATH="<my-directory>":$PATH

# Example:
export PATH="~/dotfiles/scripts/bin":$PATH
```
