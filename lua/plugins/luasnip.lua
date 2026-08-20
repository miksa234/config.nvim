return {
  "L3MON4D3/LuaSnip",
  version = "v2.3.0",
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    ls.config.setup({
      enable_autosnippets = true,
      store_selection_keys = "<c-s>",
    })
    local snippet_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "snippets")
    for name, type in vim.fs.dir(snippet_dir) do
      if type == "file" and name:sub(-4) == ".lua" then
        local path = vim.fs.joinpath(snippet_dir, name)
        local chunk, err = loadfile(path)
        if not chunk then
          error(err)
        end
        local ok, load_err = pcall(chunk)
        if not ok then
          error(string.format("Failed to load snippets from %s: %s", path, load_err))
        end
      end
    end
  end
}
