local buf, win

local function toggle()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.cmd.stopinsert()
    vim.api.nvim_win_close(win, true)
    win = nil
    return
  end
  if not (buf and vim.api.nvim_buf_is_valid(buf)) then
    buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].bufhidden = "hide"
  end

  local scale = 0.65
  local height = math.max(1, math.floor((vim.o.lines - vim.o.cmdheight) * scale))
  local width = math.max(1, math.floor(vim.o.columns * scale))
  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.max(0, math.floor((vim.o.lines - vim.o.cmdheight - height) / 2) - 1),
    col = math.max(0, math.floor((vim.o.columns - width) / 2) - 1),
    style = "minimal",
    border = "single",
  })
  if vim.bo[buf].buftype ~= "terminal" then
    vim.fn.jobstart({ "zsh" }, { term = true })
    vim.keymap.set("t", "<C-t>", toggle, { buffer = buf, desc = "Toggle terminal" })
  end
  vim.cmd.startinsert()
end

vim.keymap.set("n", "<C-t>", toggle, { desc = "Toggle floating terminal" })
