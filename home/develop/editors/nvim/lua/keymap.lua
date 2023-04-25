local wk = require("which-key")

wk.setup()

-- Documentation func
local function show_documentation()
	local filetype = vim.bo.filetype
	if vim.tbl_contains({ 'vim', 'help' }, filetype) then
		vim.cmd('h ' .. vim.fn.expand('<cword>'))
	elseif vim.tbl_contains({ 'man' }, filetype) then
		vim.cmd('Man ' .. vim.fn.expand('<cword>'))
	elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
		require('crates').show_popup()
	else
		vim.lsp.buf.hover()
	end
end


-- Normal Mode Mappings
wk.register({
	["<leader>"] = {
		a = { '<cmd>AerialToggle!<CR>', "Toggle Aerial" },
		f = {
			name = "Telescope and search",
			f = { "<cmd>Telescope find_files<cr>", "Find File" },
			b = { '<cmd>Telescope buffers<CR>', "Opens buffer view" },
			l = { '<cmd>Telescope live_grep<cr>', "Search for text in all files" },
			e = { '<cmd>Telescope diagnostics<cr>', "errors" }
		},
		t = { '<cmd>NvimTreeToggle<CR>', "Toggles a file tree" }
	},
	K = { show_documentation, "Displays hover information about the symbol under the cursor." },
	g = {
		name = "LSP stuff", -- optional group name
		r = { '<cmd>lua vim.lsp.buf.rename()<cr>', "Renames all references to the symbol under the cursor." },
		x = { '<cmd>lua vim.lsp.buf.code_action()<cr>', "Prompts the user for a code action to execute" },
		d = { '<cmd>lua vim.lsp.buf.definition()<cr>', "Jumps to the definition of a something" },
		e = { '<cmd>lua vim.lsp.buf.definition()<cr>', "Shows refrences of something" },
	},
}, {})


-- local legendary = require('legendary')
-- local helpers = require('legendary.helpers')
--
-- local keymaps = {
-- 	-- Legendary
-- 	{ '<leader>L', legendary.find, description = "Search keymaps, commands, and autocmds" },
-- 	{ '<leader>Lk', helpers.lazy_required_fn('legendary', 'find', 'keymaps'), description = "Search keymaps" },
-- 	{ '<leader>Lc', helpers.lazy_required_fn('legendary', 'find', 'commands'), description = "Search commands" },
-- 	{ '<leader>La', helpers.lazy_required_fn('legendary', 'find', 'autocmds'), description = "Search autocmds" },
-- 	-- LSP
-- 	{ 'gr', '<cmd>LspRename<cr>', description = "Renames all references to the symbol under the cursor." },
-- 	{ 'gx', '<cmd>LspCodeAction<cr>', description = "Prompts the user for a code action to execute", mode = 'n' },
-- 	{ 'gx', ':<c-u>LspCodeAction<cr>', description = "Prompts the user for a code action to execute, but with a range",
-- 		mode = 'x' },
-- 	{ 'K', '<cmd>LspHover<cr>', description = "Displays hover information about the symbol under the cursor." },
-- 	{ '<leader>so', '<cmd>SymbolsOutline<cr>', description = "Opens a symbols outline window" },
-- 	{ '<leader>Tr', '<cmd>TroubleToggle<cr>', description = "Opens a error window" },
-- 	-- misc
-- 	{ '<leader>t', '<cmd>NvimTreeToggle<CR>', description = "Toggles a file tree" },
-- 	{ '<leader>Ts', '<cmd>Telescope buffers<CR>', description = "Opens buffer view" }
-- }
--
-- legendary.bind_keymaps(keymaps)
--
-- --vim.keymap.set("n", "gx", "<cmd>LspCodeAction<cr>", {silent = true})
-- --vim.keymap.set("x", "gx", ":<c-u>LspCodeAction<cr>", {silent = true})
