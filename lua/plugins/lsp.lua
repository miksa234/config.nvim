return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "j-hui/fidget.nvim",
    "hrsh7th/nvim-cmp",
    "hrsh7th/cmp-nvim-lsp",
  },
  config = function()
    map = vim.keymap.set
    vim.opt.signcolumn = "yes"
    vim.lsp.inlay_hint.enable(true)

    local lspconfig_defaults = require("lspconfig").util.default_config
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
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
      },
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
    })

    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities =
        vim.tbl_deep_extend("force", lspconfig_defaults.capabilities, cmp_lsp.default_capabilities())
    lspconfig_defaults.capabilities = capabilities

    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP actions",
      callback = function(event)
        local opts = { buffer = event.buf }

        map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
        map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
        map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
        map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
        map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
        map("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
        map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
        map("n", "gq", function()
          require("conform").format({ async = true, lsp_fallback = true })
        end, opts)
        map("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
        map({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)
        map("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
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

          require("lspconfig")[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ["eslint"] = function()
          local lspconfig = require("lspconfig")
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
            on_attach = function(client, bufnr)
              vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
            end,
            capabilities = capabilities,
            -- ESLint will automatically look for config files in the project
            settings = {
              workingDirectory = { mode = "auto" },
            },
          })
        end,
        ["bashls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.bashls.setup({
            cmd = { "bash-language-server", "start" },
            filetypes = { "zsh", "bash", "sh" },
            capabilities = capabilities,
          })
        end,
        ["tailwindcss"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.tailwindcss.setup({
            includeLangauges = {
              javascript = "js",
              html = "html",
              typescript = "ts",
              typescriptreact = "tsx",
              javascriptreact = "jsx",
            },
          })
        end,
        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup({
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                },
                diagnostics = {
                  globals = {
                    'vim',
                    'require'
                  },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                  enable = false,
                },
              },
            },
          })
        end,
      },
    })
  end,
}
