-- Set up nvim-cmp.
local cmp = require 'cmp'
local luasnip = require 'luasnip'
local lspkind = require('lspkind')

require 'luasnip/loaders/from_vscode'.lazy_load()

local has_words_before = function()
	unpack = unpack or table.unpack
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

cmp.setup({
	enabled = function()
		-- disable completion in comments
		local context = require 'cmp.config.context'
		-- keep command mode completion enabled when cursor is in a comment
		if vim.api.nvim_get_mode().mode == 'c' then
			return true
		else
			return not context.in_treesitter_capture("comment")
					and not context.in_syntax_group("Comment")
		end
	end,
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<C-b>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_locally_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
		['<C-Space>'] = cmp.mapping.complete(),
		['<C-e>'] = cmp.mapping.abort(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		-- cmp.mapping({
		--      i = function(fallback)
		--        if cmp.visible() and cmp.get_active_entry() then
		--          cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })
		--        else
		--          fallback()
		--        end
		--      end,
		--      s = cmp.mapping.confirm({ select = false }),
		--      c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
		--    }),
	}),
	formatting = {
		-- icons in completions
		format = require 'lspkind'.cmp_format {
			mode = 'symbol_text',
			maxwidth = 50
		}
	},
	sources = cmp.config.sources({
		{
			name = 'nvim_lsp',
			filter = function(entry, ctx)
				local kind = require("cmp.types.lsp").CompletionItemKind[entry:get_kind()]
				if kind == "Snippet" and ctx.prev_context.filetype == "java" then
					return true
				end

				if kind == "Text" then
					return true
				end
			end,
		},
		{ name = 'luasnip' },
		{
			name = 'buffer',
			filter = function(entry, ctx)
				if not contains({ "markdown", "toml", "json", "yaml" }, ctx.prev_context.filetype) then
					return true
				end
			end,
		},
		{ name = 'path' },
		--{ name = 'cmdline' },
		{ name = 'nvim_lua' },
		{ name = 'treesitter' },
		{ name = "ctags" },
		--{ name = "copilot" },
		{ name = "emoji" },
		{ name = "greek" },
		{ name = 'nvim_lsp_signature_help' },
	})
})

-- -- Set configuration for specific filetype.
-- cmp.setup.filetype('gitcommit', {
--   sources = cmp.config.sources({
--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
--   }, {
--     { name = 'buffer' },
--   })
-- })

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' },
		{ name = "nvim_lsp_document_symbol" }
	}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'path' },
		{ name = 'cmdline' },
		--{ name = "omni" }
	}
})

-- If you want insert `(` after select function or method item
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
	'confirm_done',
	cmp_autopairs.on_confirm_done()
)

vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
	pattern = "Cargo.toml",
	callback = function()
		cmp.setup.buffer({ sources = { { name = "crates" } } })
	end,
})
