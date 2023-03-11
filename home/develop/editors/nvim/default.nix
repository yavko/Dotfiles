{
  pkgs,
  lib,
	inputs,
  ...
} @ args: {
  #home.packages = with pkgs; [ neovim ];
  programs.neovim = {
    enable = true;

    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;

    plugins = let
      dirtytalk = pkgs.vimUtils.buildVimPlugin {
        name = "vim-dirtytalk";
        src = inputs.vim-dirtytalk;
      };
      nvim-treesitter-endwise = pkgs.vimUtils.buildVimPlugin {
        name = "nvim-treesitter-endwise";
        src = inputs.nvim-treesitter-endwise;
      };
      cleanfold = pkgs.vimUtils.buildVimPlugin {
        name = "cleanfold-nvim";
        src = inputs.nvim-cleanfold;
      };
      config = pkgs.vimUtils.buildVimPlugin {
        name = "config";
        src = lib.cleanSourceWith {
          filter = name: _type: let
            baseName = baseNameOf (toString name);
          in
            !(lib.hasSuffix ".nix" baseName);
          src = lib.cleanSource ./.;
        };
      };
    in
      with pkgs.vimPlugins; [
        impatient-nvim
        #nvim-notify
        nvim-web-devicons
        plenary-nvim
        popfix
        dressing-nvim
        catppuccin-nvim
        gitsigns-nvim
        neogit
        telescope-nvim
				vim-html-template-literals
				vim-javascript

        # LSP
        nvim-lspconfig
        #nlsp-settings-nvim
        #mason-nvim
        #mason-lspconfig-nvim
        null-ls-nvim
        #nvim-lsp-basics
        fidget-nvim
        lsp_lines-nvim
        aerial-nvim
        #symbols-outline-nvim
        trouble-nvim
        lsp-format-nvim
        #hlargs-nvim
        #schemastore-nvim
        rust-tools-nvim
				nvim-jdtls
        lspkind-nvim

        which-key-nvim
        nvim-navic
        bufferline-nvim
        nvim-tree-lua
        friendly-snippets
        luasnip

        # Completion
        nvim-cmp
        cmp-cmdline
        cmp-path
        cmp-buffer
        cmp-nvim-lsp
        cmp_luasnip
        #cmp-ctags
        cmp-nvim-lua
        cmp-omni
        cmp-treesitter
        lsp_signature-nvim

        # Treesitter
        (nvim-treesitter.withPlugins (_: pkgs.tree-sitter.allGrammars))
        playground
        nvim-treesitter-context
        nvim-ts-rainbow
        spellsitter-nvim
        comment-nvim
        nvim-ts-autotag
        nvim-treesitter-endwise
        nvim-autopairs

        alpha-nvim
        #cinnamon-nvim #config
        lualine-nvim
        indent-blankline-nvim #config
        nvim-colorizer-lua #config
        toggleterm-nvim
        dirtytalk
        cleanfold #config
        nvim-scrollview #config
        markdown-preview-nvim
        # Debug Adapter Protocol (wip, and disabled)
        nvim-dap
        nvim-dap-ui

        editorconfig-nvim
        yuck-vim
        vim-parinfer

        # My config
        config
      ];
    #package = pkgs.neovim-nightly;
    extraPackages = with pkgs; [gcc ripgrep fd];
    extraConfig = let
      luaRequire = module:
        builtins.readFile (builtins.toString ./lua + "/${module}.lua");
      #luaConfig = builtins.concatStringsSep "\n" (map luaRequire [
      #  "theme"
      #  "options"
      #  "ui"
      #  "keymap"
      #]);
      #pluginConfigs = import ./lua/plug-conf args;
    in ''
      lua << EOF
      require("impatient")
      require("config")
      EOF
    '';
  };

  # add config
  #xdg.configFile."nvim/lua".source = lib.cleanSourceWith {
  #  filter = name: _type: let
  #    baseName = baseNameOf (toString name);
  #  in
  #    !(lib.hasSuffix ".nix" baseName);
  #  src = lib.cleanSource ./lua;
  #};
}
