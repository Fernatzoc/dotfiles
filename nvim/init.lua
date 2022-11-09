require('plugins')
require('settings')

-- packages config

require('plugins.treesitter')
require('plugins.nvim-tree')
require('plugins.tabs')
require('plugins.smallConfigs')
require('plugins.codi')
require('plugins.fzf')
require('plugins.quickUI')
require('plugins.startify')
require('plugins.multiCursor')
require('plugins.indentLines')
require('plugins.coc')

-- end packages config

require('keybindings')
require('colors')
require('customFunctions')

local colorSchemes = {
  dracula = 'dracula',
  draculaPro = 'dracula_pro',
  gruvbox = 'gruvbox',
  gruvboxMaterial = 'gruvbox-material',
  nightOwl = 'night-owl',
  nova = 'nova',
  tokyoNight = 'tokyonight',
  catppuccin = 'catppuccin'
}

vim.cmd(string.format('colorscheme ' .. colorSchemes.catppuccin))

-- Current Word
vim.cmd("hi CurrentWord gui=underline,bold,italic cterm=underline,bold,italic")
