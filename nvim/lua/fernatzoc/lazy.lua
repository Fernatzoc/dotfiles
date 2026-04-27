local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- === Git e Integración ===
	{ "lewis6991/gitsigns.nvim" }, 

	-- === Utilidades Core y Mini ===
	{ "echasnovski/mini.nvim" }, 

	-- === Interfaz de Usuario (UI) ===
	{ "nvim-lualine/lualine.nvim" },
	{ "j-hui/fidget.nvim", opts = {} },   
	{ "nvim-tree/nvim-web-devicons" },    
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} }, 

	-- === Temas (Colorschemes) ===
	{ "marko-cerovac/material.nvim" },
	{ "catppuccin/nvim", name = "catppuccin" },
	{ "rebelot/kanagawa.nvim" },
	{ "ellisonleao/gruvbox.nvim" },        
	{ "Shatur/neovim-ayu" },
	{ "navarasu/onedark.nvim" },


	-- === Navegación y Búsqueda ===
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = { "nvim-lua/plenary.nvim" }, 
	},
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" }, 

	-- === Edición y Movimiento Avanzado ===

	{ "chrisgrieser/nvim-spider" }, 
	{ "chrisgrieser/nvim-various-textobjs" }, 
	{ "folke/trouble.nvim", opts = {} },       
	{ "ellisonleao/glow.nvim" },               

	-- === LSP (Language Server Protocol) ===
	{ "folke/lazydev.nvim", ft = "lua", opts = {} }, 
	{ "neovim/nvim-lspconfig" },           

	{
		"williamboman/mason.nvim", 
		build = function()
			pcall(vim.cmd, "MasonUpdate")
		end,
	},
	{ "williamboman/mason-lspconfig.nvim" }, 

	-- === Autocompletado y Snippets ===
	{ "hrsh7th/nvim-cmp" }, 
	{ "hrsh7th/cmp-nvim-lsp" }, 
	{ "hrsh7th/cmp-buffer" }, 
	{ "hrsh7th/cmp-path" },         
	{ "saadparwaiz1/cmp_luasnip" },

	{
		"L3MON4D3/LuaSnip", 
		version = "v2.*",
		build = "make install_jsregexp",
	},
	{ "rafamadriz/friendly-snippets" }, 

	-- === Formateo de Código ===
	{
		"stevearc/conform.nvim", 
		config = function()
			require("conform").setup()
		end,
	},
})
