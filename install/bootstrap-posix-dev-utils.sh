#!/usr/bin/env bash

DOT_REPO=https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles
declare -a DOT_FILES=(".alias" ".bash_profile" ".bashrc" ".exports" \
                      ".functions" ".gdbinit" ".gitconfig" ".inputrc" \
                      ".prompt" ".tmux.conf" ".vimrc")

echo "==> Symlinking dotfiles from ${DOT_REPO}"
for file in $(find dotfiles -maxdepth 1 -type f); do
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

echo "==> Installing diff-so-fancy"
wget -O /usr/local/bin/diff-so-fancy \
  https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy
chmod +x ${HOME}/bin/diff-so-fancy

echo "==> Installing git bash completion"
curl -LSso "${HOME}/.git-completion.bash" \
https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "==> Installing vim thirdparty plugins"
VIM_AUTOLOAD=${HOME}/.vim/autoload
VIM_BUNDLE=${HOME}/.vim/bundle
VIM_COLORS=${HOME}/.vim/colors
VIM_SYNTAX=${HOME}/.vim/syntax
VIM_AIRLINE_THEMES=${VIM_BUNDLE}/vim-airline-themes/autoload/airline/themes
mkdir -p ${VIM_AUTOLOAD} ${VIM_BUNDLE} ${VIM_COLORS} ${VIM_SYNTAX}
curl -LSso ${VIM_AUTOLOAD}/pathogen.vim https://tpo.pe/pathogen.vim
echo "====> Symlinking global .ycm_extra_conf"
ln -s $(pwd)/dotfiles/.ycm_extra_conf.py ${HOME}/.vim/
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
echo "====> Installing vim-cpp-enhanced-highlight"
git clone https://github.com/octol/vim-cpp-enhanced-highlight ${VIM_BUNDLE}/vim-cpp-enhanced-highlight
echo "====> Installing vim-fugitive plugin"
git clone git://github.com/tpope/vim-fugitive.git ${VIM_BUNDLE}/vim-fugitive
echo "====> Installing vim-fugitive stash extension"
wget -O ${HOME}/.vim/plugin/fugitive-stash.vim \
  https://raw.githubusercontent.com/MobiusHorizons/fugitive-stash.vim/master/plugin/fugitive-stash.vim
echo "====> Installing vim-dispatch plugin"
git clone git://github.com/tpope/vim-dispatch.git ${VIM_BUNDLE}/vim-dispatch
echo "====> Installing vim-gitgutter plugin"
git clone git://github.com/airblade/vim-gitgutter.git ${VIM_BUNDLE}/vim-gitgutter
echo "====> Installing DoxygenToolkit plugin"
git clone https://github.com/vim-scripts/DoxygenToolkit.vim.git ${VIM_BUNDLE}/DoxygenToolkit
echo "====> Installing YouCompleteMe plugin (fork featuring C/C++ hints)"
git clone --recursive https://github.com/oblitum/YouCompleteMe.git ${VIM_BUNDLE}/YouCompleteMe
pushd ${VIM_BUNDLE}/YouCompleteMe && ./install.py --clang-completer && popd
echo "====> Installing vim-headerguard plugin"
git clone https://github.com/drmikehenry/vim-headerguard.git ${VIM_BUNDLE}/vim-headerguard
echo "====> Installing vim-cmake-syntax plugin"
git clone git://github.com/nickhutchinson/vim-cmake-syntax.git ${VIM_BUNDLE}/vim-cmake-syntax
echo "====> Installing vim-markdown-preview plugin"
git clone https://github.com/JamshedVesuna/vim-markdown-preview.git ${VIM_BUNDLE}/vim-markdown-preview
echo "====> Installing gnuplot syntax highlighting"
wget -O ${VIM_SYNTAX}/gnuplot.vim \
  https://raw.githubusercontent.com/vim-scripts/gnuplot-syntax-highlighting/master/syntax/gnuplot.vim

echo "==> Installing VIM color themes from ${DOT_REPO}"
wget --quiet "${DOT_REPO}/colors/newproggie.vim" -O "${VIM_COLORS}/newproggie.vim"
wget --quiet "${DOT_REPO}/colors/vim-airline-themes/newproggie.vim" -O \
    "${VIM_AIRLINE_THEMES}/newproggie.vim"
