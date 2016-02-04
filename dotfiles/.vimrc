" Bootstrap VIM config
" Maintainer: Kai Wolf <http://kai-wolf.me/>
" Version:    1.0

""" Meta
set nocompatible             " use vim, not vi
set fileformats=unix,dos,mac " support all three newline formats
set viminfo=                 " don't use or save viminfo files
set autoread                 " watch for file changes
set nobackup                 " don't use backup
set nowb                     " files of
set noswapfile               " any kind
let mapleader = ","          " with a map leader it's possible to do extra
let g:mapleader = ","        " key combinations

""" Console / Text display
syntax on                    " show syntax highlighting
set showcmd                  " show (partial) command in status line.
set number                   " line numbers
set ruler                    " shows line number in status line
set noerrorbells             " disable bells in error case
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set wildmenu                 " command line completion with list of matches
set so=7                     " set 7 lines to the cursor when moving vertically
set wildignore=*.o,*~,.git\* " ignore compiled files
set foldcolumn=1             " add a little margin to the left
try                          " standard vim theme to use
    colorscheme desert
catch
endtry
set background=dark          " enable dark background
set encoding=utf8            " set utf8 as standard encoding

""" Status line
set laststatus=2             " always show the status line
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{getcwd()}%h\ \ \ Line:\ %l

""" Text editing and searching
set nohlsearch               " turn of highlighting for searched expressions
set incsearch                " incremental search rules
set ignorecase               " case insensitive matching
set smartcase                " unless there's a capital letter
set textwidth=80             " we want 80 columns
set showmatch                " show matching bracket

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

""" Custom functions
function! HasPaste()         " returns true, if paste mode is enabled
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
endfunction

""" Vim package manager pathogen
execute pathogen#infect()

""" pathogen::NerdTree
let g:NERDTreeWinPos = "right"
let NERDTreeShowHidden=0
let g:NERDTreeWinSize=35
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark 
map <leader>nf :NERDTreeFind<cr>

""" pathogen::ctrlP
let g:ctrlp_working_path_mode = 0

let g:ctrlp_map = '<c-f>'
map <leader>j :CtrlP<cr>
map <c-b> :CtrlPBuffer<cr>
let g:ctrlp_max_height = 20
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
