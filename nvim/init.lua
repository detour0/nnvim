vim.loader.enable()

local cmd = vim.cmd
local opt = vim.o

opt.ignorecase = true      -- search case insensitive
opt.smartcase = true       -- search matters if capital letter
opt.inccommand = "split"   -- splits screen to show all matches