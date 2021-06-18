Passo 1:
sudo apt install gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip build-essential lua5.4

Passo 2: Instalar Neovim 0.5
cd $(mktemp -d)
git clone https://github.com/neovim/neovim --depth 1
cd neovim
sudo make CMAKE_BUILD_TYPE=Release install
cd ..
rm -rf neovim

Passo 3: Clone meu repositorio
https://github.com/joaom00/nvim-config.git ~/.config/nvim

Passo 4: instalar vim-plug
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

Passo 5: nvim e instalar os plugins

