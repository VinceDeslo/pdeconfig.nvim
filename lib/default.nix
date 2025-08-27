{inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  # Build my configuration as a Vim plugin
  mkVimPlugin = {system}: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {
      name = "pdeconfig";
      postInstall = ''
        rm -rf $out/LICENSE
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/justfile
        rm -rf $out/lib
      '';
      src = ../.;
      nvimSkipModules = [
        "init"
        "pdeconfig.telescope"
        "pdeconfig.theme"
        "pdeconfig.lsp"
        "pdeconfig.treesitter"
        "pdeconfig.ai"
        "pdeconfig.completions"
        "pdeconfig.debuggers"
      ];
    };

  # Build all my Neovim plugins
  mkNeovimPlugins = {system}: let
    inherit (pkgs) vimPlugins;
    pkgs = legacyPackages.${system};
    pdeconfig-nvim = mkVimPlugin {inherit system;};
  in [
    # Config
    pdeconfig-nvim

    # Languages
    vimPlugins.nvim-lspconfig
    vimPlugins.rustaceanvim
    vimPlugins.vim-helm

    # Treesitter
    vimPlugins.nvim-treesitter.withAllGrammars
    vimPlugins.nvim-treesitter-textobjects
    vimPlugins.nvim-treesitter-context

    # Telescope
    vimPlugins.telescope-nvim
    vimPlugins.plenary-nvim
    vimPlugins.telescope-fzf-native-nvim

    # Completions
    vimPlugins.nvim-cmp
    vimPlugins.luasnip
    vimPlugins.cmp_luasnip
    vimPlugins.cmp-nvim-lsp
    vimPlugins.friendly-snippets

    # Theme
    vimPlugins.kanagawa-nvim

    # Editor plugins
    vimPlugins.comment-nvim
    vimPlugins.gitsigns-nvim
    vimPlugins.lualine-nvim
    vimPlugins.indent-blankline-nvim
    vimPlugins.trouble-nvim
    vimPlugins.noice-nvim
    vimPlugins.nvim-notify
    vimPlugins.nui-nvim
    vimPlugins.nvim-web-devicons
    vimPlugins.which-key-nvim

    # Debuggers
    vimPlugins.nvim-dap
    vimPlugins.nvim-dap-virtual-text
    vimPlugins.nvim-dap-ui
    vimPlugins.nvim-dap-go

    # AI tooling
    vimPlugins.codecompanion-nvim
  ];

  # Build additional packages that aren't core editor functionality
  mkExtraPackages = {system}: let
    inherit (pkgs) nodePackages;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in [
    # language servers
    nodePackages.bash-language-server
    nodePackages.diagnostic-languageserver
    nodePackages.dockerfile-language-server-nodejs
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted
    nodePackages.yaml-language-server
    pkgs.nil
    pkgs.lua-language-server
    pkgs.gopls
    pkgs.helm-ls
    pkgs.terraform-ls
    pkgs.zls

    # formatters
    pkgs.alejandra
    pkgs.gofumpt
    pkgs.golines
    pkgs.rustfmt
    pkgs.terraform
  ];

  # Entrypoint for the Lua configuration of Neovim in this repo
  mkExtraConfig = ''
    lua << EOF
      require 'pdeconfig'.init()
    EOF
  '';

  # Build Neovim with my packages and plugins
  mkNeovim = {system}: let
    inherit (pkgs) lib neovim;
    extraPackages = mkExtraPackages {inherit system;};
    pkgs = legacyPackages.${system};
    start = mkNeovimPlugins {inherit system;};
  in
    neovim.override {
      configure = {
        customRC = mkExtraConfig;
        packages.main = {inherit start;};
      };
      extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
    };

  # Build the home manager entry that will be used by my dotfiles repo
  mkHomeManager = {system}: let
    extraConfig = mkExtraConfig;
    extraPackages = mkExtraPackages {inherit system;};
    plugins = mkNeovimPlugins {inherit system;};
  in {
    inherit extraConfig extraPackages plugins;
    defaultEditor = true;
    enable = true;
    withNodeJs = true;
  };
}
