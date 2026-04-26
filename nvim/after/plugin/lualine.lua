local status, lualine = pcall(require, "lualine")
if not status then return end

local navic = require("nvim-navic")

lualine.setup({
  options = {
    theme = "auto",
    component_separators = '|',
    section_separators = { left = '', right = '' },
    globalstatus = true,
  },
  sections = {
    lualine_a = {
      { 'mode', separator = { left = '' }, right_padding = 2 },
    },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      {
        "diagnostics",
        symbols = { error = "✘ ", warn = "▲ ", info = "» ", hint = "⚑ " },
      },
    },
    lualine_x = { 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = {
      { 'location', separator = { right = '' }, left_padding = 2 },
    },
  },

  winbar = {
    lualine_c = {
      {
        function()
          return navic.get_location()
        end,
        cond = function()
          return navic.is_available()
        end,
      },
    },
  },
  inactive_winbar = {
    lualine_c = {
      { 'filename', path = 1 } 
    },
  },
})
