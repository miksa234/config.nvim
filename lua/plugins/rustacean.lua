return {
  'mrcjkb/rustaceanvim',
  version = '^8',
  lazy = false,
  dependencies = {
    "mason-org/mason-registry",
  },
  config = function()
    vim.g.rustaceanvim = {
      tools = {
        float_win_config = {
          border = "rounded",
        }
      },
      server = {
        on_attach = function(client, bufnr)
          vim.keymap.set(
            "n",
            "<leader>a",
            function()
              vim.cmd.RustLsp('codeAction')
            end,
            { silent = true, buffer = bufnr }
          )
          vim.keymap.set(
            "n",
            "K",
            function()
              vim.cmd.RustLsp({'hover', 'actions'})
            end,
            { silent = true, buffer = bufnr }
          )
        end,
        cmd = { 'rust-analyzer' },
        default_settings = {
          ['rust-analyzer'] = {
            diagnostics = {
              enable = true;
            },
            cargo = {
            loadOutDirsFromCheck = true,
              allFeatures = true,
            },
          },
        },
        settings = {
          ['rust-analyzer'] = {
            inlayHints = {
              maxLength = 50,
              renderColons = true,
              bindingModeHints = {
                enable = false,
              },
              chainingHints = {
                enable = true,
              },
              closingBraceHints = {
                enable = true,
                minLines = 50,
              },
              closureCaptureTypeHints = {
                enable = true,
              },
              closureReturnTypeHints = {
                enable = true,
              },
              lifetimeElisionHints = {
                enable = true,
                useParameterNames = false,
              },
              genericParameterHints = {
                const = {
                  enable = true,
                },
                lifetime = {
                  enable = true,
                },
                type = {
                  enable = true,
                },
              },
              parameterHints = {
                enable = true,
              },
              reborrowHints = {
                enable = "never",
              },
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

  end
}
