all: update

# Instalation routines
first-run: \
	install-homebrew \
	install-scm \
	convert-to-git \
	update-local \
	install-nvm \
	install-node \
	link
	
	
install: \
	update-local \
	link

convert-to-git:
	git init
	git remote add origin git://github.com/destos/dotfiles.git
	git fetch
	git branch master origin/master
	git reset --hard HEAD
	
update: \
	update-local \
	link

# Update local dotfiles
update-local:
	git pull --rebase || (git stash && git pull --rebase && git stash pop)
	git submodule update --init
	git submodule foreach git checkout master && git pull

ln_options = hfsv
link:
	ln -$(ln_options) $(PWD)/bash_profile $(HOME)/.bash_profile
	ln -$(ln_options) $(PWD)/bash_prompt $(HOME)/.bash_prompt
	ln -$(ln_options) $(PWD)/aliases $(HOME)/.aliases
	ln -$(ln_options) $(PWD)/exports $(HOME)/.exports
	ln -$(ln_options) $(PWD)/extra  $(HOME)/.extra
	ln -$(ln_options) $(PWD)/gitconfig $(HOME)/.gitconfig
	ln -$(ln_options) $(PWD)/gitignore $(HOME)/.gitignore
	ln -$(ln_options) $(PWD)/hgrc $(HOME)/.hgrc
	ln -$(ln_options) $(PWD)/tm_properties $(HOME)/.tm_properties
	ln -$(ln_options) $(PWD)/npmrc $(HOME)/.npmrc
	ln -$(ln_options) $(PWD)/kdiff3rc $(HOME)/.kdiff3rc

## SCM
install-scm: \
	install-git \
	install-hg
	
# Git
install-git:
	brew install git

# Mercurial
install-hg:
	brew install hg

# Homebrew
homebrew_formulae = \
	bash-completion \
	wget \
	gist \
	hub \
	kdiff3 \
	htop \
	tree

install-homebrew:
	ruby -e "$(/usr/bin/curl -fsSL https://raw.github.com/mxcl/homebrew/master/Library/Contributions/install_homebrew.rb)"

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

# Install node version manager + latest node

#use n for node version management
install-nvm:
	cd $(PWD)/n && make install
	
uninstall-nvm:
	cd $(PWD)/n && make uninstall

install-node:
	n stable

test:
	@echo 'test $(version)'
	
uninstall-node:
	n rm 
	
# Cleanup routines
clean: uninstall unlink

uninstall: \
	uninstall-homebrew \
	uninstall-nvm

unlink:
	unlink $(HOME)/.bash_profile
	unlink $(HOME)/.bash_prompt
	unlink $(HOME)/.aliases
	unlink $(HOME)/.exports
	unlink $(HOME)/.extra
	unlink $(HOME)/.gitconfig
	unlink $(HOME)/.gitignore
	unlink $(HOME)/.hgrc
	unlink $(HOME)/.tm_properties
	unlink $(HOME)/.npmrc
	unlink $(HOME)/.kdiff3rc
