" Maintainer: Clinton James  clinton dot james at anuit dot com
" 'za' or <F9> will toggle folding
" -> General {{{
set history=700          " Lines of history VIM has to remember
set nocompatible
set modeline             " look for modelines, see last line for example
set modelines=1          " check N lines at start and end for instructions
let mapleader="\<Space>" " change leader key to a space
" }}}
" -> Plugin {{{
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Basic Help
"  :PluginList  - lists configured plugins
"  :PluginUpdate - git update origin master foreach plugin
"  :PluginInstall tpope/vim-fugitive
Plugin 'VundleVim/Vundle.vim'
Plugin 'tmhedberg/SimpylFold'
Plugin 'tpope/vim-fugitive'
Plugin 'davidhalter/jedi-vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-obsession'
Plugin 'easymotion/vim-easymotion'
Plugin 'vim-syntastic/syntastic'
Plugin 'vim-airline/vim-airline'
" Python Plugins ================================
Plugin 'nvie/vim-flake8'
Plugin 'hynek/vim-python-pep8-indent'
" HTML Plugins ==================================
Plugin 'wavded/vim-stylus'
call vundle#end()
filetype plugin indent on
" }}}
" -> Plugin Config {{{
let g:airline_symbols_ascii=1
set laststatus=2  " airline won't wait to split a window
" ctrlP ignore files from .gitignore :)
let g:ctrlp_user_command=['.git', 'cd %s && git ls-files -co --exclude-standard']
let g:SimpylFold_docstring_preview=1
let g:EasyMotion_smartcase=1    " lower case matched both; upper only upper
" ->   config Syntastic {{{
" I want the errors and warnings to go into the location list
" now I can use :ll :lne :lopen :lclose
let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=0
let g:syntastic_quiet_messages = {
        \ "regex": 'E501' }
"   }}}
" }}}
" -> VIM user interface {{{
set wildmenu       " tab completion
" Ignore certain file extensions
set wildignore=*.swp,*.bak,*.pyc,*.o,*~
set cursorline     " use an underline to show cursor location
set ignorecase     " ignore case when searching
set smartcase      " ingore case if search is all lowercase, sensitive otherwise
set hlsearch       " highlight search terms
set incsearch      " show search matches as you type
set showmatch      " show matching parenthesis
set lazyredraw     " don't redraw while executing macros- performance
set ttyfast        " improves redrawing for newer computers
set noerrorbells   " stop beeping at me
set mat=3          " tenths/sec to blink when matching brackets
" Esc hurts my pinky, exit insert mode with jk
inoremap jk <esc>
" Show invisibles
set list
set listchars=nbsp:¬,tab:»\ ,trail:·,extends:#
filetype plugin on  "enable filetype plugins
filetype indent on
" Change the shape of the cursor depending on the mode
"   http://vim.wikia.com/wiki/Change_cursor_shape_in_different_modes
if has("autocmd")
    au VimEnter,InsertLeave * silent execute '!echo -ne "\e[2 q"' | redraw!
    au InsertEnter,InsertChange *
        \ if v:insertmode == 'i' |
        \   silent execute '!echo -ne "\e[6 q"' | redraw! |
        \ elseif v:insertmode == 'r' |
        \   silent execute '!echo -ne "\e[4 q"' | redraw! |
        \ endif
        au VimLeave * silent execute '!echo -ne "\e[ q"' | redraw!
    endif
" }}}
" -> Colors and fonts {{{
syntax enable      " enable syntax processing
set background=dark
let &t_Co=256
" }}}
" -> Text, tab and indent related {{{
set expandtab      " turn tabs into spaces
set smarttab       " tabs on the start of a line by shiftwidth not tabstop
set softtabstop=4  " the number of spaces in a tab when editing
set shiftwidth=4   " number of space to use for autoindenting
set tabstop=4      " a tab is four spaces
set autoindent     " always set autoindenting on
set copyindent     " copy the previuous indentation on autoindenting
set shiftround     " use multiple of shiftwidth when indenting with '<' or '>'
" set si             " smart indent screws with python comments
set wrap           " wrap lines
" }}}
" -> Moving around, tabs, windows and buffers {{{
" Force myself to use the proper keymappings
"inoremap <esc> <C-o>:throw 'Use jk'<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
set splitbelow
set splitright
"nnoremap <C-J> <C-W><C-J>  "ctrl + j
"nnoremap <C-K> <C-W><C-K>  "ctrl + k
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Return to last edit position when opening files (You want this!)
 autocmd BufReadPost *
     \ if line("'\"") > 0 && line("'\"") <= line("$") |
     \   exe "normal! g`\"" |
     \ endif
" Remember info about open buffers on close
 set viminfo^=%
" }}}
" -> Folding {{{
" F9 will toggle folds
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf
":syn sync fromstart  " proper syntax coloring after folding messes it up
" }}}
" -> Helper functions {{{
" strips trailing whitespace at the end of files. this
" is called on buffer write in the autocmd below.
function! <SID>StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction
" }}}
" -> Filetype specific settings {{{
augroup configgroup
    autocmd!
    autocmd VimEnter * highlight clear SignColumn
    autocmd BufWritePre *.php,*.py,*.js,*.txt,*.hs,*.java,*.md
                \ :call <SID>StripTrailingWhitespaces()
    autocmd BufEnter *.sh setlocal tabstop=2
    autocmd BufEnter *.sh setlocal shiftwidth=2
    autocmd BufEnter *.sh setlocal softtabstop=2
    autocmd FileType python setlocal commentstring=#\ %s
    autocmd Filetype python setlocal textwidth=79
    autocmd Filetype python setlocal autoindent
    autocmd Filetype python setlocal number
    " " enable folding or hiding of indented lines
    " autocmd Filetype python setlocal foldenable
    " " open most folds by default
    " autocmd Filetype python setlocal foldlevel=2
    " "autocmd Filetype python setlocal foldlevelstart=10
    autocmd Filetype python setlocal foldmethod=indent
    autocmd BufEnter Makefile setlocal noexpandtab
    autocmd Filetype gitcommit setlocal spell textwidth=72
    autocmd FileType java setlocal noexpandtab
    autocmd FileType java setlocal list
    autocmd FileType java setlocal listchars=tab:+\ ,eol:-
    autocmd FileType java setlocal formatprg=par\ -w80\ -T4
    autocmd FileType php setlocal expandtab
    autocmd FileType php setlocal list
    autocmd FileType php setlocal listchars=tab:+\ ,eol:-
    autocmd FileType php setlocal formatprg=par\ -w80\ -T4
    autocmd BufEnter *.cls setlocal filetype=java
    autocmd BufNewFile,BufRead *.styl set filetype=stylus
augroup END
augroup AutoSaveFolds
  autocmd!
  autocmd BufWinLeave *.* mkview
  autocmd BufWinEnter *.* silent loadview
augroup END
" }}}
" -> Python {{{
"python with virtualenv support
py << EOF
import os, sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
" let python-highlight_all=1
syntax on
" }}}
" -> Notes {{{
" 2015-03-07 Tried implementing suggestions from
"   realpython.com/vim-and-python-a-match-made-in-heaven (RP)
" }}}
" vim: foldmarker={{{,}}} foldlevel=0 foldmethod=marker
