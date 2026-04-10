return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function ()
    require("nvim-treesitter").setup({
--    ensure_installed = "none",
      auto_install = true,
      indent = {
        enable = true
      },
      highlight = {
        enable = true,
        disable = function(lang, buf)
          local langs = { "latex", "html" , "markdown", "text"}
          for i=1,#langs do
            if lang == langs[i] then
              return true
            end
          end

          local max_filesize = 100 * 1024 -- 100 KB
          local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
          if ok and stats and stats.size > max_filesize then
            vim.notify(
              "File larger than 100KB treesitter disabled for performance",
              vim.log.levels.WARN,
              {title = "Treesitter"}
            )
            return true
          end
        end,
        additional_vim_regex_highlighting=false,
      },
    })
  end

}
