-- [[ Setting options ]]
-- See `:help vim.o`

-- Security, so that nobody can override the settings
vim.o.modelines = 0

vim.o.hidden = true

vim.o.ruler = true

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable relative line numbers
-- vim.o.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'
-- Alternative solution could be the following two lines
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Set autoindent
vim.o.smartindent = true
vim.o.autoindent = true

-- Use spaces instead of tabs
vim.o.expandtab = true

-- Set tabstop to 4 spaces
vim.o.tabstop = 4

-- Set softtabstop to 4 spaces
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 50
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Blink cursor instead of beeping
vim.o.visualbell = true

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- Set different color for the column 80
-- vim.o.colorcolumn = "80"

-- Cursor is always the same
vim.o.guicursor = ""

vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false

vim.o.wrap = true
vim.o.linebreak = true
vim.o.textwidth = 500

-- Minimal number of lines to keep above and below cursor
vim.o.scrolloff = 8

-- Show pattern when searching
vim.o.incsearch = true
