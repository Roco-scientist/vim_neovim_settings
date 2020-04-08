" set python location
let g:python3_host_prog = $HOME . '/anaconda3/bin/python'

" remapping settings: exit, window movement
let mapleader = " "
inoremap jk <ESC>
noremap <leader>j <c-w>j
noremap <leader>k <c-w>k
noremap <leader>l <c-w>l
noremap <leader>h <c-w>h

" format settings
filetype plugin indent on
set encoding=utf-8
set clipboard^=unnamed,unnamedplus
set nowrap
set number
set cursorline
set smarttab
set scrolloff=10
autocmd BufNewFile,BufRead *.py,*.R,*.rs
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=100 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix
if has("termguicolors")
  set termguicolors
endif

" code folding
set foldenable
set foldlevelstart=10
set foldnestmax=10
noremap <leader>a za
noremap <leader>o zO                                                                                                                                                                                    
noremap <leader>c zC
set foldmethod=indent

" split settings
set splitbelow
set splitright

" netrw Sexplore, Vexplore, Explore settings
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" fzf enable
set rtp+=/usr/local/opt/fzf

" plugin settings
" let g:deoplete#enable_at_startup = 1
colorscheme gruvbox

" ultisnips configuration
let g:UltiSnipsExpandTrigger="<c-space>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:UltiSnipsEditSplit="vertical"
let g:UltiSnipsUsePythonVersion = 3

" supertab tab down
let g:SuperTabDefaultCompletionType = "<c-n>"

" R settings
let R_assign = 0
