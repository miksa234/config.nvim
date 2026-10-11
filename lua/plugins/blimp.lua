require("plugins.luasnip")

vim.pack.add({
  { src = "https://github.com/saghen/blink.cmp.git", version = vim.version.range("^1") },
})

require("blink.cmp").setup({
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
})
