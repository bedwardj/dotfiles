# ~/.bashrc: executed by bash(1) for non-login shells.

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Special characters
# \h	the hose name up to the first .
# \n	new line
# \s	the name of the shell
# \t	the currnt time in 24-hour format
# \u	the username of the current user
# \w	the current working directory
# \W	the basename of the current working directory

# PROMPT
# Based on https://github.com/mathiasbynens/dotfiles/blob/master/.bash_prompt

prompt_git() {
    local s='';
    local branchName='';

    # Check if the current directory is in a Git repository.
    if [ $(git rev-parse --is-inside-work-tree &>/dev/null; echo "${?}") == '0' ]; then

        # check if the current directory is in .git before running git checks
        if [ "$(git rev-parse --is-inside-git-dir 2> /dev/null)" == 'false' ]; then

            # Ensure the index is up to date.
            git update-index --really-refresh -q &>/dev/null;

            # Check for uncommitted changes in the index.
            if ! $(git diff --quiet --ignore-submodules --cached); then
                s+='+';
            fi;

            # Check for unstaged changes.
            if ! $(git diff-files --quiet --ignore-submodules --); then
                s+='!';
            fi;

            # Check for untracked files.
            if [ -n "$(git ls-files --others --exclude-standard)" ]; then
                s+='?';
            fi;

            # Check for stashed files.
            if $(git rev-parse --verify refs/stash &>/dev/null); then
                s+='$';
            fi;

        fi;

        # Get the short symbolic ref.
        # If HEAD isn’t a symbolic ref, get the short SHA for the latest commit
        # Otherwise, just give up.
        branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
            git rev-parse --short HEAD 2> /dev/null || \
            echo '(unknown)')";

        [ -n "${s}" ] && s=" [${s}]";

        echo -e "${1}${branchName}${2}${s}";
    else
        return;
    fi;
    }

# Colors
bold=$(tput bold);
yellow=$(tput setaf 228);
orange=$(tput setaf 166);
green=$(tput setaf 71);
reset=$(tput sgr0);

blue=$(tput setaf 33);
violet=$(tput setaf 61);
white=$(tput setaf 15);

# Set the terminal title and prompt.
PS1="\[\033]0;\W\007\]"; # working directory base name
PS1+="\[${bold}\]";  # Bold is not working in WSL Ubuntu
PS1+="\[${yellow}\]\u ";  # username
PS1+="\[${reset}\]at ";
PS1+="\[${orange}\]\h ";  # hostname
PS1+="\[${reset}\]in ";
PS1+="\[${green}\]\W";  # working directory
PS1+="\$(prompt_git \"\[${reset}\] on \[${violet}\]\" \"\[${blue}\]\")"; # Git repository details
PS1+="\n";
PS1+="\[${reset}\]$ ";
export PS1;

# This does not appear to have any effect on WSL Ubuntu prompt.
PS2="\n\[${yelloe}\]→ \[${reset}\]";
export PS2;

# Set up ssh-agent
env=~/.ssh/agent.env

agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

agent_start () {
    (umask 077; ssh-agent >| "$env")
    . "$env" >| /dev/null ; }

agent_load_env

# agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
    agent_start
    ssh-add
elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
    ssh-add
fi

unset env
