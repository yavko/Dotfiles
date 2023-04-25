--local coq = require("coq")
local lspconfig = require("lspconfig")
local nlsp_status, nlsps = pcall(require, "nlspsettings")
local b_status, basics = pcall(require, "lsp_basics")
local format = require("lsp-format")
local navic = require("nvim-navic")

format.setup({})

require("fidget").setup({
	window = {
		blend = 0,
	},
})
require("lsp_lines").setup()
require('rust-tools').setup({})

require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', {buffer = bufnr})
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', {buffer = bufnr})
  end
})

if nlsp_status then
	nlsps.setup({
		config_home = vim.fn.stdpath("config") .. "/nlsp-settings",
		local_settings_dir = ".nlsp-settings",
		local_settings_root_markers = { ".git" },
		append_default_schemas = true,
		loader = "json",
	})
end

function on_attach(client, bufnr)
	if b_status then
		basics.make_lsp_commands(client, bufnr)
		basics.make_lsp_mappings(client, bufnr)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
	buf_set_option("formatexpr", "v:lua.vim.lsp.formatexpr()")
	buf_set_option("tagfunc", "v:lua.vim.lsp.tagfunc")
end

--local capabilities = vim.lsp.protocol.make_client_capabilities()
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = vim.tbl_extend(
	'keep',
	vim.lsp.protocol.make_client_capabilities(),
	require('cmp_nvim_lsp').default_capabilities()
);

capabilities.textDocument.completion.completionItem.snippetSupport = true

local m_status, mason = pcall(require, "mason")

if m_status then
	require("mason").setup({
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	})
end

local null_ls = require("null-ls")

null_ls.setup({
	sources = {
		null_ls.builtins.formatting.stylua,
		--null_ls.builtins.formatting.alejandra
	},
})

local servers

local mlc_status, mlc = pcall(require, "mason-lspconfig")
if mlc_status then
	mlc.setup({})
	servers = mlc.get_installed_servers()
else
	--servers = {"nil_ls", "rust_analyzer"}
	local lspss, lsps = pcall(require, "lsps")
	if lspss then
		servers = lsps
	end
end

for _, server in ipairs(servers) do
	local config = {
		capabilities = capabilities,
		flags = { debounce_text_changes = 500 },
		on_attach = function(client, bufnr)
			format.on_attach(client)
			if b_status then
				basics.make_lsp_commands(client, bufnr)
				basics.make_lsp_mappings(client, bufnr)
			end
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
			if client.server_capabilities.documentSymbolProvider then
				navic.attach(client, bufnr)
			end
			-- require "lsp_signature".on_attach({
			-- 	bind = true, -- This is mandatory, otherwise border config won't get registered.
			-- 	handler_opts = {
			-- 		border = "rounded"
			-- 	}
			-- }, bufnr)
		end,
		settings = {}
	}
	if server == "tsserver" then
--		config.root_dir = lspconfig.util.root_pattern("package.json")
	elseif server == "denols" then
		config.root_dir = lspconfig.util.root_pattern("deno.json")
	elseif server == "jsonls" or server == "yamlls" then
		local ss_status, ss = pcall(require, "schemastore")
		if ss_status then
			if server == "jsonls" then
				config.settings["json"].schemas = ss.json.schemas()
			else
				config.settings["yaml"].schemas = ss.yaml.schemas()
			end
		end
		config.validate = { enable = true }
	elseif server == "nil_ls" then
		config.autostart = true
		config.settings["nil"] = {
			testSetting = 42,
			formatting = {
				command = { "alejandra" }
			}
		}
	elseif server == "lua_ls" then
		config.settings["Lua"] = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
      },
      telemetry = {
        enable = false,
      },
    }
	elseif server == "rust_analyzer" then
		config.settings["rust-analyzer"] = {
			checkOnSave = {
				command = "clippy"
			}
		}
	end

	lspconfig[server].setup(config)
end

