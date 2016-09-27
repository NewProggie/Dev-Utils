" Bootstrap VIM config
" Maintainer:   Kai Wolf <http://kai-wolf.me/>
" Last changed: 08.2016
" Version:      1.3

""" Meta
set nocompatible             " use vim, not vi
set fileformats=unix,dos,mac " support all three newline formats
set viminfo=                 " don't use or save viminfo files
set autoread                 " watch for file changes
set nobackup                 " don't use backup
set nowb                     " files of
set noswapfile               " any kind
set exrc                     " execute local .vimrc
set secure                   " but disable shell execution and write operations
let mapleader = ","          " with a map leader it's possible to do extra
let g:mapleader = ","        " key combinations

""" Tab/Window navigation
map <C-J> <C-W>j<C-W>_       " Remap window navigation
map <C-K> <C-W>k<C-W>_       " using <ctrl> together with
map <C-L> <C-W>l<C-W>_       " <jklh>, which directly
map <C-H> <C-W>h<C-W>_       " mirrors cursor navigation
map <left> :bprevious<CR>    " left arrow, cycling through buffers
map <right> :bnext<CR>       " right arrow, cycling through buffers
map <S-H> gT                 " Remap tab navigation
map <S-L> gt                 " to H and L
vnoremap . :normal .<CR>     " allow . to execute for each line in visual mode

""" Console / Text display
try                          " standard vim theme to use
    colorscheme newproggie
catch
endtry
if has('gui_running')
    set guifont=Operator\ Mono\ Medium\ for\ Powerline:h17
endif
syntax on                    " show syntax highlighting
set showcmd                  " show (partial) command in status line.
set number                   " line numbers
set noerrorbells             " disable bells in error case
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set wildmenu                 " command line completion with list of matches
set so=7                     " set 7 lines to the cursor when moving vertically
set wildignore=*.o,*~,.git\* " ignore compiled files
set foldcolumn=1             " add a little margin to the left
match OverLength /\%80v.\+/  " highlight text longer than 80 columns
set hidden                   " allow buffers to be hidden
set encoding=utf8            " set utf8 as standard encoding
augroup project              " enable highlighting for c/c++ and doxygen
    autocmd!
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
    autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen
augroup END
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR> " close current buffer

""" Development shortcuts
nnoremap <F7> :make<CR>      " map F7 key to run make
nnoremap <F12> :YcmCompleter GoTo<CR> " Go to definition/declaration
let &makeprg='make -C build -j4' " look for Makefile in build folder

""" Status line
set laststatus=2             " always show the status line
set statusline=%<%f\         " Filename
set statusline+=%w%h%m%r     " Options
set statusline+=\ \|%{&ff}\|%Y\| " Filetype
set statusline+=\ %{getcwd()} " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%\  " Right aligned file nav info

""" Text editing and searching
set nohlsearch               " turn of highlighting for searched expressions
set incsearch                " incremental search rules
set ignorecase               " case insensitive matching
set smartcase                " unless there's a capital letter
set textwidth=80             " we want 80 columns
set showmatch                " show matching bracket
nnoremap t <c-]>             " ctags shortcut (t =tag and jumping back with Ctrl-t

""" Indentations and tabs
set autoindent               " set the cursor at same indent as line above
set smartindent              " try to be smart about indenting (C-style)
set expandtab                " expand <Tab>s with spaces
set shiftwidth=4             " spaces for each step of (auto) indent
set softtabstop=4            " set virtual tab stop (compat for 8-wide tabs)
set tabstop=4                " for proper display of files with tabs
set shiftround               " always round indents to multiple of shiftwidth
set copyindent               " use existing indents for new indents
set preserveindent           " save as much indent structure as possible
filetype plugin indent on    " load filetype plugins and indent settings

""" Spell checking
map <leader>ss :setlocal spell!<cr> " toggle spell checking with ,ss
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=

""" ClangFormat (set variables via ~/.path)
map <C-K> :pyf ${CLANG_FORMAT_PATH}/clang-format.py<cr>
imap <C-K> <c-o>:pyf ${CLANG_FORMAT_PATH}/clang-format.py<cr>

""" ClangIncludeFixer
noremap <leader>cf :pyf ${CLANG_INCLUDE_FIXER_PATH}/clang-include-fixer.py<cr>
let g:clang_include_fixer_jump_to_include = 1
let g:clang_include_fixer_query_mode = 1

""" ClangRename
noremap <leader>cr :pyf ${CLANG_RENAME_PATH}/clang-rename.py<cr>

""" ClangTidy
command -range=% ClangTidy :cexpr system('clang-tidy '
    \ . expand('%:p:.') . ' -line-filter=''[{"name":"' . expand('%:t')
    \ . '","lines":[[' . <line1> . ',' . <line2> . ']]}]'''
    \ . ' \| grep ' . expand('%:t:r'))

""" Vim package manager pathogen
execute pathogen#infect('bundle/{}')

""" pathogen::NerdTree
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden=0
let g:NERDTreeWinSize=40
let g:NERDTreeIgnore=['\.vim$', '\~$', '\.git$']
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
""" Close NERDTree, if it's the last open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
    \ && b:NERDTree.isTabTree()) | q | endif

""" pathogen::ctrlP
let g:ctrlp_working_path_mode = 0
let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

""" pathogen::gitgutter
nmap <leader>hn <Plug>GitGutterNextHunk
nmap <leader>hp <Plug>GitGutterPrevHunk

""" pathogen::airline
let g:airline_powerline_fonts = 1
let g:airline#extensions#branch#displayed_head_limit = 16
let g:airline_theme='newproggie'
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

""" pathogen::tagbar
nmap <S-t> :TagbarToggle<CR>

""" pathogen::YouCompleteMe
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1

""" pathogen::DoxygenToolkit
let g:DoxygenToolkit_authorName = "Kai Wolf"
let g:DoxygenToolkit_licenseTag = "Copyright (c) " . strftime("%Y")
    \ . ", Kai Wolf. All rights reserved.\<enter>"
    \ . "Use of this source code is governed by a MIT-style license that can "
    \ . "be\<enter>found in the LICENSE file in the top directory.\n"
let g:DoxygenToolkit_commentType = "C++"
let g:DoxygenToolkit_briefTag_pre = "" " using JAVADOC_AUTOBRIEF
let g:DoxygenToolkit_compactDoc = "yes"
let g:DoxygenToolkit_compactOneLineDoc = "yes"

""" pathogen::headerguard
let g:headerguard_use_cpp_comments = 1
function! g:HeaderguardName()
    " We want <PROJECT>_<PATH>_<FILE>_H_ as format based on the
    " Google C++ Style Guide
    let dismiss = '\('.$HOME.'\|proj.[a-zA-Z]*\|src\|source\)/'
    let proj_path = substitute(expand('%:p'), dismiss, '', 'g')
    return toupper(substitute(proj_path, '[^0-9a-zA-Z]', '_', 'g')) . '_'
endfunction
