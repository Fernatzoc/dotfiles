require('plugins')
require('settings')

-- packages config

require('plugins.treesitter')
require('plugins.smallConfigs')
require('plugins.codi')
require('plugins.fzf')
require('plugins.quickUI')
require('plugins.startify')
require('plugins.multiCursor')
require('plugins.indentLines')
require('plugins.nvim-tree')
require('plugins.lualine')
require('plugins.tabs')

-- LSP
require('lsp')
require('lsp.setup')

require('plugins.cmp')
require('plugins.lspConfig')
require('plugins.lspSignature')

-- end packages config

require('keybindings')
require('colors')
require('customFunctions')

local colorSchemes = {
    ayu = 'ayu',
    cobalt = 'cobalt2',
    dracula = 'dracula',
    draculaPro = 'dracula_pro',
    gruvbox = 'gruvbox',
    gruvboxMaterial = 'gruvbox-material',
    materialMonokai = 'material-monokai',
    monokaiPro = 'monokai_pro',
    nightOwl = 'night-owl',
    nord = 'nord',
    nova = 'nova',
    one = 'one',
    onehalflight = 'onehalflight',
    paperColor = 'PaperColor',
    quantum = 'quantum',
    tokyoNight = 'tokyonight'
}

vim.cmd(string.format('colorscheme ' .. colorSchemes.one))
vim.cmd [[hi normal guibg=NONE ctermbg=NONE]]
--vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snips")
--vim.g.vsnip_snippet_dir = vim.fn.expand("~/.vsnip")
vim.g.vsnip_snippet_dir = vim.fn.expand("~/.config/nvim/snips")

get_bufnrs = function()
  return vim.api.nvim_list_bufs()
end



