---@diagnostic disable: undefined-global
return {
  "saghen/blink.cmp",
  event = "InsertEnter",
  version = "v1",
  dependencies = {
    "L3MON4D3/LuaSnip",
    "fang2hou/blink-copilot"
  },
  opts = {
    keymap = {
      ['<C-a>'] = { 'accept', 'fallback' },
      ['<C-n>'] = { 'select_next', 'show' },
      ['<C-p>'] = { 'select_prev' },
      ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
      ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
    },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
    cmdline = { enabled = false },
    snippets = { preset = "luasnip" },
    sources = {
      default = {
        "copilot",
        'lsp',
        'path',
        'snippets',
        'buffer'
      },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-copilot",
          score_offset = 100,
          async = true,
        }
      }
    },
    appearance = {
      kind_icons = {
        copilot = " ",
      }
    }
  }
}
