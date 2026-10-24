vim.pack.add({ "https://github.com/lervag/vimtex.git" })

vim.opt.conceallevel = 2
vim.g.vimtex_view_method = "zathura"
vim.g.latex_to_unicode_auto = 1
vim.g.tex_flavor = "latex"
vim.g.vimtex_compiler_latexmk = {
  executable = "latexmk",
  options = {
    "-verbose",
    "-file-line-error",
    "-interaction=nonstopmode",
    "-synctex=1"
  },
  out_dir = "build",
  aux_dir = "build"
}
vim.g.vimtex_quickfix_mode = 0
vim.g.tex_conceal = "abdmg"


vim.api.nvim_create_autocmd("FileType", {
  pattern = { "tex", "plaintex" },
  callback = function(event)
    vim.keymap.set("n", "<leader>tp", "<cmd>write<CR><cmd>VimtexCompile<CR>",
      { buffer = event.buf, desc = "Compile TeX" })
    vim.keymap.set("n", "<leader>te", "<cmd>write<CR><cmd>VimtexErrors<CR>",
      { buffer = event.buf, desc = "TeX errors" })
  end,
})
