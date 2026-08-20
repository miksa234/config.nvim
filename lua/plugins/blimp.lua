return {
  "saghen/blink.cmp",
  version = "v1",
  dependencies = {
    "L3MON4D3/LuaSnip",
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
        'lsp',
        'path',
        'snippets',
        'buffer'
      },
    },
  }
}
