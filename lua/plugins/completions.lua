---@diagnostic disable: undefined-global
return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "zbirenbaum/copilot-cmp",
  },
  config = function()
    vim.o.winborder = "single"

    local map = vim.keymap.set

    local ok_copilot_cmp, copilot_cmp = pcall(require, "copilot_cmp")
    if ok_copilot_cmp then
      copilot_cmp.setup()
    end

    local cmp = require("cmp")
    local luasnip = require("luasnip")

    cmp.setup({
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
        ["<`-j>"] = cmp.mapping.scroll_docs(-4),
        ["<`-k>"] = cmp.mapping.scroll_docs(4),
        ["<C-a>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true }),
      }),

      sources = cmp.config.sources({
        { name = "copilot" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
        { name = "path" },
      }),

      window = {
        completion = cmp.config.window.bordered({
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal",
        }),
        documentation = cmp.config.window.bordered({
          winhighlight = "Normal:CmpPmenu,CursorLine:PmenuSel,Search:None,NormalFloat:Normal",
        }),
      },

      formatting = {
        fields = { "abbr", "kind", "menu" },
        format = function(entry, item)
          local menu_icon = {
            nvim_lsp = "λ",
            luasnip = "⋗",
            buffer = "Ω",
            path = "🖫",
            copilot = " ",
          }
          item.menu = menu_icon[entry.source.name] or ""
          return item
        end,
      },
    })

    local ok_endhints, endhints = pcall(require, "lsp-endhints")
    if ok_endhints then
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

    map("n", "<leader>h", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
      vim.notify("Inlay hints " .. (enabled and "OFF" or "ON"))
    end, { silent = true, desc = "Toggle inlay hints" })

    map("n", "<leader>d", function()
      local bufnr = vim.api.nvim_get_current_buf()
      local enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
      vim.diagnostic.enable(not enabled, { bufnr = bufnr })
      vim.notify("Diagnostics " .. (enabled and "OFF" or "ON"))
    end, { silent = true, desc = "Toggle diagnostics" })
  end,
}
