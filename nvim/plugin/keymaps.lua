if vim.g.did_load_keymaps_plugin then
  return
end
vim.g.did_load_keymaps_plugin = true

local api = vim.api
local fn = vim.fn
local diagnostic = vim.diagnostic
local keymap = vim.keymap
local keyset = vim.keymap.set

-- reloading config for development
keyset("n", "<leader>sv", ":luafile $MYVIMRC<CR>", { desc = "Source init.lua" })

-- Yank from current position till end of current line
keymap.set('n', 'Y', 'y$', { silent = true, desc = '[Y]ank to end of line' })

-- remove highlighting when exit search
keyset("n", "<Esc>", "<Esc>:noh<CR>")

-- replace all instances in file of word under cursor
keyset("n", "<leader>sr", ":%s/<C-r><C-w>//g<Left><Left>", {desc="search replace all"})

-- open file explorer | netrw
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex, { desc = "Open netrw" })

-- Move selected lines down/up in visual mode and re-indent
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })


-- Smart j/k movement (respect wrapped lines)
vim.keymap.set("n", "j", "(v:count ? 'j' : 'gj')", { expr = true, desc = "Smart down movement" })
vim.keymap.set("n", "k", "(v:count ? 'k' : 'gk')", { expr = true, desc = "Smart up movement" })

-- Yanks to system clipboard
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Resize windows with arrow keys
vim.keymap.set("n", "<Down>", ":resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<Up>", ":resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })
vim.keymap.set("n", "<Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })

-- Navigate quickfix lists with ctrl + j/k
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Navigate location lists with <leader> + j/k
vim.keymap.set("n", "<C-k>", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")
