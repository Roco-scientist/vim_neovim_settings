#!/bin/zsh

mkdir -p ~/.config/nvim/
ln -s $PWD/init.lua ~/.config/nvim/init.lua
cp Roboto\ Mono\ Nerd\ Font\ Complete.ttf ~/Library/Fonts/
cd -
pip install neovim
brew install mypy
brew install ripgrep
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
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
./compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
echo 'export PATH="$HOME/lua-language-server/bin/macOS:$PATH"' >> ~/.zprofile
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
sudo cpanm -n Neovim::Ext
sudo cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

cd -
echo ":PackerSync"
echo "Check that path in .zprofile is not after cargo/env"
echo "Install roboto font for the terminal"
echo "TSInstall <languages>"
