" Bootstrap VIM config
" Maintainer: Kai Wolf <http://kai-wolf.me/>
" Version:    1.0

""" Meta
set nocompatible             " use vim, not vi
set fileformats=unix,dos,mac " support all three newline formats
set viminfo=                 " don't use or save viminfo files
set autoread                 " watch for file changes
set nobackup                 " don't use backup files

""" Console / Text display
syntax on                    " show syntax highlighting
set showcmd                  " show (partial) command in status line.
set number                   " line numbers
set ruler                    " shows line number in status line
set noerrorbells             " disable bells in error case
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set wildmenu                 " command line completion with list of matches

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
set tabstop=8                " for proper display of files with tabs
set shiftround               " always round indents to multiple of shiftwidth
set copyindent               " use existing indents for new indents
set preserveindent           " save as much indent structure as possible
filetype plugin indent on    " load filetype plugins and indent settings