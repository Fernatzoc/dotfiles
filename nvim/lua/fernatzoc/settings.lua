-- Optimización de carga 
vim.loader.enable()

vim.g.mapleader = " "

-- Apariencia
vim.opt.termguicolors = true
vim.opt.hidden = true
vim.opt.splitright = true
vim.opt.cursorline = true
vim.opt.splitbelow = true
vim.opt.number = true
vim.opt.relativenumber = true 
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true

-- Indentación
vim.opt.expandtab = true
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.wrap = false

-- Búsqueda
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"

-- Interacción
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- Persistencia y Seguridad
vim.opt.backup = false
vim.opt.writebackup = true
vim.opt.swapfile = false
vim.opt.autoread = true
vim.opt.undofile = true 

-- Tree-sitter Nativo
vim.api.nvim_create_autocmd('FileType', {
  callback = function()
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang then
      pcall(vim.treesitter.start)
    end
  end
})
