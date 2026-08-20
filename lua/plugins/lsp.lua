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

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local ok_blink, blink = pcall(require, "blink.cmp")
    if ok_blink and type(blink.get_lsp_capabilities) == "function" then
      capabilities = vim.tbl_deep_extend("force", capabilities, blink.get_lsp_capabilities())
    end

    vim.lsp.config("*", { capabilities = capabilities })

    require("conform").setup({
      formatters = {
        latexindent = {
          prepend_args = { "-y=defaultIndent:'  '" },
        },
        rustfmt = {},
      },
      formatters_by_ft = {
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        vue = { "prettier" },
        css = { "prettier" },
        scss = { "prettier" },
        lua = { lsp_format = "fallback" },
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
        python = { "black" },
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
          require("conform").format({
            async = true,
            lsp_format = "fallback",
            timeout_ms = 5000,
          })
        end, opts)

        map("n", "<F2>", vim.lsp.buf.rename, opts)
        map("n", "<F4>", vim.lsp.buf.code_action, opts)
      end,
    })

    require("fidget").setup({})


    vim.lsp.config("eslint", {
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
      settings = { workingDirectory = { mode = "auto" } },
    })

    vim.lsp.config("bashls", {
      cmd = { "bash-language-server", "start" },
      filetypes = { "zsh", "bash", "sh" },
    })

    vim.lsp.config("tailwindcss", {
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

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim", "require" } },
          workspace = { library = vim.api.nvim_get_runtime_file("", true) },
          telemetry = { enable = false },
        },
      },
    })

    require("mason").setup()
    require("mason-lspconfig").setup({
      automatic_enable = {
        exclude = { "rust_analyzer" },
      },
    })
  end,
}
