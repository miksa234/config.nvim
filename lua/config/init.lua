---@diagnostic disable: undefined-global
for name, t in vim.fs.dir(vim.fn.stdpath("config") .. "/lua/config") do
  if t == "file" and name:sub(-4) == ".lua" and name ~= "init.lua" then
    require("config." .. name:gsub("%.lua$", ""))
  end
end
