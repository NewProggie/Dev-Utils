#!/usr/bin/env bash

# some custom functions
command_exists () {
    type "$1" &> /dev/null ;
}

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
    fi
    echo "====> Installing ${home_dot_file}"
    wget --quiet "${repo_dot_file}" -O "${home_dot_file}"
done
source "${HOME}/.bash_profile"
unset file;

echo "==> Installing vim thirdparty plugins"
VIM_AUTOLOAD=${HOME}/.vim/autoload
VIM_BUNDLE=${HOME}/.vim/bundle
mkdir -p ${VIM_AUTOLOAD} ${VIM_BUNDLE}
curl -LSso ${VIM_AUTOLOAD}/pathogen.vim https://tpo.pe/pathogen.vim

echo "====> Installing vim-sensible plugin"
git clone https://github.com/tpope/vim-sensible.git ${VIM_BUNDLE}/vim-sensible
echo "====> Installing nerdtree plugin"
git clone https://github.com/scrooloose/nerdtree.git ${VIM_BUNDLE}/nerdtree
echo "====> Installing ctrl-P plugin"
git clone https://github.com/ctrlpvim/ctrlp.vim ${VIM_BUNDLE}/ctrlp.vim
echo "====> Installing nerdcommenter plugin"
git clone https://github.com/scrooloose/nerdcommenter.git ${VIM_BUNDLE}/nerdcommenter

echo "==> [optional] Setup gnome-terminal colors using (gconftool-2 needed):"
echo "curl -s https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/scripts/smyck_gnome.sh | bash"
