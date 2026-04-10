return {
  "chrisgrieser/nvim-lsp-endhints",
  event = "VeryLazy",
  config = function ()
    local endhints = require("lsp-endhints")
    endhints.enable()
    endhints.setup {
      icons = {
        type = "-> ",
        parameter = "<= ",
        offspec = "<= ", -- hint kind not defined in official LSP spec
        unknown = "? ", -- hint kind is nil
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
    }

    map = vim.keymap.set
    map('n', '<leader>h', function(bufnr)
      if vim.lsp.inlay_hint.is_enabled() then
        print("Inlay Hitnts OFF")
      else
        print("Inlay Hitnts ON")
      end
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), bufnr)
    end, { silent = true, noremap = true })

    map('n', '<leader>d', function()
      if vim.diagnostic.is_enabled() then
        print("Diagnostics OFF")
      else
        print("Diagnostics ON")
      end
      vim.diagnostic.enable(not vim.diagnostic.is_enabled())
    end, { silent = true, noremap = true })
  end

}
