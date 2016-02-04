#!/bin/sh
DOT_REPO=https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles
declare -a DOT_FILES=(".path" ".prompt" ".inputrc" ".exports" ".alias" \
                      ".functions" ".extra")

echo "==> Installing dotfiles from ${DOT_REPO}"
for file in "${DOT_FILES[@]}"; do
    home_dot_file="${HOME}/${file}" 
    repo_dot_file="${DOT_REPO}/${file}"
    if [ -e "${home_dot_file}" ]; then
        echo "====> Backup ${home_dot_file} to ${home_dot_file}.old"
        wget "${repo_dot_file}" -O "${home_dot_file}"
    fi
done
unset file;
