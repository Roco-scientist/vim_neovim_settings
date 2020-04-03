#! /usr/bin/bash

mkdir -p ~/.config/nvim/
cp nvim_init.vim ~/.config/nvim/init.vim
cp pep8 ~/.config
cp flake8 ~/.config
mkdir -p ~/.local/share/nvim/site/pack/plugins/start
cd ~/.local/share/nvim/site/pack/plugins/start
git clone https://github.com/ervandew/supertab.git
git clone https://github.com/jiangmiao/auto-pairs.git
# git clone https://github.com/Shougo/deoplete.nvim.git
# git clone --recursive https://github.com/deoplete-plugins/deoplete-jedi
# git clone https://github.com/davidhalter/jedi.git
git clone https://github.com/morhetz/gruvbox.git
git clone https://github.com/honza/vim-snippets.git
git clone https://github.com/SirVer/ultisnips.git
git clone https://github.com/vim-airline/vim-airline.git
git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/airblade/vim-gitgutter.git
git clone https://github.com/dense-analysis/ale.git
git clone https://github.com/nvie/vim-flake8.git
git clone https://github.com/tell-k/vim-autopep8.git
git clone https://github.com/Integralist/vim-mypy.git
git clone https://github.com/rust-lang/rust.vim.git
# git clone https://github.com/sebastianmarkow/deoplete-rust.git
# git clone https://github.com/autozimu/LanguageClient-neovim.git
# bash ./LanguageClient-neovim/install.sh
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz|tar xzfv -
git clone https://github.com/jalvesaq/Nvim-R.git
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install neovim
pip install pynvim
pip install --user autopep8
sudo apt-get install mypy
cd
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install rustfmt (for formatting)
rustup component add rustfmt

# install clippy (for semantic linting)
rustup component add clippy

# hardest one last, install rust-analyzer
git clone https://github.com/rust-analyzer/rust-analyzer && cd rust-analyzer
cargo xtask install --server

cd -
echo "nodejs needed"
echo "within nvim"
echo ":CocInstall coc-rust-analyzer"
echo ":CocInstall coc-python"
