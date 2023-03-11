vim.cmd("packadd packer.nvim")

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")

		use("lewis6991/impatient.nvim")

		-- Mostly Dependencies
		use({
			"rcarriga/nvim-notify",
			"kyazdani42/nvim-web-devicons",
			"nvim-lua/plenary.nvim",
			"RishabhRD/popfix",
			"stevearc/dressing.nvim",
		})

		--use("Mofiqul/dracula.nvim")
		--use 'folke/tokyonight.nvim'
		use { "catppuccin/nvim", as = "catppuccin" }
		-- git stuff

		use({
			"lewis6991/gitsigns.nvim",
			{ "TimUntersberger/neogit", requires = "nvim-lua/plenary.nvim" },
		})

		use({
			"nvim-telescope/telescope.nvim",
			requires = { { "nvim-lua/plenary.nvim" } },
		})

		-- Lsp/autocomplete stuff

		use({
			"neovim/nvim-lspconfig",
			"tamago324/nlsp-settings.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"jose-elias-alvarez/null-ls.nvim",
			"nanotee/nvim-lsp-basics",
			"j-hui/fidget.nvim",
			"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
			"simrat39/symbols-outline.nvim",
			{ "folke/trouble.nvim", requires = "kyazdani42/nvim-web-devicons" },
			"lukas-reineke/lsp-format.nvim",
			{ "m-demare/hlargs.nvim", requires = { "nvim-treesitter/nvim-treesitter" } },
			"b0o/schemastore.nvim",
			'simrat39/rust-tools.nvim',
			'onsails/lspkind.nvim',
			{
				"zbirenbaum/copilot.lua",
				event = "VimEnter",
				config = function()
					vim.defer_fn(function()
						require("copilot").setup()
					end, 100)
				end,
			},
			{
				"zbirenbaum/copilot-cmp",
				after = { "copilot.lua" },
				config = function()
					require("copilot_cmp").setup()
				end
			}
		})

		use {
			"folke/which-key.nvim",
			config = function()
				require("which-key").setup {
					-- your configuration comes here
					-- or leave it empty to use the default settings
					-- refer to the configuration section below
				}
			end
		}

		use({ "SmiteshP/nvim-navic", requires = "neovim/nvim-lspconfig" })

		use({
			"akinsho/bufferline.nvim",
			tag = "v2.*",
			requires = "kyazdani42/nvim-web-devicons",
		})

		use({
			"kyazdani42/nvim-tree.lua",
			requires = {
				"kyazdani42/nvim-web-devicons", -- optional, for file icon
			},
		})

		-- use({
		-- 	{ "ms-jpq/coq_nvim", branch = "coq", run = ":COQdeps" },
		-- 	{ "ms-jpq/coq.artifacts", branch = "artifacts" },
		-- 	{ "ms-jpq/coq.thirdparty", branch = "3p" },
		-- })

		use({ "L3MON4D3/LuaSnip", requires = 'rafamadriz/friendly-snippets' })

		use({ "hrsh7th/nvim-cmp", requires = {
			{ "hrsh7th/cmp-cmdline" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "delphinus/cmp-ctags" },
			{ "hrsh7th/cmp-nvim-lua" },
			{ "hrsh7th/cmp-omni" },
			{ "ray-x/cmp-treesitter" },
			{ "ray-x/lsp_signature.nvim" }
		} })

		use("wfxr/minimap.vim")

		-- TreeSitter stuff
		use({
			{ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
			'nvim-treesitter/playground',
			"lewis6991/nvim-treesitter-context",
			"p00f/nvim-ts-rainbow",
			"lewis6991/spellsitter.nvim",
			"numToStr/Comment.nvim",
			"windwp/nvim-ts-autotag",
			"RRethy/nvim-treesitter-endwise",
			"windwp/nvim-autopairs",
		})

		use("goolord/alpha-nvim")

		--use 'karb94/neoscroll.nvim'
		use({
			"declancm/cinnamon.nvim",
			config = function()
				require("cinnamon").setup({
					extra_keymaps = true,
					scroll_limit = 100,
				})
			end,
		})

		use({
			"nvim-lualine/lualine.nvim",
			requires = { "kyazdani42/nvim-web-devicons", opt = true },
		})

		use({
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				require("indent_blankline").setup({
					show_current_context = true,
					show_current_context_start = true,
					show_end_of_line = true,
					space_char_blankline = " ",
				})
			end,
		})
		use({
			"NvChad/nvim-colorizer.lua",
			config = function()
				require("colorizer").setup()
			end,
		})

		-- use("mrjones2014/legendary.nvim")

		use("akinsho/toggleterm.nvim")

		use({ "psliwka/vim-dirtytalk", run = ":DirtytalkUpdate" })

		use({
			"lewis6991/cleanfold.nvim",
			config = function()
				require("cleanfold").setup()
			end,
		})

		use({
			"dstein64/nvim-scrollview",
			config = function()
				require("scrollview").setup({
					excluded_filetypes = { "NvimTree", "alpha", "Trouble", "Outline" },
				})
			end,
		})

		use 'mfussenegger/nvim-dap'
		use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }

		use("xiyaowong/nvim-cursorword")

		use("gpanders/editorconfig.nvim")

		use("elkowar/yuck.vim")

		use("~/ligatures.nvim/")
		--use 'eraserhd/parinfer-rust'
	end,
	config = {
		display = {
			open_fn = function()
				return require("packer.util").float({ border = "rounded" })
			end,
		},
	},
})
