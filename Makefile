SHELL := /bin/bash

.PHONY: all install update crontab

all: install

install: packages link_files gitconfig update

update: gitsubmodule vim_plugins crontab

packages: gitsubmodule fzf-tab
	$(HOME)/.dotfiles/ensure_minimal_packages_installed.sh

link_files:
	@for file in ackrc gemrc gitignore irbrc rspec vimrc agignore bashrc gvimrc rdebugrc tmux.conf zshrc; do \
	  if [[ -e $${HOME}/.$$file ]]; then \
	    if cmp -s $$file $${HOME}/.$$file; then \
	      echo "identical $${HOME}/.$$file"; \
	    else \
	      read -p "overwrite $${HOME}/.$$file? [ynaq] " answer; \
	      case $$answer in \
	        a) replace_all=true; $(MAKE) replace_file file=$$file;; \
	        y) $(MAKE) replace_file file=$$file;; \
	        q) exit;; \
	        *) echo "skipping $${HOME}/.$$file";; \
	      esac; \
	    fi; \
	  else \
	    $(MAKE) link_file file=$$file; \
	  fi; \
	done

replace_file:
	rm -f $(HOME)/.$(file)
	$(MAKE) link_file file=$(file)

link_file:
	@echo "linking $(HOME)/.$(file)"
	ln -s $(PWD)/$(file) $(HOME)/.$(file)

fzf-tab:
	@if [ ! -d $(HOME)/.oh-my-zsh/custom/plugins/fzf-tab ]; then \
		git clone https://github.com/Aloxaf/fzf-tab $(HOME)/.oh-my-zsh/custom/plugins/fzf-tab; \
	fi

vim_plugins:
	vim +PlugInstall +qall

gitconfig:
	@if [ ! -f $(HOME)/.gitconfig ]; then \
		read -p "Enter your git user name: " user_name; \
		read -p "Enter your git user email: " user_email; \
		read -p "Enter your GitHub user name: " github_username; \
		export user_name user_email github_username; \
		cat gitconfig.template | envsubst > $(HOME)/.gitconfig; \
	else \
		echo ".gitconfig already exists, skipping."; \
	fi

gitsubmodule:
	git submodule update --init
	git submodule foreach git pull origin master

crontab:
	@echo "Updating crontab..."
	@crontab -l > crontab.tmp; \
	cat crontab >> crontab.tmp; \
	crontab crontab.tmp; \
	rm crontab.tmp
