return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "VeryLazy",
  config = function()
    local endhints = require("lsp-endhints")
    endhints.setup({
      icons = {
        type = "-> ",
        parameter = "<= ",
        offspec = "<= ",
        unknown = "? ",
      },
      label = {
        truncateAtChars = 50,
        padding = 1,
        marginLeft = 0,
        sameKindSeparator = ", ",
      },
      extmark = {
        priority = 50,
      },
      autoEnableHints = true,
    })
    endhints.enable()
  end
}
