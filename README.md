# dotfiles

My collection of dotfiles.

Installation steps
```bash
git clone git@github.com:codenameyau/dotfiles.git
./setup.sh
```

## Extending path

Add all scripts to your unix `$PATH`. This allows you to add any directory
to be part of the bash executable path.

```
# Add the following line in your .bashrc (linux) / .bash_profile (OS X)
export PATH="<bash-scripts-path-bin>":$PATH

# Example:
export PATH="~/.bash-scripts/bin":$PATH
```


## Adding script to run in terminal path

Here's how you can individually run a script globally in your terminal.

### Method 1: Bin Executable
Add the script to your local bin directory with executable permission.

```bash
cd /usr/local/bin
sudo wget <script-url>
sudo chmod 770 <script-name>
```

### Method 2: Symbolic Link

```bash
sudo ln -s <file> /usr/local/bin/<file>
sudo chmod 770 /usr/local/bin/<file>
```

### Method 3: Aliases
If you don't have root permission, you can create an alias in your `.bashrc`:

```bash
alias <alias-name>='<script-path>'
```
