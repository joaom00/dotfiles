#!/usr/bin/env bash

set -e

exists() {
  type "$1" &> /dev/null;
}

sudo apt update
sudo apt install build-essential procps curl file git -y
sudo apt install zsh -y || echo "Failed to install zsh"

OHMYZSH="~/.oh-my-zsh"
if [ ! -d "$OHMYZSH" ]; then
  echo "----------------------------"
  echo "    Installing ohmyzsh      "
  echo "----------------------------"
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || echo "Failed to install ohmyzsh"
fi

ZSH_CUSTOM="$OHMYZSH/custom"
SPACESHIP="$OHMYZSH/custom/themes/spaceship-prompt"
if [ ! -d "$SPACESHIP" ]; then 
  echo "----------------------------"
  echo "  Cloning spaceship theme   "
  echo "----------------------------"
  git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
  ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
fi

ZSHPLUGINS=("zsh-autosuggestions" "zsh-completions")

for p in ${ZSHPLUGINS[@]}; do
  echo "--------------------------------------"
  echo "Cloning $p plugin"
  echo "--------------------------------------"
  git clone https://github.com/zsh-users/"$p" ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/"$p"
done

echo "-------------------------------------------------"
echo "Cloning fast-syntax-highlighting plugin"
echo "-------------------------------------------------"
git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting


# echo "Cloning zsh-autosuggestions plugin..."
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 
# echo "Cloning zsh-completions plugin..."
# git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
# 
# echo "Cloning fast-syntax-highlighting plugin..."
# git clone https://github.com/zdharma/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting


if ! exists brew; then
  echo "Installing homebrew..."
  echo "This may take a while"
  echo "Installing requirements for homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "Failed to install homebrew"
  echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/joaom/.zprofile
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if ! exists nvm; then
  echo "----------------------------"
  echo "      Cloning ZSH-NVM       "
  echo "----------------------------"
  git clone https://github.com/lukechilds/zsh-nvm.git ~/.zsh-nvm
fi

if ! exists yarn; then
  echo "----------------------------"
  echo "      Installing yarn       "
  echo "----------------------------"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install --no-install-recommends yarn || echo "Failed to install yarn"
fi

if exists brew; then
  echo "-------------------Homebrew Install----------------------"
  echo "                        Neovim                           "
  echo "---------------------------------------------------------"
  brew install neovim
  echo "-------------------Homebrew Install----------------------"
  echo "                      Github CLI                         "
  echo "---------------------------------------------------------"
  brew install gh
  echo "-------------------Homebrew Install----------------------"
  echo "                       Lazygit                           "
  echo "---------------------------------------------------------"
  brew install lazygit
fi

echo "----------------------------"
echo "      Installing rust       "
echo "----------------------------"
curl https://sh.rustup.rs -sSf | sh

if exists cargo; then
  echo "---------------------Cargo Install-----------------------"
  echo "                        Stylua                           "
  echo "---------------------------------------------------------"
  cargo install stylua

  echo "---------------------Cargo Install-----------------------"
  echo "                        Delta                            "
  echo "---------------------------------------------------------"
  cargo install git-delta
  
  if ! exists rg; then
    echo "---------------------Cargo Install-----------------------"
    echo "                        Ripgrep                          "
    echo "---------------------------------------------------------"
    cargo install ripgrep
  fi
fi

echo "Dotfiles -------------------------------------------------"

DOTFILES="~/.dotfiles"

if [ -d "$DOTFILES" ]; then
  echo "Dotfiles have already been cloned into the home dir"
else
  echo "Cloning dotfiles"
  git clone https://github.com/joaom00/dotfiles.git ~/.dotfiles
fi

cd "$DOTFILES" || "Didn't cd into dotfiles this will be bad :("
git submodule update --init --recursive

echo "---------------------------------------------------------"
echo "Changing to zsh"
echo "---------------------------------------------------------"
chsh -s "$(which zsh)"

$DOTFILES/install

echo "---------------------------------------------------------"
echo "All done!"
echo "Cheers"
echo "---------------------------------------------------------"

exit 0
