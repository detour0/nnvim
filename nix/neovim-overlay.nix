# This overlay, when applied to nixpkgs, adds the final neovim derivation to nixpkgs.
{ inputs }:
final: prev:
with final.pkgs.lib;
let
  pkgs = final;

  # Use this to create a plugin from a flake input
  mkNvimPlugin =
    src: pname:
    pkgs.vimUtils.buildVimPlugin {
      inherit pname src;
      version = src.shortRev or src.lastModifiedDate or "git"; # Fallback to "git" if no metadata
    };
  lspconfig-plugin = mkNvimPlugin inputs.lspconfig "nvim-lspconfig";

  # Make sure we use the pinned nixpkgs instance for wrapNeovimUnstable,
  # otherwise it could have an incompatible signature when applying this overlay.
  pkgs-locked = inputs.nixpkgs.legacyPackages.${pkgs.system};

  # This is the helper function that builds the Neovim derivation.
  mkNeovim = pkgs.callPackage ./mkNeovim.nix {
    inherit (pkgs-locked) wrapNeovimUnstable neovimUtils;
  };

  # A plugin can either be a package or an attrset, such as
  # { plugin = <plugin>; # the package, e.g. pkgs.vimPlugins.nvim-cmp
  #   config = <config>; # String; a config that will be loaded with the plugin
  #   # Boolean; Whether to automatically load the plugin as a 'start' plugin,
  #   # or as an 'opt' plugin, that can be loaded with `:packadd!`
  #   optional = <true|false>; # Default: false
  #   ...
  # }
  all-plugins = with pkgs.vimPlugins; [
    telescope-nvim
    telescope-fzf-native-nvim # fast sorting for tel
    plenary-nvim # telescope, neo-tree dependency

    nvim-treesitter.withAllGrammars
    nvim-treesitter-context
    nvim-treesitter-textobjects
    nvim-ts-context-commentstring
    nvim-surround # https://github.com/kylechui/nvim-surround/

    # UI
    neo-tree-nvim # File-tree explorer
    nui-nvim # neo-tree dep.
    lualine-nvim # Status line | https://github.com/nvim-lualine/lualine.nvim/
    nvim-navic # Add LSP location to lualine | https://github.com/SmiteshP/nvim-navic
    statuscol-nvim # Status column | https://github.com/luukvbaal/statuscol.nvim/
    nvim-treesitter-context # nvim-treesitter-context

    undotree
    # vim-fugitive

    nvim-unception # prevent nested nvim instances
    nvim-web-devicons # nerd font glyphs for other plugins, neo-tree opt. dep.
    
    lspconfig-plugin
    catppuccin-nvim # theme
    which-key-nvim # display keybinding info
  ];

  extraPackages = with pkgs; [
    ripgrep
    lua-language-server
    nil
    ruff
    typescript-language-server
    deno
    rust-analyzer
    gopls
    nixpkgs-fmt
    vscode-langservers-extracted # Provides html, cssls, jsonls
    prettier
    stylelint
    eslint
    tailwindcss-language-server
    marksman
    sql-formatter
    pyright
    ];

in
{
  # This is the neovim derivation
  # returned by the overlay
  nvim-pkg = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
  };

  # This is meant to be used within a devshell.
  # Instead of loading the lua Neovim configuration from
  # the Nix store, it is loaded from $XDG_CONFIG_HOME/nvim-dev
  nvim-dev = mkNeovim {
    plugins = all-plugins;
    inherit extraPackages;
    appName = "nvim-dev";
    wrapRc = false;
  };

  # This can be symlinked in the devShell's shellHook
  nvim-luarc-json = final.mk-luarc-json {
    plugins = all-plugins;
  };

  # You can add as many derivations as you like.
  # Use `ignoreConfigRegexes` to filter out config
  # files you would not like to include.
  #
  # For example:
  #
  # nvim-pkg-no-telescope = mkNeovim {
  #   plugins = [];
  #   ignoreConfigRegexes = [
  #     "^plugin/telescope.lua"
  #     "^ftplugin/.*.lua"
  #   ];
  #   inherit extraPackages;
  # };
}
