let g:python3_host_prog = '$HOME/anaconda3/bin/python'
inoremap jk <ESC>
let mapleader = " "
filetype plugin indent on
set encoding=utf-8
set clipboard=unnamedplus
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set textwidth=120
set termguicolors
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:deoplete#enable_at_startup = 1
colorscheme gruvbox
let g:jedi#popup_on_dot = 0
let g:jedi#force_py_version = 3
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3
