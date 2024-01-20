local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "lewis6991/gitsigns.nvim",
  "echasnovski/mini.nvim",
  -- heads up: lualine blanks the start screen
  "nvim-lualine/lualine.nvim",
  {
    "j-hui/fidget.nvim",
    tag = "legacy",
    event = "LspAttach",
    opts = {
      -- options
    },
  },
  "nvim-tree/nvim-web-devicons",
  "goolord/alpha-nvim",
  "tpope/vim-eunuch",
  "akinsho/flutter-tools.nvim",

  -- Themes
  "marko-cerovac/material.nvim",
  { "catppuccin/nvim",                          name = "catppuccin" },
  "rebelot/kanagawa.nvim",
  "morhetz/gruvbox",
  "Shatur/neovim-ayu",
  "navarasu/onedark.nvim",

  "ellisonleao/glow.nvim",
  "folke/trouble.nvim",
  "chrisgrieser/nvim-spider",
  "chrisgrieser/nvim-various-textobjs",
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
  },

  -- Telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.4',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },


  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

  -- BlankLine
  { "lukas-reineke/indent-blankline.nvim",      main = "ibl",       opts = {} },

  --
  { "nvim-treesitter/nvim-treesitter",          build = ":TSUpdate" },
  {
    "nvim-tree/nvim-tree.lua",
    tag = "nightly",
  },

  {
    'akinsho/bufferline.nvim',
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons'
  },

  -- LSP
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      -- LSP Support
      { 'neovim/nvim-lspconfig' }, -- Required
      {
        -- Optional
        'williamboman/mason.nvim',
        build = function()
          pcall(vim.cmd, 'MasonUpdate')
        end,
      },
      { 'williamboman/mason-lspconfig.nvim' }, -- Optional

      -- Autocompletion
      { 'hrsh7th/nvim-cmp' },         -- Required
      { 'hrsh7th/cmp-nvim-lsp' },     -- Required
      { "saadparwaiz1/cmp_luasnip" }, -- Optional
      { "hrsh7th/cmp-nvim-lua" },     -- Optional
      { "hrsh7th/cmp-buffer" },       -- Optional
      { "hrsh7th/cmp-path" },         -- Optional

      -- Snippets
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp"
      },
      { "rafamadriz/friendly-snippets" } -- Optional
    }
  },
  {
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason.nvim",
      "nvimtools/none-ls.nvim"
    }
  }
})
