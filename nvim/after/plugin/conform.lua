local status, conform = pcall(require, "conform")
if not status then return end

conform.setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "black" },
    go = { "gofmt", "goimports" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    bash = { "shfmt" },
  },
  format_on_save = {
    lsp_fallback = true,
    async = false,
    timeout_ms = 500,
  },
})

-- Atajo manual para formatear
vim.keymap.set({ "n", "v" }, "<leader>f", function()
  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Formatear archivo o selección" })
