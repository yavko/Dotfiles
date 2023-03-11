{...}: let
  plugConfRequire = module:
    builtins.readFile (builtins.toString ./. + "/${module}.lua");
  plugConfig = builtins.concatStringsSep "\n" (map plugConfRequire [
    "lsp"
    "dap"
    "treesitter"
    "bufferline"
    "navic"
    "cmp"
    "lualine"
    "nvim-tree"
    "git"
    "toggleterm"
    "alpha"
  ]);
in ''
   require("indent_blankline").setup({
     show_current_context = true,
  	show_current_context_start = true,
  	show_end_of_line = true,
    space_char_blankline = " ",
     char_highlight_list = {
         "IndentBlanklineIndent1",
         "IndentBlanklineIndent2",
         "IndentBlanklineIndent3",
         "IndentBlanklineIndent4",
         "IndentBlanklineIndent5",
         "IndentBlanklineIndent6",
     },
   })
   require("colorizer").setup()
   require("cleanfold").setup()
   require("scrollview").setup({
  	excluded_filetypes = { "NvimTree", "alpha", "Trouble", "Outline" },
  })
   ${plugConfig}
''
