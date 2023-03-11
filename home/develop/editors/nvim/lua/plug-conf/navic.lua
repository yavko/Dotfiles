local M = {}
local navic = require('nvim-navic')

--vim.o.winbar = "%{%v:lua.require'nvim-navic'.get_location()%}"

navic.setup {
	icons = {
		File          = " ",
		Module        = " ",
		Namespace     = " ",
		Package       = " ",
		Class         = " ",
		Method        = " ",
		Property      = " ",
		Field         = " ",
		Constructor   = " ",
		Enum          = "練",
		Interface     = "練",
		Function      = " ",
		Variable      = " ",
		Constant      = " ",
		String        = " ",
		Number        = " ",
		Boolean       = "◩ ",
		Array         = " ",
		Object        = " ",
		Key           = " ",
		Null          = "ﳠ ",
		EnumMember    = " ",
		Struct        = " ",
		Event         = " ",
		Operator      = " ",
		TypeParameter = " ",
	},
	highlight = true,
	separator = " > ",
	depth_limit = 0,
	depth_limit_indicator = "..",
}

function M.isempty(s)
	return s == nil or s == ""
end

function M.get_buf_option(opt)
	local status_ok, buf_option = pcall(vim.api.nvim_buf_get_option, 0, opt)
	if not status_ok then
		return nil
	else
		return buf_option
	end
end

local excludes = function()
	return vim.tbl_contains({ "NvimTree" }, vim.bo.filetype)
end

M.get_filename = function()
	local filename = vim.fn.expand "%:t"
	local extension = vim.fn.expand "%:e"

	if not M.isempty(filename) then
		local file_icon, file_icon_color =
		require("nvim-web-devicons").get_icon_color(filename, extension, { default = true })

		local hl_group = "FileIconColor" .. extension

		vim.api.nvim_set_hl(0, hl_group, { fg = file_icon_color })
		if M.isempty(file_icon) then
			file_icon = ""
		end

		local buf_ft = vim.bo.filetype

		if buf_ft == "dapui_breakpoints" then
			file_icon = ""
		end

		if buf_ft == "dapui_stacks" then
			file_icon = " "
		end

		if buf_ft == "dapui_scopes" then
			file_icon = ""
		end

		if buf_ft == "dapui_watches" then
			file_icon = ""
		end

		-- if buf_ft == "dapui_console" then
		--   file_icon = lvim.icons.ui.DebugConsole
		-- end

		local navic_text = vim.api.nvim_get_hl_by_name("Normal", true)
		vim.api.nvim_set_hl(0, "Winbar", { fg = navic_text.foreground })

		return " " .. "%#" .. hl_group .. "#" .. file_icon .. "%*" .. " " .. "%#Winbar#" .. filename .. "%*"
	end
end



local get_gps = function()
	local status_gps_ok, gps = pcall(require, "nvim-navic")
	if not status_gps_ok then
		return ""
	end

	local status_ok, gps_location = pcall(gps.get_location, {})
	if not status_ok then
		return ""
	end

	if not gps.is_available() or gps_location == "error" then
		return ""
	end

	if not M.isempty(gps_location) then
		-- TODO: replace with chevron
		return ">" .. " " .. gps_location
	else
		return ""
	end
end

M.get_winbar = function()
	if excludes() then
		return
	end
	local value = M.get_filename()

	local gps_added = false
	if not M.isempty(value) then
		local gps_value = get_gps()
		value = value .. " " .. gps_value
		if not M.isempty(gps_value) then
			gps_added = true
		end
	end

	if not M.isempty(value) and M.get_buf_option "mod" then
		-- TODO: replace with circle
		local mod = "%#LspCodeLens#" .. "" .. "%*"
		if gps_added then
			value = value .. " " .. mod
		else
			value = value .. mod
		end
	end

	local num_tabs = #vim.api.nvim_list_tabpages()

	if num_tabs > 1 and not M.isempty(value) then
		local tabpage_number = tostring(vim.api.nvim_tabpage_get_number(0))
		value = value .. "%=" .. tabpage_number .. "/" .. tostring(num_tabs)
	end

	local status_ok, _ = pcall(vim.api.nvim_set_option_value, "winbar", value, { scope = "local" })
	if not status_ok then
		return
	end
end

vim.api.nvim_create_augroup("_winbar", {})
if vim.fn.has "nvim-0.8" == 1 then
	vim.api.nvim_create_autocmd(
		{ "CursorMoved", "CursorHold", "BufWinEnter", "BufFilePost", "InsertEnter", "BufWritePost", "TabClosed" },
		{
			group = "_winbar",
			callback = function()
				local status_ok, _ = pcall(vim.api.nvim_buf_get_var, 0, "lsp_floating_window")
				if not status_ok then
					-- TODO:
					M.get_winbar()
				end
			end,
		}
	)
end

--return M
