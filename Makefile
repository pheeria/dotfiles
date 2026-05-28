pack = $(HOME)/.vim/pack
themes = $(pack)/themes/start
syntax = $(pack)/syntax/start
tpope = $(pack)/tpope/start
junegunn = $(pack)/junegunn/start
plugins = $(pack)/plugins/start
writing = $(pack)/writing/opt
github = https://github.com
codespaces_packages = curl fzf git nodejs npm python3 python3-pip ripgrep stow vim

.PHONY: salem codespaces setup setup-codespaces stow stow-codespaces pip vim vim-dirs

define clone_repo
	@mkdir -p "$(dir $(2))"
	@if [ -d "$(2)/.git" ]; then \
		echo "Updating $(2)"; \
		git -C "$(2)" pull --ff-only || { echo "Failed to update $(2); resolve local changes or conflicts and retry."; exit 1; }; \
	else \
		echo "Cloning $(1)"; \
		git clone "$(github)/$(1).git" "$(2)"; \
	fi
endef

salem:
	@echo "Sälem, Älem!"

codespaces: setup-codespaces stow-codespaces vim

setup:
	# Install Homebrew and Brewfile targets
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew bundle

setup-codespaces:
	sudo apt-get update
	sudo apt-get install -y $(codespaces_packages)

stow:
	stow wezterm
	stow git
	stow zsh
	stow vim
	stow nvim
	# Make Home and End work like a charm
	stow misc

stow-codespaces:
	stow git
	stow vim
	@mkdir -p "$(HOME)/.vim/undodir"

pip:
	python3 -m pip install --upgrade pip
	pip3 install lookatme
	pip3 install duden

vim: vim-dirs
	$(call clone_repo,rakr/vim-one,$(themes)/one)
	$(call clone_repo,arcticicestudio/nord-vim,$(themes)/nord)
	$(call clone_repo,embark-theme/vim,$(themes)/embark)
	$(call clone_repo,morhetz/gruvbox,$(themes)/gruvbox)
	$(call clone_repo,rose-pine/vim,$(themes)/rose-pine)

	$(call clone_repo,tpope/vim-commentary,$(tpope)/commentary)
	$(call clone_repo,tpope/vim-fugitive,$(tpope)/fugitive)
	$(call clone_repo,tpope/vim-projectionist,$(tpope)/projectionist)
	$(call clone_repo,tpope/vim-vinegar,$(tpope)/vinegar)
	$(call clone_repo,tpope/vim-surround,$(tpope)/surround)
	$(call clone_repo,tpope/vim-repeat,$(tpope)/repeat)
	$(call clone_repo,tpope/vim-sleuth,$(tpope)/sleuth)

	$(call clone_repo,junegunn/fzf.vim,$(junegunn)/fzf)
	$(call clone_repo,junegunn/vim-peekaboo,$(junegunn)/peekaboo)

	$(call clone_repo,leafgarland/typescript-vim,$(syntax)/typescript)
	$(call clone_repo,pangloss/vim-javascript,$(syntax)/javascript)
	$(call clone_repo,MaxMEllon/vim-jsx-pretty,$(syntax)/jsx)

	$(call clone_repo,neoclide/coc.nvim,$(plugins)/coc)
	$(call clone_repo,mbbill/undotree,$(plugins)/undotree)
	$(call clone_repo,vimwiki/vimwiki,$(plugins)/wiki)
	$(call clone_repo,vim-test/vim-test,$(plugins)/test)

	$(call clone_repo,junegunn/goyo.vim,$(writing)/goyo)
	$(call clone_repo,junegunn/limelight.vim,$(writing)/limelight)
	$(call clone_repo,plasticboy/vim-markdown,$(writing)/markdown)
	$(call clone_repo,reedes/vim-pencil,$(writing)/pencil)

vim-dirs:
	@mkdir -p "$(themes)" "$(syntax)" "$(tpope)" "$(junegunn)" "$(plugins)" "$(writing)"
