return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  requires = {
    "copilotlsp-nvim/copilot-lsp", -- (optional) for NES functionality
  },
  config = function()
    require("copilot").setup({
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        txt = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
    })
  end,
}
