return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "nvim-telescope/telescope-fzy-native.nvim",
  },

  config = function()
    local previewers = require("telescope.previewers")
    local _bad = { ".*%.tex", ".*%.md", ".*%.html" }
    local bad_files = function(filepath)
      for _, v in ipairs(_bad) do
        if filepath:match(v) then
          return false
        end
      end
      return true
    end
    local new_maker = function(filepath, bufnr, opts)
      opts = opts or {}
      if opts.use_ft_detect == nil then opts.use_ft_detect = true end
      opts.use_ft_detect = opts.use_ft_detect == false and false or bad_files(filepath)
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
            os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua",
            os.getenv("XDG_CONFIG_HOME") .. "/nvim/after",
            os.getenv("XDG_CONFIG_HOME") .. "/zsh",
            os.getenv("XDG_CONFIG_HOME") .. "/shell",
            os.getenv("XDG_CONFIG_HOME") .. "/X",
            os.getenv("XDG_CONFIG_HOME") .. "/X11",
            os.getenv("XDG_LOCAL_HOME") .. "/src",
            os.getenv("XDG_LOCAL_HOME") .. "/bin",
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
            os.getenv("XDG_CONFIG_HOME") .. "/nvim/lua",
            os.getenv("XDG_CONFIG_HOME") .. "/nvim/after",
            os.getenv("XDG_CONFIG_HOME") .. "/zsh",
            os.getenv("XDG_CONFIG_HOME") .. "/shell",
            os.getenv("XDG_CONFIG_HOME") .. "/X",
            os.getenv("XDG_CONFIG_HOME") .. "/X11",
            os.getenv("XDG_LOCAL_HOME") .. "/src",
            os.getenv("XDG_LOCAL_HOME") .. "/bin",
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
