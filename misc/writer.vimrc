set nocompatible
set termguicolors 
syntax enable
colorscheme gruvbox 
set background=dark

" Always show the status line at the bottom, even if you only have one window open.
set laststatus=2
set noerrorbells visualbell t_vb=	 " Disable audible bell because it's annoying

filetype plugin on
set nowrap
set noshowmode

set noswapfile
set number                          " show line numbers
set backspace=indent,eol,start
set ignorecase                      " search is case-insensitive, until a capital letter is added
set smartcase

set incsearch                       " search as characters are entered
set showcmd                         " display incomplete commands
set wildmenu			    " visual autocomplete for command menu

" Switch faster between Insert and Normal modes
set timeout timeoutlen=3000 ttimeoutlen=100

" Remap Caps Lock to Escape in Vim
autocmd VimEnter * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
autocmd VimLeave * silent! !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

let mapleader = " "
nnoremap <leader>q :bd<CR>
nnoremap <leader>w :write<CR>
nnoremap <leader>s :Goyo<CR> :SoftPencil<CR>
nnoremap <leader>t :Toc<CR>

" UNDOTREE
" ---- --
set undodir=~/.vim/undodir
set undofile
nnoremap <leader>u :UndotreeToggle<CR>

" Goyo / Limelight
" ---- --
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Markdown
" ---- --
let g:vim_markdown_folding_disabled = 1

" Different cursors for Insert and Normal modes
" ---- --
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"
