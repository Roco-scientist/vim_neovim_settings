#! /usr/bin/bash

mkdir -p ~/.config/nvim/
cp nvim_init.vim ~/.config/nvim/init.vim
mkdir -p ~/.local/share/nvim/site/pack/plugins/start
cd ~/.local/share/nvim/site/pack/plugins/start
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/davidhalter/jedi-vim.git
git clone https://github.com/Shougo/deoplete.nvim.git
git clone --recursive https://github.com/deoplete-plugins/deoplete-jedi
git clone https://github.com/morhetz/gruvbox.git
git clone https://github.com/honza/vim-snippets.git
git clone https://github.com/SirVer/ultisnips.git
cd -
pip install jedi
pip install yapf
pip install --user --upgrade pynvim

