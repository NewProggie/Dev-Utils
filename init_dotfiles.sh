#!/usr/bin/env bash

DOT_REPO=https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles
declare -a DOT_FILES=(".alias" ".bash_profile" ".bashrc" ".exports" \
                      ".functions" ".gdbinit" ".gitconfig" ".inputrc" \
                      ".prompt" ".tmux.conf" ".vimrc")

echo "==> Installing dotfiles from ${DOT_REPO}"
for file in "${DOT_FILES[@]}"; do
    home_dot_file="${HOME}/${file}" 
    repo_dot_file="${DOT_REPO}/${file}"
    if [ -e "${home_dot_file}" ]; then
        echo "====> Backup ${home_dot_file} to ${home_dot_file}.old"
        mv "${home_dot_file}" "${home_dot_file}.old"
        wget --quiet "${repo_dot_file}" -O "${home_dot_file}"
    fi
    source "${HOME}/.bash_profile"
done
unset file;
