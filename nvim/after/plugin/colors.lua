function UseColorScheme(color)
  --color = color or "catppuccin"
  color = color or "kanagawa"
  vim.cmd.colorscheme(color)
end

UseColorScheme()
