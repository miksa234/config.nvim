vim.pack.add({ "https://github.com/windwp/nvim-autopairs.git" })

require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt", "vim" },
})
