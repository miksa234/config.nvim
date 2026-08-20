---@diagnostic disable: undefined-global
return {
  "lervag/vimtex",
  ft = { "tex", "plaintex" },
  keys = {
    {
      "<leader>tp",
      "<cmd>write<CR><cmd>VimtexCompile<CR>",
      ft = { "tex", "plaintex" },
      desc = "Compile TeX",
    },
    {
      "<leader>te",
      "<cmd>write<CR><cmd>VimtexErrors<CR>",
      ft = { "tex", "plaintex" },
      desc = "TeX errors",
    },
  },
  init = function()
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
  end
}
