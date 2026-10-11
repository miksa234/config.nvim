require("plugins.blimp")
require("plugins.telescope")

vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
  "https://github.com/sudo-tee/opencode.nvim.git",
})

require("render-markdown").setup({
  anti_conceal = { enabled = false },
  file_types = { "opencode_output" },
})

require("opencode").setup({
  preferred_picker = "telescope",
  preferred_completion = "blink",
  default_mode = "router",
  server = {
    url = "localhost",
    port = 9999,
  },
  ui = {
    position = "current",
  },
})
