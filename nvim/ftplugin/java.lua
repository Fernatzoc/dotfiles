vim.cmd([[
  command! -buffer -bar Run :!java %
]])

vim.api.nvim_buf_set_keymap(0, 'n', '<Leader>rp', ':Run<CR>', { noremap = true, expr = false, silent = true })

vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
