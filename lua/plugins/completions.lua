return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "zbirenbaum/copilot-cmp"
  },
  config = function ()
    vim.o.winborder = 'single'
    require("copilot_cmp").setup()
    local cmp = require('cmp')
    cmp.setup({
      snippet = {
        expand = function(args)
          vim.snippet.expand(args.body)
        end,
      },
      mapping = {
        ["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
        ["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
        ['<`-j>'] = cmp.mapping.scroll_docs(-4),
        ['<`-k>'] = cmp.mapping.scroll_docs(4),
        ['<C-a>'] = cmp.mapping(
          cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          },
          { "i", "c" }
        ),
      },
      sources = {
        { name = 'copilot' },
        { name = 'nvim_lsp'},
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
      },
      window = {
        documentation = {
          winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal',
        },
        completion = {
          winhighlight = 'Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal',
        },
      },
      formatting = {
        fields = {'menu', 'abbr', 'kind'},
        format = function(entry, item)
          local menu_icon ={
            nvim_lsp = 'λ',
            luasnip = '⋗',
            buffer = 'Ω',
            path = '🖫',
            copilot = " "
          }
          item.menu = menu_icon[entry.source.name]
          return item
        end,
      },
    })

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
