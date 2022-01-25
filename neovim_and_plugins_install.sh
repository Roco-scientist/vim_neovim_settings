#!/bin/zsh

if [ -n "$ZSH_VERSION" ]; then
    PROFILE=~/.zprofile
elif [ -n "$BASH_VERSION" ]; then
    PROFILE=~/.profile
fi

SETTINGS_DIR=$PWD
 
sudo apt-get install ninja-build make cmake mypy libtool-bin ripgrep clang-format clang-tidy clangd build-essential libssl-dev xclip ruby-dev fd-find gettext curl nodejs npm git

# update node
npm cache clean -f
npm install -g n
sudo n stable

# add fonts
sudo cp Roboto\ Mono\ Nerd\ Font\ Complete.ttf /usr/share/fonts/

mkdir -p ~/.config/nvim/
ln -s $SETTINGS_DIR/init.lua ~/.config/nvim/init.lua
cd -
# curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
# sudo python2 get-pip.py
# python2 -m pip install neovim
pip install neovim
pip install black
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
git clone https://github.com/sumneko/lua-language-server
cd lua-language-server
git submodule update --init --recursive
cd 3rd/luamake
compile/install.sh
cd ../..
./3rd/luamake/luamake rebuild
echo 'export PATH="$HOME/lua-language-server/bin/Linux:$PATH"' >> $PROFILE

# export display for clipboard
# echo "export DISPLAY=:1" >> ~/.profile

cd

# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source $PROFILE

# Rust
git clone https://github.com/rust-analyzer/rust-analyzer
cd rust-analyzer
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

# solidity and lsp
sudo add-apt-repository ppa:ethereum/ethereum
sudo apt-get install solc
npm install -g solidity-language-server

# Typescript
npm install -g typescript typescript-language-server eslint prettier
npm install --save-dev @typescript-eslint/parser @typescript-eslint/eslint-plugin

cd $SETTINGS_DIR
echo ":PackerSync"
echo ":checkhealth"
echo "Check that path in $PROFILE is not after cargo/env"
echo "Install rorboto mono font for the terminal"
echo "TSInstall <languages> bash c r rust lua json python"
echo "set DISPLAY=:1 in $PROFILE if installed on a remote system to allow xclip"
