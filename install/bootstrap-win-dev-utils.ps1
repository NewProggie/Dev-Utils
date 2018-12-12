$DOT_REPO = "https://raw.githubusercontent.com/NewProggie/Dev-Utils/master/dotfiles"
$DOT_FILES = @(".alias", ".bash_profile", ".bashrc", ".exports", ".functions")
$DOT_FILES += @(".gdbinit", ".gitconfig", ".inputrc", ".prompt", ".tmux.conf")
$DOT_FILES += @(".git_commit_template.txt", ".vimrc")

Write-Host "==> Copying dotfiles from ${DOT_REPO}"
$dotfile_path = Split-Path -Path $PSScriptRoot -Parent
foreach($element in $DOT_FILES) {
    Write-Host "====> Copying $dotfile_path\dotfiles\$element to ${HOME}"
    Copy-Item "$dotfile_path\dotfiles\$element" ${HOME}
}

Write-Host "==> Installing vim thirdparty plugins"
$VIM_AUTOLOAD = "${HOME}\vimfiles\autoload"
$VIM_BUNDLE = "${HOME}\vimfiles\bundle"
$VIM_COLORS = "${HOME}\vimfiles\colors"
$VIM_SYNTAX = "${HOME}\vimfiles\syntax"
$VIM_PLUGIN = "${HOME}\vimfiles\plugin"
$VIM_AIRLINE_THEMES= "${VIM_BUNDLE}\vim-airline-themes\autoload\airline\themes"
New-Item $VIM_AUTOLOAD -ItemType Directory -Force
New-Item $VIM_BUNDLE -ItemType Directory -Force
New-Item $VIM_COLORS -ItemType Directory -Force
New-Item $VIM_SYNTAX -ItemType Directory -Force
New-Item $VIM_PLUGIN -ItemType Directory -Force
New-Item $VIM_AIRLINE_THEMES -ItemType Directory -Force
Invoke-WebRequest -Uri https://tpo.pe/pathogen.vim -OutFile $VIM_AUTOLOAD\pathogen.vim

Write-Host "Copying global .ycm_extra_conf"
Copy-Item "$dotfile_path\dotfiles\.ycm_extra_conf.py" "${HOME}\vimfiles"
Write-Host "====> Installing vim-sensible plugin"
git clone https://github.com/tpope/vim-sensible.git ${VIM_BUNDLE}\vim-sensible
Write-Host "====> Installing nerdtree plugin"
git clone https://github.com/scrooloose/nerdtree.git ${VIM_BUNDLE}\nerdtree
Write-Host "====> Installing ctrl-P plugin"
git clone https://github.com/ctrlpvim/ctrlp.vim ${VIM_BUNDLE}\ctrlp.vim
Write-Host "====> Installing nerdcommenter plugin"
git clone https://github.com/scrooloose/nerdcommenter.git ${VIM_BUNDLE}\nerdcommenter
Write-Host "====> Installing tagbar plugin"
git clone https://github.com/majutsushi/tagbar.git ${VIM_BUNDLE}\tagbar
Write-Host "====> Installing vim-airline plugin"
git clone https://github.com/vim-airline/vim-airline.git ${VIM_BUNDLE}\vim-airline
Write-Host "====> Installing vim-airline-themes plugin"
git clone https://github.com/vim-airline/vim-airline-themes ${VIM_BUNDLE}\vim-airline-themes
Write-Host "====> Installing vim-cpp-enhanced-highlight"
git clone https://github.com/octol/vim-cpp-enhanced-highlight ${VIM_BUNDLE}\vim-cpp-enhanced-highlight
Write-Host "====> Installing vim-fugitive plugin"
git clone git://github.com/tpope/vim-fugitive.git ${VIM_BUNDLE}\vim-fugitive
Write-Host "====> Installing vim-fugitive stash extension"
Invoke-WebRequest -Uri https://raw.githubusercontent.com/MobiusHorizons/fugitive-stash.vim/master/plugin/fugitive-stash.vim `
  -OutFile ${HOME}\vimfiles\plugin\fugitive-stash.vim
Write-Host "====> Installing vim-dispatch plugin"
git clone git://github.com/tpope/vim-dispatch.git ${VIM_BUNDLE}\vim-dispatch
Write-Host "====> Installing vim-gitgutter plugin"
git clone git://github.com/airblade/vim-gitgutter.git ${VIM_BUNDLE}\vim-gitgutter
Write-Host "====> Installing DoxygenToolkit plugin"
git clone https://github.com/vim-scripts/DoxygenToolkit.vim.git ${VIM_BUNDLE}\DoxygenToolkit
Write-Host "====> Installing vim-headerguard plugin"
git clone https://github.com/drmikehenry/vim-headerguard.git ${VIM_BUNDLE}\vim-headerguard
Write-Host "====> Installing vim-cmake-syntax plugin"
git clone git://github.com/nickhutchinson/vim-cmake-syntax.git ${VIM_BUNDLE}\vim-cmake-syntax
Write-Host "====> Installing gnuplot syntax highlighting"
Invoke-WebRequest https://raw.githubusercontent.com/vim-scripts/gnuplot-syntax-highlighting/master/syntax/gnuplot.vim `
  -OutFile ${VIM_SYNTAX}\gnuplot.vim 

Write-Host "==> Installing VIM color themes from ${DOT_REPO}"
Invoke-WebRequest -Uri "${DOT_REPO}/colors/newproggie.vim" -OutFile "${VIM_COLORS}\newproggie.vim"
Invoke-WebRequest -Uri "${DOT_REPO}/colors/vim-airline-themes/newproggie.vim" -OutFile "${VIM_AIRLINE_THEMES}\newproggie.vim"
