" Bootstrap VIM config
" Maintainer:   Kai Wolf <http://kai-wolf.me/>
" Last changed: 01.2018
" Version:      1.7

""" Identify platform
let g:MAC = has('macunix') || has('unix')
let g:LINUX = has('unix') && !has('macunix') && !has('win32unix')
let g:WINDOWS = has('win32') || has('win64')

""" System
if g:MAC
    " Prepend /usr/bin before PATH so that YCM works with brew installed python
    let $PATH = '/usr/bin:' . $PATH
endif

""" Meta
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
    set guioptions-=m        " remove menu bar
    set guioptions-=T        " remove toolbar
    set guioptions-=r        " remove right-hand scroll bar
    set guioptions-=L        " remove left-hand scroll bar
    if has('gui_win32') || has('gui_win64')
        set guifont=Fira_Code:h10:cANSI
    else
        set guifont=Operator\ Mono\ Book\ for\ Powerline:h15
    endif
endif
syntax on                    " show syntax highlighting
set encoding=utf8            " set utf8 as standard encoding
set showcmd                  " show (partial) command in status line.
set number                   " line numbers
set noerrorbells             " disable bells in error case
set list                     " show invisible characters
set listchars=tab:>·,trail:· " but only show tabs and trailing whitespace
set wildmenu                 " command line completion with list of matches
set so=7                     " set 7 lines to the cursor when moving vertically
set noro                     " open vimdiff in write mode (instead of readonly)
set wildignore=*.o,*~,.git\* " ignore compiled files
set foldcolumn=1             " add a little margin to the left
match OverLength /\%80v.\+/  " highlight text longer than 80 columns
set hidden                   " allow buffers to be hidden
augroup project              " create language-specific settings
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd Filetype gitcommit setlocal spell textwidth=72
    autocmd FileType c,cpp setlocal equalprg=clang-format
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd BufEnter *.sh,*.yml,*.html,*.txt,*.tex setlocal tabstop=2
    autocmd BufEnter *.sh,*.yml,*.html,*.txt,*.tex setlocal shiftwidth=2
    autocmd BufEnter *.sh,*.yml,*.html,*.txt,*.tex setlocal softtabstop=2
    autocmd BufRead,BufNewFile *.h,*.c set filetype=c.doxygen
    autocmd BufRead,BufNewFile *.h,*.cpp set filetype=cpp.doxygen
    autocmd BufRead,BufNewFile *.gp set filetype=gnuplot
augroup END
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR> " close current buffer

""" Development shortcuts
nnoremap <F5> :! ./build/main<CR>     " run the main program
nnoremap <F6> :execute "!make test -C build/ ARGS='-VV'"<CR>
nnoremap <F7> :make\|cwindow<CR>      " map F7 key to run make
nnoremap <F9> :YcmCompleter FixIt<CR> " Fix errors automatically
nnoremap <F12> :YcmCompleter GoTo<CR> " Go to definition/declaration
let &makeprg='cmake --build build'

""" Status line
set laststatus=2             " always show the status line
set statusline=%<%f\         " Filename
set statusline+=%w%h%m%r     " Options
set statusline+=\ \|%{&ff}\|%Y\| " Filetype
set statusline+=\ %{getcwd()} " Current dir
set statusline+=%=%-14.(%l,%c%V%)\ %p%%\  " Right aligned file nav info

""" Text editing and searching
if executable('ag')          " use silversearcher, if available
  " use ag over grep
  set grepprg=ag\ --nogroup\ --nocolor\ --column
  set grepformat=%f:%l:%c%m

  " use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif
set nohlsearch               " turn of highlighting for searched expressions
set incsearch                " incremental search rules
set ignorecase               " case insensitive matching
set smartcase                " unless there's a capital letter
set textwidth=80             " we want 80 columns
set showmatch                " show matching bracket
nnoremap t <c-]>             " ctags shortcut (t =tag and jumping back with Ctrl-t

""" Indentations and tabs
set autoindent               " set the cursor at same indent as line above
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

""" Yapf
if executable('yapf')
    command! -range=% Yapf :cexpr system('yapf '
        \ . '--lines ' . <line1> . '-' . <line2> . ' --in-place '
        \ . expand('%:p')) | checktime
endif

