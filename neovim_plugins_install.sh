#! /usr/bin/bash

mkdir -p ~/.config/nvim/
cp nvim_init.vim ~/.config/nvim/init.vim
cp pep8 ~/.config
cp flake8 ~/.config
mkdir -p ~/.local/share/nvim/site/pack/plugins/start
cd ~/.local/share/nvim/site/pack/plugins/start
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/jiangmiao/auto-pairs.git
git clone https://github.com/Shougo/deoplete.nvim.git
git clone --recursive https://github.com/deoplete-plugins/deoplete-jedi
git clone https://github.com/davidhalter/jedi.git
git clone https://github.com/morhetz/gruvbox.git
git clone https://github.com/honza/vim-snippets.git
git clone https://github.com/SirVer/ultisnips.git
git clone https://github.com/vim-airline/vim-airline.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/dense-analysis/ale.git
git clone https://github.com/nvie/vim-flake8.git
git colne https://github.com/tell-k/vim-autopep8.git
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install neovim
pip install pynvim
pip install --user autopep8
