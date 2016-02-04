# if not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# add `~/bin` to the PATH variable
export PATH="$HOME/bin:$PATH";

# load the shell dotfiles, and then some:
# ~/.path can be used to extend PATH
# ~/.extra can be used for other settings we don't want to commit
for file in ~/.{path,prompt,inputrc,exports,alias,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# append to the Bash history file, rather than overwriting it
shopt -s histappend;

# autocorrect typos in path names when using `cd`
shopt -s cdspell;

# check window size after each command and update LINES and COLUMNS
shopt -s checkwinsize

# enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in {autocd,nocaseglob,globstar}; do
    shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew > /dev/null && [ -f "$(brew --prefix)/share/bash-completion/bash_completion" ]; then
    source "$(brew --prefix)/share/bash-completion/bash_completion";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;
