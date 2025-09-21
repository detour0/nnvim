if vim.g.did_load_catppuccin_plugin then
  return
end
vim.g.did_load_catppuccin_plugin  = true

require("catppuccin").setup({
      flavour = "mocha",  -- Choose "mocha" flavor here
      integrations = {
        treesitter = true,  -- Enable highlight integration with treesitter
        telescope = true,   -- Support for telescope plugin highlights
        native_lsp = {
          enabled = true,   -- Enable LSP color integrations
        },
        -- mason = true,       -- Support for mason.nvim
        -- Add other plugin integrations here if needed
      },
    })
    vim.cmd.colorscheme("catppuccin")
