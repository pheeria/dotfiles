pack = ~/.vim/pack
themes = $(pack)/themes/start
syntax = $(pack)/syntax/start
tpope = $(pack)/tpope/start
junegunn = $(pack)/junegunn/start
plugins = $(pack)/plugins/start
writing = $(pack)/writing/opt
github = git clone https://github.com

salem:
	@echo "Sälem, Älem!"

setup:
	# Install Homebrew and Brewfile targets
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
	brew bundle
	# Install global .gitignore
	mkdir -p ~/.config/git
	ln -s ./ignore ~/.config/git
	# Make Home and End work like a charm
	mkdir -p ~/Library/KeyBindings
	cp ./DefaultKeyBinding.dict ~/Library/KeyBindings

vim:
	mkdir -p ~/.vim/undodir
	ln -s ./vim/vimrc ~/.vim/vimrc
	cp ./vim/coc-settings.json ~/.vim/

	$(github)/itchyny/lightline.vim.git $(themes)/lightline
	$(github)/rakr/vim-one.git $(themes)/one
	$(github)/arcticicestudio/nord-vim.git $(themes)/nord
	$(github)/embark-theme/vim.git $(themes)/embark
	$(github)/morhetz/gruvbox.git $(themes)/gruvbox

	$(github)/tpope/vim-commentary.git $(tpope)/commentary
	$(github)/tpope/vim-fugitive.git $(tpope)/fugitive
	$(github)/tpope/vim-projectionist.git $(tpope)/projectionist
	$(github)/tpope/vim-vinegar.git $(tpope)/vinegar
	$(github)/tpope/vim-surround.git $(tpope)/surround
	$(github)/tpope/vim-repeat.git $(tpope)/repeat

	$(github)/junegunn/fzf.vim.git $(junegunn)/fzf
	$(github)/junegunn/vim-peekaboo.git $(junegunn)/peekaboo

	$(github)/leafgarland/typescript-vim.git $(syntax)/typescript
	$(github)/pangloss/vim-javascript.git $(syntax)/javascript
	$(github)/MaxMEllon/vim-jsx-pretty.git $(syntax)/jsx

	$(github)/neoclide/coc.nvim.git $(plugins)/coc
	$(github)/mbbill/undotree.git $(plugins)/undotree
	$(github)/vimwiki/vimwiki.git $(plugins)/wiki

	$(github)/junegunn/goyo.vim.git $(writing)/goyo
	$(github)/junegunn/limelight.vim.git $(writing)/limelight
	$(github)/plasticboy/vim-markdown.git $(writing)/markdown
	$(github)/reedes/vim-pencil.git $(writing)/pencil

