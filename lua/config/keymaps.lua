vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("n", "<leader>ce", ":setlocal spell! spelllang=en_us<cr>")
vim.keymap.set("n", "<leader>cd", ":setlocal spell! spelllang=de<cr>")
vim.keymap.set("n", "<leader>cs", ":setlocal spell! spelllang=sr@latin<cr>")

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<leader>b", ":! firefox %")

vim.keymap.set('c', 'w!!', ':w ! sudo tee % > /dev/null')

vim.keymap.set('n', '<C-S>', function()
  local bad = vim.fn.expand("<cword>")
  local word_list = vim.fn.spellsuggest(bad)
  end
)
