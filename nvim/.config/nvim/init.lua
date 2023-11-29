-- Install packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
end

local packer = require('packer')
local use = packer.use
packer.startup(function()
  use('wbthomason/packer.nvim') -- Package manager
  use('tpope/vim-fugitive') -- Git commands in nvim
  use('tpope/vim-commentary') -- 'gc' to comment visual regions/lines
  use('tpope/vim-projectionist') -- Alternate files
  use('tpope/vim-vinegar') -- File explorer
  use('tpope/vim-surround') -- Surround objects
  use('tpope/vim-repeat') -- Repeat surround
  use('tpope/vim-sleuth') -- Sleuth
  use('tpope/vim-sexp-mappings-for-regular-people') -- Tpope sexp
  use('guns/vim-sexp') -- Sexp
  use({ 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/popup.nvim' }, { 'nvim-lua/plenary.nvim' } } }) -- UI to select things (files, grep results, open buffers...)
  use('nvim-treesitter/nvim-treesitter') -- Highlight, edit, and navigate code using a fast incremental parsing library
  use('nvim-treesitter/nvim-treesitter-textobjects') -- Additional textobjects for treesitter
  use('neovim/nvim-lspconfig') -- Collection of configurations for built-in LSP client
  use('hrsh7th/cmp-nvim-lsp') -- Default capabilities (?!)
  use('hrsh7th/nvim-cmp') -- Autocompletion
  use('fenetikm/falcon') -- Colorscheme
  use('Olical/conjure') -- Clojure REPL
  use('PaterJason/cmp-conjure') -- Conjure Autocompletion
end)

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.swapfile = false
vim.opt.emoji = false
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.signcolumn = 'number'

vim.opt.hlsearch = false -- Set highlight on search
vim.wo.number = true -- Make line numbers default
vim.opt.breakindent = true -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.exrc = true
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.completeopt = 'menuone,noinsert' -- Have a better completion experience

-- Case insensitive searching UNLESS /C or capital in search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Set colorscheme (order is important here)
vim.cmd([[
    set termguicolors
    colorscheme falcon
    highlight Normal guibg=#020221
]])

-- Remap space as leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.keymap.set('n', '<leader>vc', ':vs ~/.config/nvim/init.lua<cr>')
vim.keymap.set('n', '<leader>nt', ':tabnew<CR>:terminal<CR>i')

-- Vinegar
vim.opt.wildignore = '__pycache__/,*.pyc,.DS_Store'

-- Allow to move files to another (say, parent) directory
vim.cmd([[
    let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
    let g:netrw_keepdir = 0

    augroup Netrw
        autocmd!
        autocmd FileType netrw setlocal bufhidden=wipe
    augroup END
]])

-- Sexp
vim.g.sexp_enable_insert_mode_mappings = 0

-- Telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>b', telescope.buffers)
vim.keymap.set('n', '<leader>f', telescope.find_files)
vim.keymap.set('n', '<leader>g', telescope.live_grep)

-- LSP settings
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

local function on_attach(client, bufnr)
  local opts = { silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

  -- Set some keybinds conditional on server capabilities
  if client.server_capabilities.document_formatting then
    vim.keymap.set('n', '<space>cf', vim.lsp.buf.formatting, opts)
  elseif client.server_capabilities.document_range_formatting then
    vim.keymap.set('n', '<space>cf', vim.lsp.buf.range_formatting, opts)
  end
end

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

local cmp = require('cmp')

cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args) end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
      end
    end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp', keyword_length = 3 },
    { name = 'conjure' },
  })
})

local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities()
local lsp_clients = {'clojure_lsp', 'pyright'}
for _, client in pairs(lsp_clients) do
    lspconfig[client].setup({
        on_attach = on_attach,
        capabilities = capabilities
    })
end

-- Treesitter configuration
-- Parsers must be installed manually via :TSInstall
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true, -- false will disable the whole extension
  },
  ensure_installed = { "clojure", "python" },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = 'gnn',
      node_incremental = 'grn',
      scope_incremental = 'grc',
      node_decremental = 'grm',
    },
  },
  indent = {
    enable = true,
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
        ['al'] = '@loop.outer',
        ['il'] = '@loop.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
  },
})
