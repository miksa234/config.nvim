---@diagnostic disable: undefined-global
return {
  "voldikss/vim-floaterm",
  config = function()
    vim.keymap.set('n', "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.8 --autoclose=2 zsh<CR> ")
    vim.keymap.set('n', "t", ":FloatermToggle myfloat<CR>")
    vim.keymap.set('t', "<C-t>", "<C-\\><C-n>:q<CR>")
  end
}
