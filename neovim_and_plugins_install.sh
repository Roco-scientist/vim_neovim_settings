#!/bin/bash
 
sudo apt-get install ninja-build
sudo cp Roboto\ Mono\ Nerd\ Font\ Complete.ttf /usr/share/fonts/

mkdir -p ~/.config/nvim/
ln -s $PWD/init.lua ~/.config/nvim/init.lua
ln -s $PWD/pep8 ~/.config/pep8
ln -s $PWD/flake8 ~/.config/flake8
cd -
pip install jedi
pip install yapf
pip install black
pip install --user flake8
pip install pynvim
pip install --user autopep8
pip install neovim
sudo apt-get install mypy
# install neovim
cd
sudo apt-get install libtool-bin
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers
# C+ ---- update this later if needed
sudo apt-get install clang-format
sudo apt-get install clangd
sudo apt-get install clang-tidy

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

sudo apt-get install ruby-dev
# fd
sudo apt install fd-find
sudo npm install -g neovim
sudo gem install neovim
sudo apt install cpanminus
sudo cpanm -n Neovim::Ext


cd -
echo "move rust-analyzer/target/release/rust-analyzer to /bin/"
echo ":PackerSync"
echo ":checkhealth"
echo "Check that path in .profile is not after cargo/env"
echo "Install Fira Code font for the terminal"
echo "TSInstall <languages>"
