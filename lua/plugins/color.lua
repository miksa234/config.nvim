function ColorMyPencils(color)
  color = color or "rose-pine-moon"
  vim.cmd.colorscheme(color)
  vim.opt.cursorline = true

  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "MatchParen", { bg= "darkred" })
  vim.api.nvim_set_hl(0, "SpellBad", { bold=true, underline=true, fg= "red" })

  -- separators
  vim.api.nvim_set_hl(0, "WinSeparator", { fg="#A96C8A", bold=true })
  vim.api.nvim_set_hl(0, "StatusLine", { fg="#6CA98A" })

  vim.fn.matchadd("ExtraWhiteSpace", '\\v\\s+$')
  vim.api.nvim_set_hl(0, "ExtraWhiteSpace", { ctermbg="red", bg="red" })
  local nontexthl = vim.api.nvim_get_hl_by_name("NonText", true)

  -- colpilot chat
  vim.api.nvim_set_hl(0, 'CopilotChatHeader', { fg = '#7C3AED', bold = true })
  vim.api.nvim_set_hl(0, 'CopilotChatSeparator', { fg = '#374151' })

  -- TelescopeBorder
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { fg = '#A96C8A', bold=true })
  vim.api.nvim_set_hl(0, 'TelescopeTitle', { fg = '#6CA98A', bold=true })

  -- lsp hints
  vim.api.nvim_set_hl(0, "LspInlayHint", { bg = "none", fg = nontexthl.foreground })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#6CA98A", bold = true })
end

return {
  {
    "rose-pine/neovim",
    name = "rose-pine",
    config = function()
      require('rose-pine').setup({
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
      ColorMyPencils();
    end
  },
}
