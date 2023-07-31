{pkgs, inputs, ...}: let
  sugar = {
    enable = true;
    treesitter.enable = true;
    lsp.enable = true;
    dap.enable = true;
    format.enable = true;
  };
in {
  programs.neovim-flake = {
    enable = true;
    settings = {
      vim = {
        autoIndent = true;
        autocomplete = {
          enable = true;
        };
        autopairs = {
          enable = true;
        };
        bell = "on";
        binds.whichKey.enable = true;
        comments.comment-nvim = {
          enable = true;
        };
        dashboard.alpha.enable = true;
        debugger.nvim-dap = {
          enable = true;
          ui.enable = true;
        };
        disableArrows = true;
        enableLuaLoader = true;
        filetree.nvimTreeLua = {
          enable = true;
          git.enable = true;
          hijackCursor = true;
          hijackUnnamedBufferWhenOpening = true;
          renderer = {
            groupEmptyFolders = true;
            highlightOpenedFiles = "name";
            icons.show.git = true;
            indentMarkers = true;
          };
        };
        git = {
          enable = true;
          gitsigns = {
            enable = true;
            codeActions = true;
          };
        };
        languages = {
          enableDAP = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableLSP = true;
          enableTreesitter = true;
          clang = {
            inherit (sugar) enable dap treesitter;
            lsp = {
              enable = true;
              server = "clangd";
            };
          };
          html = {
            inherit (sugar) enable treesitter;
          };
          markdown = {
            inherit (sugar) enable treesitter;
            glow.enable = true;
          };
          nix = {
            inherit (sugar) enable treesitter lsp format;
          };
          python = {
            inherit (sugar) enable treesitter lsp format dap;
          };
          rust = {
            inherit (sugar) enable treesitter lsp dap;
            crates.enable = true;
          };
          ts = {
            inherit (sugar) enable treesitter lsp;
            extraDiagnostics.enable = true;
            format = {
              enable = true;
              #type = "prettierd";
            };
          };
        };
        lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = false;
          lspSignature.enable = true;
          lspconfig.enable = true;
          lspkind.enable = true;
          lspsaga = {
            # enable = true;
          };
          null-ls.enable = true;
          trouble.enable = true;
        };
        mapLeaderSpace = false;
        minimap.codewindow.enable = true;
        notes = {
          orgmode.enable = true;
          todo-comments.enable = true;
        };
        notify.nvim-notify.enable = true;
        snippets.vsnip.enable = true;
        spellChecking.enable = true;
        statusline.lualine.enable = true;
        tabline.nvimBufferline.enable = true;
        telescope.enable = true;
        terminal.toggleterm = {
          enable = true;
          enable_winbar = true;
          direction = "float";
          lazygit = {
            enable = true;
            direction = "float";
          };
        };
        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
        };
        treesitter = {
          enable = true;
          autotagHtml = true;
          context = {
            enable = true;
            maxLines = 5;
          };
          fold = true;
        };
        ui = {
          borders = {
            enable = true;
            globalStyle = "rounded";
          };
          breadcrumbs = {
            enable = true;
            navbuddy.enable = true;
          };
          colorizer.enable = true;
          modes-nvim = {
            enable = true;
          };
          noice.enable = true;
        };
        useSystemClipboard = true;
        utility = {
          ccc.enable = true;
          icon-picker.enable = true;
          motion = {
            leap.enable = true;
          };
        };
        viAlias = true;
        vimAlias = true;
        visuals = {
          enable = true;
          cursorWordline.enable = true;
          fidget-nvim.enable = true;
          indentBlankline = {
            enable = true;
            useTreesitter = true;
          };
          nvimWebDevicons.enable = true;
          scrollBar.enable = true;
          smoothScroll.enable = true;
        };
        wordWrap = true;
				luaConfigRC.setLeader = inputs.neovim-flake.lib.nvim.dag.entryAnywhere ''
          vim.g.mapleader = ";"
				'';
				extraPlugins = with pkgs.vimPlugins; {
					lspLines = {
						package = lsp_lines-nvim;
						setup = ''
							require("lsp_lines").setup()
							vim.diagnostic.config({
  							virtual_text = false,
							})
						'';
					};
				};
      };
    };
  };
}
