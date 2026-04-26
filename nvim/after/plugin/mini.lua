require('mini.ai').setup()
require('mini.cursorword').setup()
require('mini.pairs').setup()
require('mini.trailspace').setup()
require('mini.starter').setup()
require('mini.surround').setup()
require('mini.files').setup()

-- Atajo para abrir/cerrar el explorador de archivos: <leader>e
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then
    local buf_name = vim.api.nvim_buf_get_name(0)
    local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
    MiniFiles.open(path)
  end
end, { desc = "Explorador de Archivos (Mini)" })

-- Mapeos personalizados para mini.files 
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesBufferCreate',
  callback = function(args)
    local buf_id = args.data.buf_id

    -- Usar 'Enter' para abrir archivos/carpetas
    vim.keymap.set('n', '<CR>', function()
      local fs_entry = MiniFiles.get_fs_entry()
      if fs_entry ~= nil and fs_entry.fs_type == 'file' then
        MiniFiles.go_in()
        MiniFiles.close() 
      else
        MiniFiles.go_in() 
      end
    end, { buffer = buf_id, desc = "Abrir archivo/carpeta" })

    -- Usar 'Esc' para cerrar rápidamente
    vim.keymap.set('n', '<ESC>', MiniFiles.close, { buffer = buf_id, desc = "Cerrar explorador" })
  end,
})

require('mini.move').setup({
  mappings = {
    left = '<C-h>',
    right = '<C-l>',
    down = '<C-j>',
    up = '<C-k>',
    line_left = '<C-h>',
    line_right = '<C-l>',
    line_down = '<C-j>',
    line_up = '<C-k>',
  },
})
