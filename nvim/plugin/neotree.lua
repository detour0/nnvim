if vim.g.did_load_neotree_plugin then
  return
end
vim.g.did_load_neotree_plugin = true

local opts = {
  hide_root_node = true,
  retain_hidden_root_indent = true,
  filesystem = {
    filtered_items = {
      hide_dotfiles = false,
    },
  },
  ["<tab>"] = function(state)
  state.commands["open"](state)
  vim.cmd("Neotree reveal")
end,
  default_component_configs = {
    indent = {
      with_expanders = true,
      expander_collapsed = '',
      expander_expanded = '',
    },
  },
}
-- opts.nesting_rules = require('neotree-file-nesting-config').nesting_rules
require('neo-tree').setup(opts)
vim.keymap.set("n", "<C-e>", ":Neotree toggle<CR>")
