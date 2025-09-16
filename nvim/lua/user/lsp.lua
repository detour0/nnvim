---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]
-- LSP configuration for requested languages
-- LSP configuration for requested languages
local lspconfig = require('lspconfig')
local util = require('lspconfig.util')

-- Common on_attach function for keymaps and format-on-save
local on_attach = function(client, bufnr)
  -- Enable formatting on save (if server supports it)
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ async = false })
      end,
    })
  end

  -- Keymaps for LSP actions
  local opts = { buffer = bufnr, noremap = true, silent = true }
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
end

-- Python (ruff)
lspconfig.ruff.setup({
  on_attach = on_attach,
  init_options = {
    settings = {
      lint = { enable = true },
      format = { enable = true },
    },
  },
})

-- JavaScript/TypeScript with Node (ts_ls, avoid Deno projects)
lspconfig.ts_ls.setup({
  on_attach = on_attach,
  root_dir = function(fname)
    if util.root_pattern("deno.json", "deno.jsonc")(fname) then
      return nil
    end
    return util.root_pattern("package.json", "tsconfig.json")(fname) or util.find_git_ancestor(fname)
  end,
  single_file_support = false,
})

-- JavaScript/TypeScript with Deno (denols)
lspconfig.denols.setup({
  on_attach = on_attach,
  root_dir = util.root_pattern("deno.json", "deno.jsonc"),
})

-- Rust (rust_analyzer)
lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  settings = {
    ["rust-analyzer"] = {
      check = { command = "clippy" },
      cargo = { allFeatures = true },
      rustfmt = { extraArgs = { "+nightly" } },
    },
  },
})

-- Lua (lua_ls)
lspconfig.lua_ls.setup({
  on_attach = on_attach,
  settings = {
    Lua = {
      diagnostics = { globals = { 'vim' } },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
})

-- Nix (nil_ls, with nixpkgs-fmt for formatting)
lspconfig.nil_ls.setup({
  on_attach = function(client, bufnr)
    -- Disable nil_ls formatting since it doesn't support it
    client.server_capabilities.documentFormattingProvider = false
    on_attach(client, bufnr)
  end,
})

-- Go (gopls)
lspconfig.gopls.setup({
  on_attach = on_attach,
  settings = {
    gopls = {
      gofumpt = true,
      staticcheck = true,
    },
  },
})

-- Nix formatting with nixpkgs-fmt (since nil_ls doesn't format)
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.nix",
  callback = function()
    vim.cmd("!nixpkgs-fmt %")
  end,
})
