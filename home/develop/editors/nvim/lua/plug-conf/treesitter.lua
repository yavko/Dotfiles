require('nvim-treesitter.configs').setup {
	highlight = {
		enable = true,
	},
	indent = {
		enable = true
	},
	endwise = {
		enable = true,
	},
	autotag = {
		enable = true,
		filetypes = {
			'html',
			'javascript',
			'typescript',
			'javascriptreact',
			'typescriptreact',
			'svelte',
			'tsx',
			'jsx',
			'xml',
			'markdown',
		},
	},
	rainbow = {
		enable = true,
		extended_mode = true,
		max_file_lines = nil,
		colors = {
			'#ff79c6', -- pink
			'#8be9fd', -- cyan
			'#ffb86c', -- orange
			'#f1fa8c', -- yellow
			'#50fa7b', -- green
			'#bd93f9', -- purple
			'#e64747', -- red
		}
	},
	playground = {
		enable = true,
		disable = {},
		updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
		persist_queries = false, -- Whether the query persists across vim sessions
		keybindings = {
			toggle_query_editor = 'o',
			toggle_hl_groups = 'i',
			toggle_injected_languages = 't',
			toggle_anonymous_nodes = 'a',
			toggle_language_display = 'I',
			focus_language = 'f',
			unfocus_language = 'F',
			update = 'R',
			goto_node = '<cr>',
			show_help = '?',
		},
	}
}

require('nvim-autopairs').setup {}

require 'treesitter-context'.setup {
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	throttle = true, -- Throttles plugin updates (may improve performance)
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
		-- For all filetypes
		-- Note that setting an entry here replaces all other patterns for this entry.
		-- By setting the 'default' entry below, you can control which nodes you want to
		-- appear in the context window.
		default = {
			'class',
			'function',
			'method',
			'for', -- These won't appear in the context
			'while',
			'if',
			'switch',
			-- 'case',
		},
		-- Example for a specific filetype.
		-- If a pattern is missing, *open a PR* so everyone can benefit.
		--   rust = {
		--       'impl_item',
		--   },
	},
	exact_patterns = {
		-- Example for a specific filetype with Lua patterns
		-- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
		-- exactly match "impl_item" only)
		-- rust = true,
	}
}

require('Comment').setup({
	---Add a space b/w comment and the line
	---@type boolean|fun():boolean
	padding = true,

	---Whether the cursor should stay at its position
	---NOTE: This only affects NORMAL mode mappings and doesn't work with dot-repeat
	---@type boolean
	sticky = true,

	---Lines to be ignored while comment/uncomment.
	---Could be a regex string or a function that returns a regex string.
	---Example: Use '^$' to ignore empty lines
	---@type string|fun():string
	ignore = nil,

	---LHS of toggle mappings in NORMAL + VISUAL mode
	---@type table
	toggler = {
		---Line-comment toggle keymap
		line = 'gcc',
		---Block-comment toggle keymap
		block = 'gbc',
	},

	---LHS of operator-pending mappings in NORMAL + VISUAL mode
	---@type table
	opleader = {
		---Line-comment keymap
		line = 'gc',
		---Block-comment keymap
		block = 'gb',
	},

	---LHS of extra mappings
	---@type table
	extra = {
		---Add comment on the line above
		above = 'gcO',
		---Add comment on the line below
		below = 'gco',
		---Add comment at the end of line
		eol = 'gcA',
	},

	---Create basic (operator-pending) and extended mappings for NORMAL + VISUAL mode
	---NOTE: If `mappings = false` then the plugin won't create any mappings
	---@type boolean|table
	mappings = {
		---Operator-pending mapping
		---Includes `gcc`, `gbc`, `gc[count]{motion}` and `gb[count]{motion}`
		---NOTE: These mappings can be changed individually by `opleader` and `toggler` config
		basic = true,
		---Extra mapping
		---Includes `gco`, `gcO`, `gcA`
		extra = true,
		---Extended mapping
		---Includes `g>`, `g<`, `g>[count]{motion}` and `g<[count]{motion}`
		extended = false,
	},

	---Pre-hook, called before commenting the line
	---@type fun(ctx: Ctx):string
	pre_hook = nil,

	---Post-hook, called after commenting is done
	---@type fun(ctx: Ctx)
	post_hook = nil,
})
-- "markdown", "md", "html", "txt", "js", "ts", "tsx", "jsx", "rst"
require('spellsitter').setup {
	enabled = true
}

local hl_status hlargs = pcall(require,'hlargs')
if hl_status then
	hlargs.setup {
		color = "#50fa7b",
	}
end
