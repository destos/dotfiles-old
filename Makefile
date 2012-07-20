all: update
  
# Instalation routines
install: update-local link
  
update: update-local link

# Update local dotfiles
update-local:
  git pull --rebase || (git stash && git pull --rebase && git stash pop)
  git submodule update --init
  git submodule foreach git pull

ln_options = hfsv

link:
  ln -$(ln_options) $(PWD)/gitconfig $(HOME)/.gitconfig
  ln -$(ln_options) $(PWD)/gitignore $(HOME)/.gitignore
  ln -$(ln_options) $(PWD)/tm_properties $(HOME)/.tm_properties