local dir = vim.fn.stdpath("config") .. "/lua/plugins"

if not vim.uv.fs_stat(dir) then
  return
end

for name, kind in vim.fs.dir(dir) do
  if (kind == "file" or kind == "link") and name:sub(-4) == ".lua" then
    require("plugins." .. name:gsub("%.lua$", ""))
  end
end
