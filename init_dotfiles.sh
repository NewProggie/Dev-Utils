#!/usr/bin/env bash

DOT_REPO=https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles
declare -a DOT_FILES=(".alias" ".bash_profile" ".bashrc" ".exports" \
                      ".functions" ".gdbinit" ".gitconfig" ".inputrc" \
                      ".prompt" ".tmux.conf" ".vimrc")

echo "==> Symlinking dotfiles from ${DOT_REPO}"
for file in $(find dotfiles/ -maxdepth 1 -type f); do
    home_dotfile="${HOME}/$(basename ${file})"
    if [ -e "${home_dotfile}" ]; then
        echo "====> Backup ${home_dotfile} to ${home_dotfile}.old"
        mv "${home_dotfile}" "${home_dotfile}.old"
    fi
    echo "====> Symlinking ${home_dotfile}"
    ln -s $(pwd)/${file} ${home_dotfile}
done
source "${HOME}/.bash_profile"
unset file

echo "==> Installing git bash completion"
curl -LSso "${HOME}/.git-completion.bash" \
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "==> Installing vim thirdparty plugins"
VIM_AUTOLOAD=${HOME}/.vim/autoload
VIM_BUNDLE=${HOME}/.vim/bundle
if [[ "${OSTYPE}" == "darwin"* ]]; then
    # YouCompleteMe doesn't work in a multi-os env such as Linux/OSX
    VIM_BUNDLE=${HOME}/.vim/bundle_osx
fi
VIM_COLORS=${HOME}/.vim/colors
VIM_AIRLINE_THEMES=${VIM_BUNDLE}/vim-airline-themes/autoload/airline/themes
mkdir -p ${VIM_AUTOLOAD} ${VIM_BUNDLE} ${VIM_COLORS}
curl -LSso ${VIM_AUTOLOAD}/pathogen.vim https://tpo.pe/pathogen.vim

echo "====> Installing vim-sensible plugin"
git clone https://github.com/tpope/vim-sensible.git ${VIM_BUNDLE}/vim-sensible
echo "====> Installing nerdtree plugin"
git clone https://github.com/scrooloose/nerdtree.git ${VIM_BUNDLE}/nerdtree
echo "====> Installing ctrl-P plugin"
git clone https://github.com/ctrlpvim/ctrlp.vim ${VIM_BUNDLE}/ctrlp.vim
echo "====> Installing nerdcommenter plugin"
git clone https://github.com/scrooloose/nerdcommenter.git ${VIM_BUNDLE}/nerdcommenter
echo "====> Installing tagbar plugin"
git clone https://github.com/majutsushi/tagbar.git ${VIM_BUNDLE}/tagbar
echo "====> Installing vim-airline plugin"
git clone https://github.com/vim-airline/vim-airline.git ${VIM_BUNDLE}/vim-airline
echo "====> Installing vim-airline-themes plugin"
git clone https://github.com/vim-airline/vim-airline-themes ${VIM_BUNDLE}/vim-airline-themes
echo "====> Installing vim-fugitive plugin"
git clone git://github.com/tpope/vim-fugitive.git ${VIM_BUNDLE}/vim-fugitive
echo "====> Installing vim-gitgutter plugin"
git clone git://github.com/airblade/vim-gitgutter.git ${VIM_BUNDLE}/vim-gitgutter
echo "====> Installing YouCompleteMe plugin (fork featuring C/C++ hints)"
git clone --recursive https://github.com/oblitum/YouCompleteMe.git ${VIM_BUNDLE}/YouCompleteMe
pushd ${VIM_BUNDLE}/YouCompleteMe && ./install.py --clang-completer && popd

echo "==> Installing VIM color themes from ${DOT_REPO}"
wget --quiet "${DOT_REPO}/colors/newproggie.vim" -O "${VIM_COLORS}/newproggie.vim"
wget --quiet "${DOT_REPO}/colors/vim-airline-themes/newproggie.vim" -O \
    "${VIM_AIRLINE_THEMES}/newproggie.vim"
