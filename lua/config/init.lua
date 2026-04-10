require("config.keymaps")
require("config.set")
require("config.autocmd")
require("config.diagnostics")

local lazyconfpath = vim.fn.stdpath("config") .. "/lua/config/lazy.lua"
local pluginspath = vim.fn.stdpath("config") .. "/lua/plugins"
if vim.uv.fs_stat(lazyconfpath) and vim.uv.fs_stat(pluginspath) then
  require("config.lazy")
end

