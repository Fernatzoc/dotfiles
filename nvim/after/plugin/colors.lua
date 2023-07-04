function UseColorScheme(color)
  --color = color or "catppuccin"
  color = color or "kanagawa"
  --color = color or "gruvbox"
  vim.cmd.colorscheme(color)
end

UseColorScheme()
