#!/bin/bash

mkdir -p ~/.config/nvim/
ln -s $PWD/init.lua ~/.config/nvim/init.lua
ln -s $PWD/pep8 ~/.config/pep8
ln -s $PWD/flake8 ~/.config/flake8
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install pynvim
pip install --user autopep8
brew install mypy
cd

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers ----------
# Python
sudo npm i -g pyright
# Lua
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
cd
# Rust
brew install rust-analyzer

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# install rustfmt (for formatting)
rustup component add rustfmt

# install clippy (for semantic linting)
rustup component add clippy

cd -
echo ":PackerSync"
