local function merge(path)
  if vim.bo.modified then
    return vim.notify("Save the buffer before resolving the conflict", vim.log.levels.WARN)
  end

  local buf = vim.api.nvim_get_current_buf()
  vim.cmd.tabnew()
  vim.fn.jobstart({
    "git", "--literal-pathspecs", "-C", vim.fs.dirname(path),
    "mergetool", "--tool=nvimdiff2", "--no-prompt", "--", vim.fs.basename(path),
  }, {
    term = true,
    -- Keep Git's shell script from globbing filenames such as [id].tsx.
    env = { SHELLOPTS = "noglob" },
    on_exit = function()
      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(buf) and not vim.bo[buf].modified then
          vim.cmd("checktime " .. buf)
        end
      end)
    end,
  })
  vim.cmd.startinsert()
end

local function toggle()
  local win = vim.t.gitdiff_win
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, false)
    vim.t.gitdiff_win = nil
    return
  end
  vim.t.gitdiff_win = nil

  local path = vim.api.nvim_buf_get_name(0)
  if path == "" or vim.bo.buftype ~= "" then
    return vim.notify("GitDiff needs a file buffer", vim.log.levels.WARN)
  end
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.wo[win].diff then
      return vim.notify("Close the existing diff first", vim.log.levels.WARN)
    end
  end
  if vim.fn.executable("git") == 0 then
    return vim.notify("git is not on PATH", vim.log.levels.WARN)
  end

  local function git(...)
    return vim.system(vim.list_extend({
      "git", "-C", vim.fs.dirname(path),
    }, { ... }), { text = true }):wait()
  end

  local name = vim.fs.basename(path)
  local result = git("ls-files", "--stage", "--error-unmatch", "--", ":(literal)" .. name)
  if result.code == 0 then
    -- Index stages 1-3 indicate an unresolved conflict.
    if result.stdout:match("^%d+ %x+ [123]\t") then
      return merge(path)
    end
    result = git("show", ":./" .. name)
  elseif result.code == 1 then
    result = git("check-ignore", "--quiet", "--", name)
    if result.code == 0 then
      return vim.notify("GitDiff: file is ignored by Git", vim.log.levels.WARN)
    elseif result.code == 1 then
      result = { code = 0, stdout = "" }
    end
  end
  if result.code ~= 0 then
    return vim.notify("GitDiff: " .. vim.trim(result.stderr), vim.log.levels.WARN)
  end
  if result.stdout:find("\0", 1, true) then
    return vim.notify("GitDiff does not support binary files", vim.log.levels.WARN)
  end

  local filetype = vim.bo.filetype
  local lines = vim.split(result.stdout, "\n", { plain = true })
  if lines[#lines] == "" and #lines > 1 then
    table.remove(lines)
  end

  vim.cmd("leftabove vnew")
  vim.t.gitdiff_win = vim.api.nvim_get_current_win()
  vim.bo.buftype = "nofile"
  vim.bo.bufhidden = "wipe"
  vim.bo.buflisted = false
  vim.bo.swapfile = false
  vim.api.nvim_buf_set_name(0, "git-index://" .. vim.api.nvim_get_current_tabpage() .. path)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.bo.filetype = filetype
  vim.bo.modified = false
  vim.bo.modifiable = false
  vim.bo.readonly = true
  vim.cmd.diffthis()
  vim.cmd.wincmd("p")
  vim.cmd.diffthis()
end

vim.api.nvim_create_user_command("GitDiff", toggle, { desc = "Diff current file or resolve Git conflict" })
vim.keymap.set("n", "<leader>gd", toggle, { desc = "Git diff or resolve conflict" })
