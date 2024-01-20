function UseColorScheme(color)
  --color = color or "gruvbox"

  local colorSchemes = {
    catppuccin = 'catppuccin',
    kanagawa = 'kanagawa',
    gruvbox = 'gruvbox',
    ayuDark = 'ayu-dark',
    ayuLight = 'ayu-light',
    ayuMirage = 'ayu-mirage',
    onedark = 'onedark'
  }

  vim.g.onedark_config = {
    style = 'darker',
  }
  color = color or colorSchemes.onedark
  --vim.g.gruvbox_contrast_dark = 'hard'
  vim.cmd.colorscheme(color)
end

UseColorScheme()
