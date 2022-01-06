#!/bin/bash
 
sudo apt-get install ninja-build make cmake mypy libtool-bin ripgrep clang-format clang-tidy clangd build-essential libssl-dev xclip ruby-dev fd-find gettext curl nodejs npm
sudo cp Roboto\ Mono\ Nerd\ Font\ Complete.ttf /usr/share/fonts/

mkdir -p ~/.config/nvim/
ln -s $PWD/init.lua ~/.config/nvim/init.lua
ln -s $PWD/pep8 ~/.config/pep8
ln -s $PWD/flake8 ~/.config/flake8
cd -
# curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
# sudo python2 get-pip.py
pip install jedi
pip install yapf
pip install black
pip install --user flake8
pip install pynvim
pip install --user autopep8
pip install neovim
# install neovim
cd
git clone https://github.com/neovim/neovim
cd neovim
git checkout stable
sudo make CMAKE_BUILD_TYPE=RelWithDebInfo
sudo make install
cd

# install packer
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

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
echo "export DISPLAY=:1" >> ~/.profile

cd

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.profile

# Rust
git clone https://github.com/rust-analyzer/rust-analyzer && cd rust-analyzer
cargo xtask install --server

# install rustfmt (for formatting)
rustup component add rustfmt

# install clippy (for semantic linting)
rustup component add clippy

# Install tree-sitter
cargo install tree-sitter-cli

sudo npm install -g neovim
sudo gem install neovim
sudo apt install cpanminus
sudo cpanm -n Neovim::Ext
cpanm --local-lib=~/perl5 local::lib && eval $(perl -I ~/perl5/lib/perl5/ -Mlocal::lib)

cd -
echo ":PackerSync"
echo ":checkhealth"
echo "Check that path in .profile is not after cargo/env"
echo "Install rorboto mono font for the terminal"
echo "TSInstall <languages> bash c r rust lua json python"
echo "set DISPLAY=:1 in ~/.profile if installed on a remote system to allow xclip"
