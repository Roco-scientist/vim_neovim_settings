#!/bin/bash

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

npm i -g pyright

mkdir -p ~/.config/nvim/
ln -s init.lua ~/.config/nvim/init.lua
ln -s pep8 ~/.config/pep8
ln -s flake8 ~/.config/flake8
cd -
pip install jedi
pip install yapf
pip install --user flake8
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

# Install rust-analyzer
brew install rust-analyzer

cd -
echo ":PackerSync"
