vim.g.minimap_width = 10
vim.g.minimap_auto_start = 0
vim.g.minimap_auto_start_win_enter = 0
vim.g.mapleader = ";"
vim.g.dracula_transparent_bg = true
vim.g.dracula_show_end_of_buffer = false
vim.g.do_filetype_lua = 1
vim.g.cursorword_disable_filetypes = { "NvimTree", "alpha", "Trouble", "Outline" }
vim.opt.laststatus = 3
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.spell = true
vim.opt.spelllang = { "en", "programming", "fr", "bg" }
vim.opt.mouse = "a"
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.list = true
vim.opt.scrolloff = 1
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.go.listchars = "eol:↴,tab:⇥ ,space:·"
vim.wo.fillchars = 'eob: '
vim.opt.whichwrap:append("<,>,[,]")
vim.opt.showbreak = "↪ "
vim.opt.undofile = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.wrap = true
vim.opt.guifont = "JetBrainsMono Nerd Font Mono Regular:h13"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = true
vim.opt.foldlevel = 1000
vim.opt.hidden = true
vim.diagnostic.config({
	virtual_text = false,
	virtual_lines = true
})
vim.g.coq_settings = {
	auto_start = 'shut-up',
	display = {
		pum = {
			fast_close = true
		}
	}
}


vim.filetype.add({
	extension = {
		mcmeta = "json",
		astro = "astro",
		njk = "html",
		v = "v"
	}
})
