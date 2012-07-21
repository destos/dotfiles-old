all: update

# Instalation routines
first-run: install-homebrew install-git update-local link
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

# Git
install-git:
	brew install git

# Homebrew
homebrew_formulae = \
	wget\
	gist\
	hub

install-homebrew:
	/usr/bin/ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"

uninstall-homebrew:
	sh $(PWD)/uninstall_homebrew.sh

brew-update:
	brew update
	brew outdated
	brew upgrade

install-homebrew-formulae:
	brew install $(homebrew_formulae)

uninstall-homebrew-formulae:
	brew uninstall $(homebrew_formulae)

# TODO: Install nvm + node

install-node:

uninstall-node:

# Cleanup routines
clean: uninstall unlick

uninstall: uninstall-homebrew uninstall-node

unlink:
	unlink $(HOME)/.gitconfig
	unlink $(HOME)/.gitignore
	unlink $(HOME)/.tm_properties