function UseColorScheme(color)
  --color = color or "gruvbox"

  local colorSchemes = {
    catppuccin = "catppuccin",
    kanagawaLotus = "kanagawa-lotus",
    kanagawaDragon = "kanagawa-dragon",
    kanagawaWave = "kanagawa-wave",
    gruvbox = "gruvbox",
    ayuDark = "ayu-dark",
    ayuLight = "ayu-light",
    ayuMirage = "ayu-mirage",
    onedark = "onedark",
  }

  require("kanagawa").setup({
    compile = false,
    undercurl = true,
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false,
    dimInactive = false,
    terminalColors = true,
    colors = {
      palette = {},
      theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    overrides = function(colors)
      return {}
    end,
    theme = "wave",
    background = {
      dark = "wave",
      light = "lotus",
    },
  })

  vim.g.onedark_config = {
    style = "darker",
  }
  color = color or colorSchemes.kanagawaWave
  --vim.g.gruvbox_contrast_dark = 'hard'
  vim.cmd.colorscheme(color)
end

UseColorScheme()
