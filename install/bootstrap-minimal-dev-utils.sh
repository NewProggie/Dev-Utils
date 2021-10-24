#!/usr/bin/env bash

# shellcheck disable=SC1090

DOT_REPO=https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles

# Check required tools
commands=(git curl)
for cmd in ${commands[*]}; do
  if ! command -v ${cmd} &> /dev/null; then
    echo "${cmd} does not exist. Exiting!"
    exit 1
  fi
done

echo "==> Symlinking dotfiles from ${DOT_REPO}"
dotfiles=(dotfiles/.tmux.conf dotfiles/.bashrc dotfiles/.gdbinit dotfiles/.exports \
  dotfiles/.prompt dotfiles/.git_commit_template.txt dotfiles/.vimrc dotfiles/.emacs \
  dotfiles/.ycm_extra_conf.py dotfiles/.functions dotfiles/.alias dotfiles/.bash_profile \
  dotfiles/.inputrc dotfiles/.gitconfig)
for file in ${dotfiles[*]}; do
  home_dotfile="${HOME}/$(basename "${file}")"
  if [ -e "${home_dotfile}" ]; then
    echo "====> Backup ${home_dotfile} to ${home_dotfile}.old"
    mv "${home_dotfile}" "${home_dotfile}.old"
  fi
  echo "====> Symlinking ${home_dotfile}"
  curl -LSso "${home_dotfile}" \
    https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/${file}
done
source "${HOME}/.bash_profile"
unset file

echo "==> Installing git bash completion"
curl -LSso "${HOME}/.git-completion.bash" \
  https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "==> Installing vim thirdparty plugins"
VIM_AUTOLOAD="${HOME}"/.vim/autoload
VIM_BUNDLE="${HOME}"/.vim/bundle
VIM_COLORS="${HOME}"/.vim/colors
VIM_SYNTAX="${HOME}"/.vim/syntax
VIM_PLUGIN="${HOME}"/.vim/plugin
VIM_AIRLINE_THEMES=${VIM_BUNDLE}/vim-airline-themes/autoload/airline/themes
mkdir -p "${VIM_AUTOLOAD}" "${VIM_BUNDLE}" "${VIM_COLORS}" "${VIM_SYNTAX}" \
  "${VIM_PLUGIN}" "${VIM_AIRLINE_THEMES}"
curl -LSso "${VIM_AUTOLOAD}"/pathogen.vim https://tpo.pe/pathogen.vim
echo "====> Installing vim-sensible plugin"
git clone https://github.com/tpope/vim-sensible.git "${VIM_BUNDLE}"/vim-sensible
echo "====> Installing nerdtree plugin"
git clone https://github.com/scrooloose/nerdtree.git "${VIM_BUNDLE}"/nerdtree
echo "====> Installing ctrl-P plugin"
git clone https://github.com/ctrlpvim/ctrlp.vim "${VIM_BUNDLE}"/ctrlp.vim
echo "====> Installing vim-airline plugin"
git clone https://github.com/vim-airline/vim-airline.git "${VIM_BUNDLE}"/vim-airline
echo "====> Installing vim-airline-themes plugin"
git clone https://github.com/vim-airline/vim-airline-themes "${VIM_BUNDLE}"/vim-airline-themes

echo "==> Installing VIM color themes from ${DOT_REPO}"
curl -LSso "${VIM_COLORS}/newproggie.vim" "${DOT_REPO}/colors/newproggie.vim"
curl -LSso "${VIM_AIRLINE_THEMES}/newproggie.vim" \
  "${DOT_REPO}/colors/vim-airline-themes/newproggie.vim"

