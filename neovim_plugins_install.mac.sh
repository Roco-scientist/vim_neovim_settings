#!/bin/bash

# install vim-plug 
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

npm i -g pyright

mkdir -p ~/.config/nvim/
ln -s nvim_init.mac.vim ~/.config/nvim/init.vim
ln -s pep8 ~/.config/pep8
ln -s flake8 ~/.config/flake8
ln -s coc-settings.json ~/.config/nvim/coc-settings.json
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install neovim
pip install pynvim
pip install --user autopep8
brew install mypy
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
