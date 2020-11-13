plugins = ~/.vim/pack/writing/opt
github = https://github.com

salem:
	@echo "Sälem, Älem!"

setup:
	# Install Homebrew
	# Install contents of the Brewfile
	# Install global .gitignore
	mkdir -p ~/.config/git
	ln -s ./ignore ~/.config/git
	ln -s ./vim/vimrc ~/.vim/vimrc
	# Vim persistent undo directory
	mkdir -p ~/.vim/undodir
	# Make Home and End work like a charm
	mkdir -p ~/Library/KeyBindings
	cp ./DefaultKeyBinding.dict ~/Library/KeyBindings

plugins:
	git clone $(github)/junegunn/goyo.vim.git $(plugins)/goyo
	git clone $(github)/junegunn/limelight.vim.git $(plugins)/limelight
	git clone $(github)/mbbill/undotree.git $(plugins)/undotree
	git clone $(github)/morhetz/gruvbox.git $(plugins)/gruvbox
	git clone $(github)/plasticboy/vim-markdown.git $(plugins)/markdown
	git clone $(github)/reedes/vim-pencil.git $(plugins)/pencil

