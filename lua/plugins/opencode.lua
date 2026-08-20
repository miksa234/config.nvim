---@diagnostic disable: undefined-global
return {
  "sudo-tee/opencode.nvim",
  config = function()
    require("opencode").setup({
      preferred_picker = "telescope",
      preferred_completion = "blink",
      default_mode = "router",
      server = {
        url = localhost,
        port = 9999,
      },
      ui = {
        position = "current",
      },
    })
  end,
  dependencies = {
    {
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        anti_conceal = { enabled = false },
        file_types = { "markdown", "opencode_output" },
      },
      ft = { "markdown", "Avante", "copilot-chat", "opencode_output" },
    },
    "saghen/blink.cmp",
    "nvim-telescope/telescope.nvim",
  },
}
