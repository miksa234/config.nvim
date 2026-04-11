---@diagnostic disable: undefined-global
return {
  "mrcjkb/rustaceanvim",
  version = "^9", -- or remove to track latest
  ft = { "rust" },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = "rounded",
        },
      },
      server = {
        on_attach = function(_, bufnr)
          local map = function(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, { buffer = bufnr, silent = true, desc = desc })
          end

          map("<leader>a", function()
            vim.cmd.RustLsp("codeAction")
          end, "Rust code action")

          map("K", function()
            vim.cmd.RustLsp({ "hover", "actions" })
          end, "Rust hover/actions")
        end,

        settings = {
          ["rust-analyzer"] = {
            diagnostics = { enable = true },
            cargo = {
              loadOutDirsFromCheck = true,
              allFeatures = true,
            },
            inlayHints = {
              maxLength = 50,
              renderColons = true,
              bindingModeHints = { enable = false },
              chainingHints = { enable = true },
              closingBraceHints = { enable = true, minLines = 50 },
              closureCaptureTypeHints = { enable = true },
              closureReturnTypeHints = { enable = true },
              lifetimeElisionHints = { enable = true, useParameterNames = false },
              genericParameterHints = {
                const = { enable = true },
                lifetime = { enable = true },
                type = { enable = true },
              },
              parameterHints = { enable = true },
              reborrowHints = { enable = "never" },
              typeHints = {
                enable = true,
                hideClosureInitialization = false,
                hideNamedConstructor = false,
              },
            },
          },
        },
      },
    }
  end,
}
