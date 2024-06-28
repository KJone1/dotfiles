local g = vim.g -- Global variables
local opt = vim.opt -- Set options (global/buffer/windows-scoped)vim.cmd 'set expandtab'

-----------------------------------------------------------
-- General
-----------------------------------------------------------

opt.wrap = false
opt.number = true
opt.relativenumber = true
opt.mouse = 'a' -- Enable mouse mode
opt.clipboard = 'unnamedplus' -- Sync clipboard between OS and Neovim.
opt.undofile = true -- Save undo history
opt.swapfile = false
opt.ignorecase = true -- Case-insensitive searching UNLESS \C or capital in search
opt.smartcase = true

-----------------------------------------------------------
-- Tabs, indent
-----------------------------------------------------------

vim.cmd 'set tabstop=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set shiftwidth=2'
opt.breakindent = true
opt.smartindent = true -- Enable auto indenting and set it to spaces
opt.shiftwidth = 2

-----------------------------------------------------------
-- Neovim UI
-------------------------------------------------------------

opt.cursorline = true -- Enable cursor line highlight
-- disable netrw at the very start of your init.lua
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
-- optionally enable 24-bit colour
opt.termguicolors = true
-- Set highlight on search
opt.hlsearch = true
opt.incsearch = true
opt.signcolumn = 'yes' -- Keep signcolumn on by default
-- Decrease update time
opt.updatetime = 250
opt.timeoutlen = 300
-- Set completeopt to have a better completion experience
opt.completeopt = 'menuone,noselect'
