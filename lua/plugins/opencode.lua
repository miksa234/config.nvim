vim.pack.add({
  "https://github.com/MeanderingProgrammer/render-markdown.nvim.git",
  { src = "https://github.com/sudo-tee/opencode.nvim.git" },
})

require("render-markdown").setup({
  anti_conceal = { enabled = false },
  file_types = { "opencode_output" },
})

require("opencode").setup({
  preferred_picker = "telescope",
  preferred_completion = "blink",
  default_mode = "plan",
  ui = {
    position = "current",
  },
})
