pack = $(HOME)/.vim/pack
visual = $(pack)/visual/start
tpope = $(pack)/tpope/start
junegunn = $(pack)/junegunn/start
plugins = $(pack)/plugins/start
github = https://github.com
codespaces_packages = curl fzf git nodejs npm python3 python3-pip ripgrep stow vim

.PHONY: salem codespaces setup setup-codespaces stow stow-codespaces pip vim vim-dirs

define clone_repo
	@mkdir -p "$(dir $(2))"
	@if [ -d "$(2)/.git" ]; then \
		echo "Updating $(2)"; \
		git -C "$(2)" pull --ff-only || { echo "Failed to update $(2); run git -C \"$(2)\" status, then commit/stash local changes or resolve conflicts before retrying."; exit 1; }; \
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
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	brew bundle

setup-codespaces:
	sudo apt-get update
	sudo apt-get install -y $(codespaces_packages)

stow:
	stow ghostty
	stow git
	stow zsh
	stow nvim
	# Make Home and End work like a charm
	stow misc

stow-codespaces:
	stow git
	stow vim
	@mkdir -p "$(HOME)/.vim/undodir"

vim: vim-dirs
	$(call clone_repo,rakr/vim-one,$(visual)/one)
	$(call clone_repo,arcticicestudio/nord-vim,$(visual)/nord)
	$(call clone_repo,embark-theme/vim,$(visual)/embark)
	$(call clone_repo,rose-pine/vim,$(visual)/rose-pine)
	$(call clone_repo,leafgarland/typescript-vim,$(visual)/typescript)
	$(call clone_repo,pangloss/vim-javascript,$(visual)/javascript)
	$(call clone_repo,MaxMEllon/vim-jsx-pretty,$(visual)/jsx)

	$(call clone_repo,tpope/vim-commentary,$(tpope)/commentary)
	$(call clone_repo,tpope/vim-fugitive,$(tpope)/fugitive)
	$(call clone_repo,tpope/vim-projectionist,$(tpope)/projectionist)
	$(call clone_repo,tpope/vim-repeat,$(tpope)/repeat)
	$(call clone_repo,tpope/vim-sleuth,$(tpope)/sleuth)
	$(call clone_repo,tpope/vim-surround,$(tpope)/surround)
	$(call clone_repo,tpope/vim-unimpaired,$(tpope)/unimpaired)
	$(call clone_repo,tpope/vim-vinegar,$(tpope)/vinegar)

	$(call clone_repo,junegunn/fzf.vim,$(junegunn)/fzf)
	$(call clone_repo,junegunn/goyo.vim,$(junegunn)/goyo)
	$(call clone_repo,junegunn/limelight.vim,$(junegunn)/limelight)

	$(call clone_repo,neoclide/coc.nvim,$(plugins)/coc)
	$(call clone_repo,plasticboy/vim-markdown,$(plugins)/markdown)
	$(call clone_repo,reedes/vim-pencil,$(plugins)/pencil)
	$(call clone_repo,vim-test/vim-test,$(plugins)/test)
	$(call clone_repo,vimwiki/vimwiki,$(plugins)/wiki)


vim-dirs:
	@mkdir -p "$(visual)" "$(tpope)" "$(junegunn)" "$(plugins)"
