#####################################################################
# ZSH CONFIGURATION
#####################################################################

# Enable glob patterns: (case insesitive, matching)
setopt EXTENDED_GLOB

# Wait before running rm *.
setopt RM_STAR_WAIT

# Enables changing dir without cd.
setopt AUTO_CD

# Ignore duplicate entries in history.
setopt HIST_IGNORE_ALL_DUPS


#####################################################################
# SHELL CONFIGURATION
#####################################################################

# Source environment variables.
source ~/.shell_envs

# Source custom shell alias.
source ~/.shell_alias
