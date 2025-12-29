local map = vim.keymap.set
local defaults = { noremap = true, silent = true }
map("n", "<leader>|", ":vsplit<CR>")
map("n", "<leader>-", ":split<CR>")
