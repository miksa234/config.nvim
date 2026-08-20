return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  config = function()
    local treesitter = require("nvim-treesitter")
    treesitter.install({
      "astro", "bash", "css", "graphql", "html", "javascript", "json", "julia", "lua",
      "markdown", "markdown_inline", "nix", "python", "query", "rust", "sql", "svelte",
      "typescript", "vim", "vimdoc", "vue", "yaml",
    })

    local excluded = { html = true, markdown = true, text = true, tex = true }
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        if excluded[vim.bo[args.buf].filetype] then
          return
        end

        local path = vim.api.nvim_buf_get_name(args.buf)
        local stats = path ~= "" and vim.uv.fs_stat(path) or nil
        if stats and stats.size > 100 * 1024 then
          vim.notify("File larger than 100KB; Treesitter disabled", vim.log.levels.WARN)
          return
        end

        if pcall(vim.treesitter.start, args.buf) then
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end
}
