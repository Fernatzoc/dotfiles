function UseColorScheme(color)
  --color = color or "gruvbox"

  local colorSchemes = {
    catppuccin = 'catppuccin',
    kanagawa = 'kanagawa',
    gruvbox = 'gruvbox',
    ayuDark = 'ayu-dark',
    ayuLight = 'ayu-light',
    ayuMirage = 'ayu-mirage'
  }

  color = color or colorSchemes.ayuDark
  vim.cmd.colorscheme(color)
end

UseColorScheme()
