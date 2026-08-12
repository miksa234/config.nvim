---@diagnostic disable: undefined-global
-- Undotree toggle
vim.keymap.set("n", "<leader>u", function()
  vim.cmd("packadd nvim.undotree")
  require("undotree").open({
    command = "topleft " .. math.floor(vim.api.nvim_win_get_width(0) / 4) .. "vnew",
  })
end, { desc = "[U]ndotree toggle" })

-- incremental selection treesitter/lsp
vim.keymap.set({ "n", "x", "o" }, "<A-o>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_parent(vim.v.count1)
  else
    vim.lsp.buf.selection_range(vim.v.count1)
  end
end, { desc = "Select parent treesitter node or outer incremental lsp selections" })

vim.keymap.set({ "n", "x", "o" }, "<A-i>", function()
  if vim.treesitter.get_parser(nil, nil, { error = false }) then
    require("vim.treesitter._select").select_child(vim.v.count1)
  else
    vim.lsp.buf.selection_range(-vim.v.count1)
  end
end, { desc = "Select child treesitter node or inner incremental lsp selections" })
