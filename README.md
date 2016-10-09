# dotfiles

My collection of dotfiles. 

### gitignore
```bash
#####################################################################
# PROJECT FILES
#####################################################################


#####################################################################
# JAVASCRIPT
#####################################################################

# PACKAGE MANAGEMENT
node_modules
jspm_packages
bower_components

# TEST COVERAGE
lib-cov
coverage
build/reports
test/e2e/dist
/export

# BUILD TOOLS
.grunt
dist

# BINARY
build/Release

# LOAD TESTING
artillery_report*


#####################################################################
# PYTHON
#####################################################################
*.py[cod]
*.egg


#####################################################################
# SASS / CSS
#####################################################################
.sass-cache
*.css.map


#####################################################################
# MISCELLANEOUS FILES
#####################################################################

# DATABASE
*.sqlite*

# TEMP / CACHE
temp
.cache
*.spec
*.tmp
*~

# IDE
.idea*

# RUNTIME DATA
pids
*.pid
*.seed

# LOGS
[Ll]og*
*.log

# OS CRUFT
.DS_Store
.DS_STORE
thumbs.db

# DEVOPS
.vagrant
*.retry
```

### gitconfig
```bash
[user]
  email = codenameyau@gmail.com
  name = Jorge Yau

[core]
  editor = vim
  ignorecase = false
  excludesfile = ~/.gitignore_global

[alias]
  g = grep --break --heading --line-number
  s = status
  d = diff
  ls = log --abbrev-commit --no-merges --pretty='%C(green)(%cr) %Cred%h%Creset - %s%C(bold blue)<%an>%Creset %C(yellow)%d%Creset'
  ll = log --no-merges --pretty='\n\n%C(bold yellow)[%cn] %C(bold red)(%cr) %C(bold green)%s' --decorate --numstat
  search = log --no-merges -i -E --pretty='%Cred%h %C(green)(%cr)%Creset - %s %C(bold blue)<%an>%Creset%C(yellow)%d%Creset' --grep
  contributions = log --no-merges --author="codenameyau" --pretty='%C(bold blue)%ad %C(bold green)- %s' --date=format:'%b %d %Y (%I:%M %p)'
  flow = log --no-merges --author="codenameyau" --stat --pretty='\n\n%C(bold blue)[%h] %C(bold yellow)%ad (%cr) %C(green)- %s' --date=format:'%b %d %Y'

[grep]
  lineNumber = true
  extendRegexp = true

[color]
  ui = true
  interactive = auto
  branch = auto
  diff = auto
  status = auto

[color "branch"]
  current = green bold
  local = green
  remote = red bold

[color "diff"]
  meta = yellow bold ul
  frag = cyan bold ul
  old = red bold
  new = green bold

[color "status"]
  added = green bold
  changed = yellow bold
  untracked = red bold

[filter "lfs"]
  smudge = git-lfs smudge %f
  required = true
  clean = git-lfs clean %f
```
