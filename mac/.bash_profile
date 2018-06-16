# ~/.bash_profile: executed by the command interpreter for login shells.

# When bash starts it first looks in /etc/profile
# /etc/profile stores default commands for every user.
# Create three new files in our home directory:
#     .bash_profile
#     .bashrc
#     .bash_logout
#
# .bash_profile is automatically run (by /etc/profile ??)
# thus, source .bashrc from .bash_profile
# .bash_profile is run automatically upon exit (by /etc/bash_profile??)

# If regular file .bashrc exists, then source it
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# if running bash
# if [ -n "$BASH_VERSION" ]; then
#     # include .bashrc if it exists
#     if [ -f "$HOME/.bashrc" ]; then
# 	. "$HOME/.bashrc"
#     fi
# fi

# ruby virtual environments
if which rbenv > /dev/null; then eval "$(rbenv init -)"; fi

# where rbenv lives?
export PATH=/usr/local/bin:$PATH
