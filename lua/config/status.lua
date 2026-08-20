local M = {}

local function buf_dir(bufnr)
  local bt = vim.bo[bufnr].buftype
  if bt ~= nil and bt ~= "" then
    return nil
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" or name:find("Undo tree", 1, true) then
    return nil
  end

  if name:match("^%a[%w+.-]*://") then
    return nil
  end

  return vim.fs.dirname(name)
end

local function set_git(bufnr, info, request, name)
  if vim.api.nvim_buf_is_valid(bufnr)
      and vim.b[bufnr].status_git_request == request
      and vim.api.nvim_buf_get_name(bufnr) == name then
    vim.b[bufnr].status_git = info
    vim.b[bufnr].status_git_pending = nil
    vim.cmd("redrawstatus")
  end
end

local function parse_git_status(stdout)
  local info = {
    repo = "",
    branch = "",
    ahead = 0,
    behind = 0,
    staged = 0,
    unstaged = 0,
    untracked = 0,
  }

  local head, oid

  for line in (stdout or ""):gmatch("[^\n]+") do
    head = head or line:match("^# branch%.head%s+(.+)$")
    oid = oid or line:match("^# branch%.oid%s+([0-9a-f]+)$")

    local ahead, behind = line:match("^# branch%.ab%s+%+(%d+)%s+%-(%d+)$")
    if ahead then
      info.ahead, info.behind = tonumber(ahead), tonumber(behind)
    end

    local xy = line:match("^[12]%s+(..)%s")
    if xy then
      local x, y = xy:sub(1, 1), xy:sub(2, 2)
      if x ~= "." then
        info.staged = info.staged + 1
      end
      if y ~= "." then
        info.unstaged = info.unstaged + 1
      end
    elseif line:match("^%?%s") then
      info.untracked = info.untracked + 1
    end
  end

  if head and head ~= "" then
    if head == "(detached)" then
      if oid and oid ~= "" and oid ~= "(initial)" then
        info.branch = oid:sub(1, 7)
      end
    else
      info.branch = head
    end
  end

  return info
end

function M.update_git_branch(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  if bufnr == 0 then
    bufnr = vim.api.nvim_get_current_buf()
  end
  local name = vim.api.nvim_buf_get_name(bufnr)
  if vim.b[bufnr].status_git_pending == name then
    return
  end
  local request = (vim.b[bufnr].status_git_request or 0) + 1
  vim.b[bufnr].status_git_request = request
  vim.b[bufnr].status_git_pending = name
  local dir = buf_dir(bufnr)
  if not dir then
    return set_git(bufnr, { branch = "" }, request, name)
  end

  vim.system({ "git", "-C", dir, "rev-parse", "--show-toplevel" }, { text = true }, vim.schedule_wrap(function(root_result)
    local root = vim.trim(root_result.stdout or "")
    if root_result.code ~= 0 or root == "" then
      return set_git(bufnr, { branch = "" }, request, name)
    end

    vim.system({ "git", "-C", root, "status", "--porcelain=2", "-b" }, { text = true }, vim.schedule_wrap(function(result)
      local info = parse_git_status(result.stdout)
      if result.code ~= 0 or info.branch == "" then
        return set_git(bufnr, { branch = "" }, request, name)
      end

      info.repo = vim.fs.basename(root)
      set_git(bufnr, info, request, name)
    end))
  end))
end

function M.git_component()
  local info = vim.b.status_git
  if info == nil then
    M.update_git_branch(0)
    return ""
  end

  local branch = info.branch or ""
  if branch == "" then
    return ""
  end

  local repo = info.repo or ""
  local label = repo ~= "" and string.format("%s - %s", repo, branch) or branch
  local parts = { string.format(" %s", label) }

  if (info.ahead or 0) > 0 then
    parts[#parts + 1] = string.format("↑%d", info.ahead)
  end
  if (info.behind or 0) > 0 then
    parts[#parts + 1] = string.format("↓%d", info.behind)
  end
  if (info.staged or 0) > 0 then
    parts[#parts + 1] = string.format("+%d", info.staged)
  end
  if (info.unstaged or 0) > 0 then
    parts[#parts + 1] = string.format("~%d", info.unstaged)
  end
  if (info.untracked or 0) > 0 then
    parts[#parts + 1] = string.format("?%d", info.untracked)
  end

  return table.concat(parts, " ")
end

function M.file_component()
  local name = vim.fn.expand("%:~:.")

  local max = math.floor((vim.o.columns or 120) * 0.7)
  if #name > max then
    name = vim.fn.pathshorten(name)
  end

  return name
end

vim.o.statusline = table.concat({
  "%{v:lua.require'config.status'.git_component()}",
  " - ",
  "%{v:lua.require'config.status'.file_component()}",
  " %m",
  "%=",
  "%y",
  " · ",
  "%l:%c",
})

return M
