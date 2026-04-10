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
    for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/snippets/*.lua", true)) do
      loadfile(ft_path)()
    end



  end
}
