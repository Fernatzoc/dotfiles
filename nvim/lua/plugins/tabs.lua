vim.opt.termguicolors = true

require('bufferline').setup({
  options = {
    buffer_close_icon = '',
    modified_icon = '●',
    close_icon = '',
    close_command = 'Bdelete %d',
    right_mouse_command = 'Bdelete! %d',
    left_trunc_marker = '',
    right_trunc_marker = '',
    diagnostics = 'coc',
    offsets = {
      { filetype = 'NvimTree', text = 'EXPLORER', text_align = 'center' },
    },
    show_tab_indicators = true,
    show_close_icon = false,
  },
})
