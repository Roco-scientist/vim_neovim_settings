" common settings
let mapleader = " "
inoremap jk <ESC>
noremap <leader>j <c-w>j
noremap <leader>k <c-w>k
noremap <leader>l <c-w>l
noremap <leader>h <c-w>h
filetype plugin indent on
set encoding=utf-8
set clipboard^=unnamed,unnamedplus
set nowrap
set number
set cursorline
set autoindent
set expandtab
set smarttab
set tabstop=4
set shiftwidth=4
set textwidth=100
set termguicolors
set background=dark

" code folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
noremap <leader>a za
set foldmethod=indent

" split settings
set splitbelow
set splitright

" netrw Sexplore, Vexplore, Explore settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" plugin settings
colorscheme gruvbox

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3
