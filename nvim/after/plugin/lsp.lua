-- 1. Mapeos LSP 
vim.api.nvim_create_autocmd("LspAttach", {
	desc = "Acciones LSP",
	callback = function(event)
		local opts = { buffer = event.buf }
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)

		-- Diagnósticos en ventana flotante
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
		vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)

		-- Integración con navic para breadcrumbs
		local navic = require("nvim-navic")
		if client.server_capabilities.documentSymbolProvider then
		  navic.attach(client, event.buf)
		end
		end,
		})


-- 2. Autocompletado para servidores
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 3. Mason: Instalación y configuración automática de servidores
require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = { "bashls", "pyright", "lua_ls", "gopls" },
	handlers = {
		function(server_name)
			require("lspconfig")[server_name].setup({
				capabilities = lsp_capabilities,
			})
		end,
		
		["lua_ls"] = function()
			require("lspconfig").lua_ls.setup({
				capabilities = lsp_capabilities,
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})
		end,
	},
})

-- 4. Autocompletado (nvim-cmp)
local cmp = require("cmp")
local luasnip = require("luasnip")
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = false }), -- Solo confirma si seleccionas explícitamente

		-- Navegación de Snippets con Tab
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
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
	}),
	sources = cmp.config.sources({
		{ name = "nvim_lsp", priority = 1000 },
		{ name = "luasnip", priority = 750 },
		{ name = "buffer", priority = 500 },
		{ name = "path", priority = 250 },
	}),
})

-- 5. Estética de Diagnósticos
local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

vim.diagnostic.config({
	virtual_text = { prefix = "●" },
	severity_sort = true,
	float = { border = "rounded", source = "always" },
})
