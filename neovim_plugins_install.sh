#!/bin/bash

# install vim-plug 
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

mkdir -p ~/.config/nvim/
cp nvim_init.vim ~/.config/nvim/init.vim
cp pep8 ~/.config
cp flake8 ~/.config
cp coc-settings.json ~/.config/nvim/
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
# cargo xtask install --server
cargo build --release

cd -
echo "move rust-analyzer/target/release/rust-analyzer to /bin/"
echo ":PlugInstall"
echo "nodejs needed"
echo "within nvim"
echo ":CocInstall coc-rust-analyzer"
echo ":CocInstall coc-python"
echo ":CocInstall coc-r-lsp"
echo ":CocInstall coc-snippits"
