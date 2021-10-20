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
pip install neovim
sudo apt-get install mypy
cd

# install neovim
# sudo apt-get install libtool-bin
# git clone https://github.com/neovim/neovim
# cd neovim
# git checkout stable
# sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
# sudo make install
# cd -

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Install language servers
# Python
sudo npm i -g pyright

# Lua
sudo apt-get install ninja-build
git clone --depth=1 https://hub.fastgit.org/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
export PATH="$HOME/tools/lua-language-server/bin/Linux:$PATH"

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

# fd
sudo apt install fd-find

npm install -g neovim
sudo gem install neovim
sudo apt install cpanminus
cpanm -n Neovim::Ext


cd -
echo "move rust-analyzer/target/release/rust-analyzer to /bin/"
echo ":PackerSync"