vim.g.symbols_outline = {
	highlight_hovered_item = true,
	show_guides = true,
	auto_preview = true,
	position = "right",
	relative_width = true,
	width = 25,
	auto_close = false,
	show_numbers = false,
	show_relative_numbers = false,
	show_symbol_details = true,
	preview_bg_highlight = "Pmenu",
	keymaps = { -- These keymaps can be a string or a table for multiple keys
		close = { "<Esc>", "q" },
		goto_location = "<Cr>",
		focus_location = "o",
		hover_symbol = "<C-space>",
		toggle_preview = "K",
		rename_symbol = "r",
		code_actions = "a",
	},
	lsp_blacklist = {},
	symbol_blacklist = {},
	symbols = {
		File = { icon = "", hl = "TSURI" },
		Module = { icon = "", hl = "TSNamespace" },
		Namespace = { icon = "", hl = "TSNamespace" },
		Package = { icon = "", hl = "TSNamespace" },
		Class = { icon = "𝓒", hl = "TSType" },
		Method = { icon = "ƒ", hl = "TSMethod" },
		Property = { icon = "", hl = "TSMethod" },
		Field = { icon = "", hl = "TSField" },
		Constructor = { icon = "", hl = "TSConstructor" },
		Enum = { icon = "ℰ", hl = "TSType" },
		Interface = { icon = "ﰮ", hl = "TSType" },
		Function = { icon = "λ", hl = "TSFunction" },
		Variable = { icon = "", hl = "TSConstant" },
		Constant = { icon = "", hl = "TSConstant" },
		String = { icon = "𝓐", hl = "TSString" },
		Number = { icon = "#", hl = "TSNumber" },
		Boolean = { icon = "⊨", hl = "TSBoolean" },
		Array = { icon = "", hl = "TSConstant" },
		Object = { icon = "⦿", hl = "TSType" },
		Key = { icon = "🔐", hl = "TSType" },
		Null = { icon = "NULL", hl = "TSType" },
		EnumMember = { icon = "", hl = "TSField" },
		Struct = { icon = "𝓢", hl = "TSType" },
		Event = { icon = "🗲", hl = "TSType" },
		Operator = { icon = "+", hl = "TSOperator" },
		TypeParameter = { icon = "𝙏", hl = "TSParameter" },
	},
}
require("trouble").setup({
	position = "bottom", -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	icons = true, -- use devicons for filenames
	mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	fold_open = "", -- icon used for open folds
	fold_closed = "", -- icon used for closed folds
	group = true, -- group results by file
	padding = true, -- add an extra new line on top of the list
	action_keys = { -- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = "q", -- close the list
		cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
		refresh = "r", -- manually refresh
		jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
		open_split = { "<c-x>" }, -- open buffer in new split
		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
		open_tab = { "<c-t>" }, -- open buffer in new tab
		jump_close = { "o" }, -- jump to the diagnostic and close the list
		toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
		toggle_preview = "P", -- toggle auto_preview
		hover = "K", -- opens a small popup with the full multiline message
		preview = "p", -- preview the diagnostic location
		close_folds = { "zM", "zm" }, -- close all folds
		open_folds = { "zR", "zr" }, -- open all folds
		toggle_fold = { "zA", "za" }, -- toggle fold of current file
		previous = "k", -- preview item
		next = "j", -- next item
	},
	indent_lines = true, -- add an indent guide below the fold icons
	auto_open = false, -- automatically open the list when you have diagnostics
	auto_close = false, -- automatically close the list when you have no diagnostics
	auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
	auto_fold = false, -- automatically fold a file trouble list at creation
	auto_jump = { "lsp_definitions" }, -- for the given modes, automatically jump if there is only a single result
	signs = {
		-- icons / text used for a diagnostic
		error = "",
		warning = "",
		hint = "",
		information = "",
		other = "﫠",
	},
	use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})

require('crates').setup {
    null_ls = {
        enabled = true,
        name = "crates.nvim",
    },
}
