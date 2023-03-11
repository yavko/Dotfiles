require('plug-conf/lsp')
require('plug-conf/dap')
require('plug-conf/treesitter')
require('plug-conf/bufferline')
require('plug-conf.navic')
require('plug-conf/legendary')
--require('plug-conf/coq')
require('plug-conf/cmp')
require('plug-conf/lualine')
require('plug-conf/nvim-tree')
require('plug-conf/git')
require('plug-conf/toggleterm')
require('plug-conf/alpha')

-- Misc. Plugin Settings
require("indent_blankline").setup({
  show_current_context = true,
	show_current_context_start = true,
	show_end_of_line = true,
	space_char_blankline = " ",
})
require("colorizer").setup()
require("cleanfold").setup()
require("scrollview").setup({
	excluded_filetypes = { "NvimTree", "alpha", "Trouble", "Outline" },
})