# if not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# add `~/bin` to the PATH variable
export PATH="$HOME/bin:$PATH";

# export GOPATH for local workspace
export GOPATH=$HOME/bin

# Export correct locale settings
export LC_ALL=de_DE.UTF-8
export LANG=de_DE.UTF-8

# load the shell dotfiles, and then some:
# ~/.path can be used to extend PATH
# ~/.extra can be used for other settings we don't want to commit
for file in ~/.{alias,exports,functions,inputrc,path,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Adjust path prompt to be similar to bash style
setopt PROMPT_SUBST
PROMPT='%n@%m: ${(%):-%~} '

# Set Emacs mode
bindkey -e
