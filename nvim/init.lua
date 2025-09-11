vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Search
opt.ignorecase = true          -- search case insensitive
opt.smartcase = true           -- search matters if capital letter
opt.inccommand = "split"       -- splits screen to show all matches
opt.incsearch = true           -- Show search matches as you type
opt.hlsearch = true            -- Highlight all search matches

-- Tabs/Indents
opt.expandtab = true           -- Convert tabs to spaces
opt.tabstop = 2                -- Number of spaces that a tab represents
opt.softtabstop = 2            -- Number of spaces for tab operations (editing)
opt.shiftwidth = 2             -- Number of spaces for each indentation level
opt.smartindent = true         -- auto-indent based on syntax of the code

-- UI
opt.number = true              -- Show line numbers on the left
opt.relativenumber = true      -- Show relative line numbers (distance from cursor line)
opt.cursorline = true          -- Highlight the current cursor line
opt.lazyredraw = true          -- Don't redraw screen while executing macros (improves performance)

-- Spell checking
opt.spell = true               -- Enable spell checking
opt.spelllang = 'en'           -- Set spell checking language to English

-- Splits
opt.splitright = true          -- Vertical splits open on the right side
opt.splitbelow = true          -- Horizontal splits open below current window

-- Undo
opt.undofile = true            -- Enable persistent undo (undo history survives sessions)
opt.history = 2000             -- Number of command lines to remember in history

-- Stuff
opt.scrolloff = 5              -- keep 5 lines visible above/below the cursor when scrolling
opt.foldenable = true          -- Enable code folding
opt.nrformats = 'bin,hex'      -- Number formats recognized for CTRL-A/CTRL-X commands (binary, hexadecimal)
opt.cmdheight = 0              -- Height of the command line (0 = 1 line, minimal height)
opt.termguicolors = true       -- true color support for improved color schemes
opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]  -- Characters for filling UI elements
-- opt.colorcolumn = '100'        -- Highlight column 100 as a margin guide
-- opt.isfname:append("@-@")      -- appends @ to valid characters in file names

