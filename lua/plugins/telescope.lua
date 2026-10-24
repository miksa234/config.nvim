vim.pack.add({
  "https://github.com/nvim-lua/plenary.nvim.git",
  "https://github.com/nvim-lua/popup.nvim.git",
  "https://github.com/nvim-telescope/telescope-fzy-native.nvim.git",
  "https://github.com/nvim-telescope/telescope.nvim.git",
})

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
  extensions = {
    fzy_native = {},
  },
}

local builtin = require('telescope.builtin')
require('telescope').load_extension('fzy_native')

vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

local function dotfiles_root()
  local root = vim.env.XDG_DOTFILES
  if not root or not vim.uv.fs_stat(root) then
    vim.notify("XDG_DOTFILES is not a valid directory", vim.log.levels.ERROR)
    return nil
  end
  return root
end

vim.api.nvim_create_user_command(
  'FindConfig',
  function()
    local root = dotfiles_root()
    if not root then return end
    builtin.find_files({
      search_dirs = { root },
      hidden = true,
    })
  end,
  {}
)
vim.keymap.set('n', '<leader>lf', ":FindConfig<CR>")

vim.api.nvim_create_user_command(
  'GrepConfig',
  function()
    local root = dotfiles_root()
    if not root then return end
    builtin.live_grep({
      search_dirs = { root },
      hidden = true,
    })
  end,
  {}
)
vim.keymap.set('n', '<leader>lg', ":GrepConfig<CR>")

vim.keymap.set('n', '<C-s>', builtin.spell_suggest, {})
