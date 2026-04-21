---@diagnostic disable: undefined-global
return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
  },

  config = function()
    local previewers = require("telescope.previewers")
    local bad_patterns = { ".*%.tex$", ".*%.md$", ".*%.html$" }

    local is_bad_file = function(filepath)
      for _, pat in ipairs(bad_patterns) do
        if filepath:match(pat) then
          return true
        end
      end
      return false
    end

    local new_maker = function(filepath, bufnr, opts)
      opts = opts or {}

      if is_bad_file(filepath) then
        vim.bo[bufnr].modifiable = true
        vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "Preview disabled for: " .. filepath })
        vim.bo[bufnr].modifiable = false
        return
      end

      previewers.buffer_previewer_maker(filepath, bufnr, opts)
    end

    local edge_borders = {
      prompt = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      results = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      preview = { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
    }

    require("telescope").setup {
      defaults =
          vim.tbl_extend(
            "force",
            require("telescope.themes").get_dropdown({}),
            {
              borderchars = edge_borders,
              layout_strategy = "horizontal",
              layout_config = {
                horizontal = {
                  prompt_position = "top",
                  preview_width = 0.55,
                  results_width = 0.8,
                },
              },
              buffer_previewer_maker = new_maker,
            }
          ),
      extentions = {
        fzf = {}
      }
    }

    local builtin = require('telescope.builtin')
    require('telescope').load_extension('fzy_native')

    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

    vim.api.nvim_create_user_command(
      'FindConfig',
      function()
        builtin.find_files({
          search_dirs = {
            os.getenv("XDG_DOTFILES"),
          },
          hidden = true,
        })
      end,
      {}
    )
    vim.keymap.set('n', '<leader>lf', ":FindConfig<CR>")

    vim.api.nvim_create_user_command(
      'GrepConfig',
      function()
        builtin.live_grep({
          search_dirs = {
            os.getenv("XDG_DOTFILES"),
          },
          hidden = true,
        })
      end,
      {}
    )
    vim.keymap.set('n', '<leader>lg', ":GrepConfig<CR>")

    vim.keymap.set('n', '<C-s>', builtin.spell_suggest, {})
  end
}
