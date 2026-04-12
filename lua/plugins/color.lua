---@diagnostic disable: undefined-global
return {
  "rose-pine/neovim",
  name = "rose-pine",
  config = function()
    require("rose-pine").setup({
      dark_variant = "main",
      dim_inactive_windows = true,
      disable_background = true,
      disable_nc_background = true,
      disable_float_background = true,
      extend_background_behind_borders = true,
      enable = {
        terminal = true,
        legacy_highlights = true,
        migrations = true,
      },
      styles = {
        bold = true,
        italic = true,
        transparency = false,
      },
    })

    vim.cmd.colorscheme("rose-pine-moon")
    vim.opt.cursorline = true

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    vim.api.nvim_set_hl(0, "MatchParen", { bg = "darkred" })
    vim.api.nvim_set_hl(0, "SpellBad", { bold = true, underline = true, fg = "red" })

    vim.api.nvim_set_hl(0, "WinSeparator", { bold = true })
    vim.api.nvim_set_hl(0, "StatusLine", { bold = true })

    vim.fn.matchadd("ExtraWhiteSpace", "\\v\\s+$")
    vim.api.nvim_set_hl(0, "ExtraWhiteSpace", { ctermbg = "red", bg = "red" })

    vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#7C3AED", bold = true })
    vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#374151" })

    vim.api.nvim_set_hl(0, "TelescopeBorder", { bold = true })
    vim.api.nvim_set_hl(0, "TelescopeTitle", { bold = true })

    vim.api.nvim_set_hl(0, "LspInlayHint", {
      bg = "none",
      fg = vim.api.nvim_get_hl_by_name("NonText", true).foreground,
    })
  end,
}
