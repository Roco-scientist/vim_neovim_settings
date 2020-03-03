" set python location
let g:python3_host_prog = '$HOME/anaconda3/bin/python'

" common settings
inoremap jk <ESC>
let mapleader = " "
filetype plugin indent on
set encoding=utf-8
set clipboard^=unnamed,unnamedplus
set nowrap
set number
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set textwidth=100
set termguicolors

" netrw Sexplore, Vexplore, Explore settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" plugin settings
let g:deoplete#enable_at_startup = 1
colorscheme gruvbox

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3
