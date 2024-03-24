#!/bin/bash
 
VIM_DIR=$PWD

sudo apt-get -y install ninja-build libtool-bin mypy ruby-dev fd-find cpanminus neovim
cd

mkdir -p ~/.config/nvim/
ln -s $VIM_DIR/init.lua ~/.config/nvim/init.lua
ln -s $VIM_DIR/pep8 ~/.config/pep8
ln -s $VIM_DIR/flake8 ~/.config/flake8
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install pynvim
pip install --user autopep8
pip install neovim
cd

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers
# Python
sudo npm i -g pyright

# Lua
git clone --depth=1 https://hub.fastgit.org/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
echo 'export PATH="$HOME/lua-language-server/bin/Linux:$PATH"' >> ~/.profile

cd
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust
git clone https://github.com/rust-analyzer/rust-analyzer && cd rust-analyzer
cargo build --release

# install rustfmt (for formatting)
rustup component add rustfmt

# install clippy (for semantic linting)
rustup component add clippy

# Install tree-sitter
cargo install tree-sitter-cli

sudo npm install -g neovim
sudo gem install neovim
sudo cpanm -n Neovim::Ext


cd -
echo ":PackerSync"
echo ":checkhealth"
echo "Check that path in .profile is not after cargo/env"
