#!/bin/bash

mkdir -p ~/.config/nvim/
ln -s $PWD/init.lua ~/.config/nvim/init.lua
ln -s $PWD/pep8 ~/.config/pep8
ln -s $PWD/flake8 ~/.config/flake8
cp Roboto\ Mono\ Nerd\ Font\ Complete.ttf ~/Library/Fonts/
cd -
pip install jedi
pip install yapf
pip install --user flake8
pip install pynvim
pip install neovim
pip install --user autopep8
brew install mypy
cd

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers ----------
# C++
brew install llvm
brew install clang-format
echo 'export PATH="$HOME/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
echo 'export LDFLAGS="-L/$HOME/homebrew/opt/llvm/lib"' >> ~/.zprofile
echo 'export CPPFLAGS="-I/$HOME/homebrew/opt/llvm/include"' >> ~/.zprofile

# Go
brew install gopls

# Python
sudo npm i -g pyright

# Lua
brew install ninja
git clone --depth=1 https://hub.fastgit.org/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
echo 'export PATH="$HOME/lua-language-server/bin/macOS:$PATH"' >> ~/.profile
cd

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Rust
brew install rust-analyzer

# install rustfmt (for formatting)
rustup component add rustfmt

# install clippy (for semantic linting)
rustup component add clippy

# Install tree-sitter
cargo install tree-sitter-cli

# fd
brew install fd

npm install -g neovim
sudo gem install neovim
brew install cpanminus
cpanm -n Neovim::Ext

cd -
echo ":PackerSync"
echo "Check that path in .profile is not after cargo/env"
echo "Install Fira Code font for the terminal"
echo "TSInstall <languages>"