""" Cscope
if has('cscope')
    set cscopetag
    if has('quickfix')
        set cscopequickfix=s-,c-,d-,i-,t-,e-
    endif
    if filereadable("cscope.out")
        cs add cscope.out
    endif
    " find symbol
    nnoremap <leader>fr :cs find s <C-R>=expand("<cword>")<CR><CR>:cwindow<CR>
    " find include
    nnoremap <leader>fi :cs find i <C-R>=expand("<cword>")<CR><CR>:cwindow<CR>
    command GenCScopeDb :! cscope -bv $(find . -name *.cpp -o -iname *.h)
endif

""" Search in path (with Shift-S)
function SearchEverywhere() abort
    let search_term = input('Enter search: ')
    if !empty(search_term)
        execute 'silent grep' search_term | copen
    else
        echo "Empty search term"
    endif
    redraw!
endfunction
command SearchEverywhere call SearchEverywhere() | cwindow
map <S-S> :SearchEverywhere<cr>

""" Fix whitespace
function s:FixWhitespace(line1,line2) abort
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/\\\@<!\s\+$//'
    call setpos('.', l:save_cursor)
endfunction
command -range=% FixTrailingWhitespace call <SID>FixWhitespace(<line1>,<line2>)

""" Highlight duplicate lines
function HighlightRepeats() range abort
    let lineCounts={}
    let lineNum=a:firstline
    while lineNum <= a:lastline
        let lineText=getline(lineNum)
        if lineText != ""
            let lineCounts[lineText]=(has_key(lineCounts, lineText)
                \ ? lineCounts[lineText] : 0) + 1
        endif
        let lineNum=lineNum + 1
    endwhile
    exe 'syn clear Repeat'
    for lineText in keys(lineCounts)
        if lineCounts[lineText] >= 2
            exe 'syn match Repeat "^' . escape(lineText, '".\^$*[]') . '$"'
        endif
    endfor
endfunction
command -range=% HighlightRepeats <line1>,<line2>call HighlightRepeats()

""" ClangFormat
map <C-K> :pyf $CLANG_FORMAT_PATH/clang-format.py<cr>
imap <C-K> <c-o>:pyf $CLANG_FORMAT_PATH/clang-format.py<cr>
let g:clang_format_fallback_style = "Google"

""" ClangTidy
command! -range=% ClangTidy :cexpr system('clang-tidy '
    \ . expand('%:p:.') . ' -line-filter=''[{"name":"' . expand('%:t')
    \ . '","lines":[[' . <line1> . ',' . <line2> . ']]}]'''
    \ . ' \| grep ' . expand('%:t:r')) | cwindow

""" ClangRename
noremap <leader>cr :pyf $CLANG_RENAME_PATH/clang-rename.py<cr>

""" ClangIncludeFixer
noremap <leader>cf :pyf $CLANG_INCLUDE_FIXER_PATH/clang-include-fixer.py<cr>
let g:clang_include_fixer_jump_to_include = 1
let g:clang_include_fixer_query_mode = 1

""" Git diff tool
command! GitDiff !git difftool

""" Vim package manager pathogen
execute pathogen#infect('bundle/{}')

""" pathogen::NerdTree
let g:NERDTreeWinPos = "left"
let g:NERDTreeShowHidden=0
let g:NERDTreeWinSize=40
let g:NERDTreeIgnore=['\.vim$', '\~$', '\.git$', '\.pyc$']
map <leader>nn :NERDTreeToggle<cr>
map <leader>nb :NERDTreeFromBookmark
map <leader>nf :NERDTreeFind<cr>
""" Close NERDTree, if it's the last open window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")
    \ && b:NERDTree.isTabTree()) | q | endif

""" pathogen::CtrlP
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

""" pathogen::vim-cpp-enhanced-highlight
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_experimental_template_highlight = 1

""" pathogen::tagbar
let g:tagbar_width = 50
let g:tagbar_compact = 1
nmap <S-t> :TagbarToggle<CR>

""" pathogen::YouCompleteMe
let g:ycm_confirm_extra_conf = 0
let g:ycm_global_ycm_extra_conf='~/.vim/.ycm_extra_conf.py'
if g:WINDOWS
    let g:ycm_global_ycm_extra_conf=$HOME . '\vimfiles\.ycm_extra_conf.py'
endif
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
function! g:HeaderguardName() abort
    " We want <PROJECT>_<PATH>_<FILE>_H_ as format based on the
    " Google C++ Style Guide
    let dismiss = '\('.$HOME.'\|proj.[a-zA-Z]*\|src\|source\)/'
    let proj_path = substitute(expand('%:p'), dismiss, '', 'g')
    return toupper(substitute(proj_path, '[^0-9a-zA-Z]', '_', 'g')) . '_'
endfunction

""" pathogen::vim-markdown-preview
let g:vim_markdown_preview_github = 1
let g:vim_markdown_preview_browser='Google Chrome'
