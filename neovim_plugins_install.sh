#! /usr/bin/bash

cd ~
mkdir .config
cd .config
mkdir nvim
cd ~
mkdir .local
cd .local
mkdir share
cd share
mkdir nvim
cd nvim
mkdir site
cd site
mkdir plugins
cd plugins
mkdir start
cd start
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/davidhalter/jedi-vim.git
git clone https://github.com/Shougo/deoplete.nvim.git
git clone --recursive https://github.com/deoplete-plugins/deoplete-jedi
git clone https://github.com/morhetz/gruvbox.git
git clone https://github.com/SirVer/ultisnips.git
cd ~
cp ./.vim/nvim_init.vim ./.config/nvim/init.vim
pip install jedi
pip install yapf
pip install --user --upgrade pynvim

