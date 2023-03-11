require('lualine').setup {
	options = {
		--theme = 'dracula-nvim',
		theme = 'catppuccin',
		component_separators = { left = '', right = '' },
		section_separators = { left = '', right = '' },
		globalstatus = true
	},
	extensions = { 'nvim-tree' }
}
