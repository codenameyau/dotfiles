# dotfiles


### Dotfiles installation

```bash
git clone git@github.com:codenameyau/dotfiles.git
./setup.sh
```

## How to run script in terminal

You will need executable permission to run a script.

```bash
# Run ls to see what permissions a file has. Colors indicate permissions.
ls -la

# Grant user executable permission and run the file.
sudo chmod u+x <file-or-dir>
./<file>

# Example:
sudo chmod u+x script.sh
./script.sh
```

Here's how you can run a script globally in your terminal.

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
```

#### Method 3: Aliases
If you don't have root permission, you can create an alias in your `.bashrc`

```bash
alias <alias-name>='<script-path>'
```

### Extending path

You can also add any directory to be part of the bash executable path: `$PATH`

```bash
# Add the following line in your .bashrc (linux) / .bash_profile (OS X)
export PATH="<my-directory>":$PATH

# Example:
export PATH="~/dotfiles/scripts/bin":$PATH
```
