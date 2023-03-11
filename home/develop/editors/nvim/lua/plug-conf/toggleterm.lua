local colors = require("catppuccin.palettes").get_palette()

require("toggleterm").setup {
  -- size can be a number or function which is passed the current terminal
  size = function(term)
    if term.direction == "horizontal" then
      return 15
    elseif term.direction == "vertical" then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<c-\>]],
  --on_open = fun(t: Terminal), -- function to run when the terminal opens
  --on_close = fun(t: Terminal), -- function to run when the terminal closes
  --on_stdout = function(t, job, data, name)
  --	vim.notify(name, "info")
  --send, -- callback for processing output on stdout
  on_stderr = function(t, job, data, name)
  	vim.notify(job, "error")
  end, -- callback for processing output on stderr
  on_exit = function(t, job, exit_code, name)
  	if exit_code ~= 0 then
  		vim.notify(job, "error")
  	end
  end,-- function to run when terminal process exits
  hide_numbers = true, -- hide the number column in toggleterm buffers
  shade_filetypes = {},
  highlights = {
    -- highlights which map to a highlight group name and a table of it's values
    -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
    Normal = {
      guibg = colors.surface0,
    },
    NormalFloat = {
      link = 'Normal'
    },
    FloatBorder = {
      guifg = colors.text,
      guibg = colors.surface0,
    },
  },
  shade_terminals = true,
  shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
  start_in_insert = true,
  insert_mappings = true, -- whether or not the open mapping applies in insert mode
  terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
  persist_size = true,
  direction = 'vertical',
  close_on_exit = true, -- close the terminal window when the process exits
  shell = vim.o.shell, -- change the default shell
  -- This field is only relevant if direction is set to 'float'
  float_opts = {
    -- The border key is *almost* the same as 'nvim_open_win'
    -- see :h nvim_open_win for details on borders however
    -- the 'curved' border is a custom border type
    -- not natively supported but implemented in this plugin.
    border = 'curved',
    width = 100,
    height = 100,
    winblend = 3,
  }
}
