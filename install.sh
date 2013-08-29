#!/bin/sh -x

# Vim plugin ideas are borrow from here
# http://vimcasts.org/episodes/synchronizing-plugins-with-git-submodules-and-pathogen/

# First we install oh-my-zshell if not available
if [ ! -d ${HOME}/.oh-my-zsh ]; then
  curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
  pushd
  cd ${HOME}/.oh-my-zsh
  git remote rm origin
  git remote add origin git://github.com:jose-espinosa/oh-my-zsh.git
  git remote add upstream git://github.com/robbyrussell/oh-my-zsh.git
  git fetch origin
  git branch --set-upstream-to=origin/master master
  git pull origin master
  popd
fi

if [ ! -d ${HOME}/.dotfiles ]; then
  git clone --recursive git://github.com:jose-espinosa/dotfiles.git ${HOME}/.dotfiles
  pushd
  cd ${HOME}/.dotfiles
  git pull origin master
  git submodule foreach git pull origin master
  popd
fi

if [ ! -f ${HOME}/.gitconfig ]; then
  ln -s .dotfiles/gitconfig ${HOME}/.gitconfig
fi

# The zshrc config is machine dependent, we use the host name to get the rigth one
if [ -f .dotfiles/zshrc.local.`hostname` ] && [ ! -f ${HOME}/.zshrc.local ]; then
  ln -s .dotfiles/zshrc.local.`hostname` ${HOME}/.zshrc.local
fi

if [ ! -d ${HOME}/.vim ]; then
  ln -s ${HOME}/.dotfiles/vim ${HOME}/.vim
fi

if [ ! -f ${HOME}/.vimrc ]; then
  ln -s ${HOME}/.dotfiles/vimrc ${HOME}/.vimrc
fi

if [ ! -f ${HOME}/.gvimrc ]; then
  ln -s ${HOME}/.dotfiles/gvimrc ${HOME}/.gvimrc
fi
