return {
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.6 --width=0.7 --autoclose=2 zsh<CR> ")
    vim.keymap.set('n', "t", ":FloatermToggle myfloat<CR>")
    vim.keymap.set('t', "<C-t>", "<C-\\><C-n>:q<CR>")
  end
}
