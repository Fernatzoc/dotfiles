-- vim.keymap.set mode, shortcut, action, config
local opts = { noremap = true, silent = true }

vim.keymap.set("i", "jj", "<ESC>", opts)
vim.keymap.set("n", "<leader>V", ":vsplit<CR>", opts)

-- Clear search highlight
vim.keymap.set("n", "<esc>", ":noh<return><esc>", opts)

-- Fold
vim.keymap.set("n", "zC", "zM", opts)
vim.keymap.set("n", "zO", "zR", opts)
vim.keymap.set("n", "zz", "<C-w>|", opts)

-- Indentations
vim.keymap.set("v", ">", ">gv", { silent = true })
vim.keymap.set("v", "<", "<gv", { silent = true })

--Terminal
vim.keymap.set('n', "<C-t>", ':split term://zsh<cr>', opts)

-- Change Buffer
vim.keymap.set("n", "<S-m>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-n>", ":bprev<CR>", opts)
--vim.keymap.set("n", "<TAB>", ":bnext<CR>", opts)
--vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Resize windows
vim.keymap.set("n", "<Leader>h", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<Leader>l", ":vertical resize +2<CR>", opts)
vim.keymap.set("n", "<Leader>k", ":resize -1<CR>", opts)
vim.keymap.set("n", "<Leader>j", ":resize +2<CR>", opts)
