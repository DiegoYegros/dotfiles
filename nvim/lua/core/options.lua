vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.transparent_groups = vim.list_extend(vim.g.transparent_groups or {}, { 'ExtraGroup' })
vim.g.transparent_enabled = true
-- Set to true if you have a Nerd Font installed
vim.g.have_nerd_font = true

local option = vim.opt
-- Make line numbers default
option.number = true
-- You can also add relative line numbers, for help with jumping.
--  Experiment for yourself to see if you like it!
option.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
option.mouse = 'a'

-- Disable swap files
option.swapfile = false

-- Don't show the mode, since it's already in status line
option.showmode = true

-- Change cursor from Block type to Beam |
option.guicursor = 'n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20'
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
option.clipboard:append { 'unnamedplus' }
-- Enable break indent
option.breakindent = true

-- Save undo history
option.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
option.ignorecase = true
option.smartcase = true

-- Keep signcolumn on by default
option.signcolumn = 'yes'

-- Decrease update time
option.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
option.timeoutlen = 300

-- Configure how new splits should be opened
option.splitright = true
option.splitbelow = true

-- Sets how neovim will display certain whitespace in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
option.list = true
option.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
option.inccommand = 'split'

-- Show which line your cursor is on
option.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
option.scrolloff = 10

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Set highlight on search, but clear on pressing <Esc> in normal mode
option.hlsearch = true
