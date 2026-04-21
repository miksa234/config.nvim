---@diagnostic disable: undefined-global
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    "saghen/blink.cmp",
  },
  config = function()
    local map = vim.keymap.set

    local ok_blink, blink = pcall(require, "blink.cmp")
    if ok_blink then
      blink.setup({
        snippets = { preset = "luasnip" },
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
      })
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if ok_blink and type(blink.get_lsp_capabilities) == "function" then
      capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
    end

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

    local lspconfig = require("lspconfig")
    lspconfig.util.default_config.capabilities = capabilities

    require("conform").setup({
      formatters = {
        latexindent = {
          prepend_args = { "-y=defaultIndent:'  '" },
        },
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        lua = { "stylua" },
        less = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        svelte = { "prettier" },
        astro = { "prettier" },
        rust = { "rustfmt" },
        tex = { "latexindent" },
      },
      format_on_save = false,
    })

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local bufnr = event.buf
        local opts = { buffer = bufnr }

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end

        map("n", "K", vim.lsp.buf.hover, opts)
        map("n", "gd", vim.lsp.buf.definition, opts)
        map("n", "gD", vim.lsp.buf.declaration, opts)
        map("n", "gi", vim.lsp.buf.implementation, opts)
        map("n", "go", vim.lsp.buf.type_definition, opts)
        map("n", "gr", vim.lsp.buf.references, opts)
        map("n", "gs", vim.lsp.buf.signature_help, opts)

        map("n", "gq", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, opts)

        map("n", "<F2>", vim.lsp.buf.rename, opts)
        map({ "n", "x" }, "<F3>", function()
          vim.lsp.buf.format({ async = true })
        end, opts)
        map("n", "<F4>", vim.lsp.buf.code_action, opts)
      end,
    })

    require("fidget").setup({})


    require("mason").setup()
    require("mason-lspconfig").setup({
      handlers = {
        function(server_name)
          if server_name == "rust_analyzer" then
            return
          end
          lspconfig[server_name].setup({})
        end,

        ["eslint"] = function()
          lspconfig.eslint.setup({
            cmd = { "vscode-eslint-language-server", "--stdio" },
            filetypes = {
              "javascript",
              "javascriptreact",
              "javascript.jsx",
              "typescript",
              "typescriptreact",
              "typescript.tsx",
              "vue",
              "svelte",
              "astro",
              "htmlangular",
            },
            on_attach = function(_, bufnr)
              vim.bo[bufnr].formatexpr = "v:lua.vim.lsp.formatexpr()"
            end,
            settings = {
              workingDirectory = { mode = "auto" },
            },
          })
        end,

        ["bashls"] = function()
          lspconfig.bashls.setup({
            cmd = { "bash-language-server", "start" },
            filetypes = { "zsh", "bash", "sh" },
          })
        end,

        ["tailwindcss"] = function()
          lspconfig.tailwindcss.setup({
            settings = {
              tailwindCSS = {
                includeLanguages = {
                  javascript = "javascript",
                  typescript = "typescript",
                  javascriptreact = "javascriptreact",
                  typescriptreact = "typescriptreact",
                  html = "html",
                },
              },
            },
          })
        end,

        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = {
                  globals = { "vim", "require" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
              },
            },
          })
        end,
      },
    })
  end,
}
