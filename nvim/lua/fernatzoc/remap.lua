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

-- Move UP and Down
vim.keymap.set("n", "<M-Up>", ":m-2<CR>", opts)
vim.keymap.set("n", "<M-Down>", ":m+<CR>", opts)
vim.keymap.set("i", "<M-Up>", "<Esc>:m-2<CR>", opts)
vim.keymap.set("i", "<M-Down>", "<Esc>:m+<CR>", opts)

-- Change Buffer
vim.keymap.set("n", "<S-m>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-n>", ":bprev<CR>", opts)
vim.keymap.set("n", "<TAB>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", opts)

-- Resize with arrows
vim.keymap.set("n", "<C-Up>", ":resize -1<CR>", opts)
vim.keymap.set("n", "<C-Down>", ":resize +2<CR>", opts)
vim.keymap.set("n", "<C-Left>", ":vertical resize -2<CR>", opts)
vim.keymap.set("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Better window movement
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)
