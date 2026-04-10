return {
  "lervag/vimtex",
  lazy = false,
  init = function()
    vim.opt.conceallevel = 2
    vim.g.vimtex_view_method = "zathura"
    vim.g.latex_to_unicode_auto = 1
    vim.g.tex_flavour = "latex"
    vim.g.vimtex_compiler_latexmk = {
      executable = "latexmk",
      options = {
        "-synctex=0",
        "-verbose",
        "-file-line-error",
        "-interaction=nonstopmode",
        "-shell-escape",
        "-synctex=1"
      },
      out_dir = "build",
      aux_dir = "build"
    }
    vim.g.vimtex_quickfix_mode = 0
    vim.g.tex_conceal = "abdmg"

    vim.keymap.set('n', '<leader>tp', "<Esc>:w<CR>:VimtexCompile<CR>")
    vim.keymap.set('n', '<leader>te', "<Esc>:w<CR>:VimtexErrors<CR>")

  end
}
