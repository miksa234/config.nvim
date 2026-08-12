---@diagnostic disable: undefined-global

local M = {}

local function buf_dir(bufnr)
  local bt = vim.bo[bufnr].buftype
  if bt ~= nil and bt ~= '' then
    return nil
  end

  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' or name:find('Undo tree', 1, true) then
    return nil
  end

  -- Exclude non-filesystem buffers (URIs like term://, fugitive://, oil://, etc.)
  if name:match('^%a[%w+.-]*://') then
    return nil
  end

  return vim.fn.fnamemodify(name, ':p:h')
end

local function set_git(bufnr, info)
  local function apply()
    vim.b[bufnr].status_git = info
    vim.cmd('redrawstatus')
  end

  if vim.in_fast_event and vim.in_fast_event() then
    vim.schedule(apply)
  else
    apply()
  end
end

local function parse_git_status(stdout)
  local info = {
    branch = '',
    ahead = 0,
    behind = 0,
    staged = 0,
    unstaged = 0,
    untracked = 0,
  }

  local head, oid

  for line in (stdout or ''):gmatch('[^\n]+') do
    head = head or line:match('^# branch%.head%s+(.+)$')
    oid = oid or line:match('^# branch%.oid%s+([0-9a-f]+)$')

    local a = line:match('^# branch%.ab%s+%+(%d+)%s+%-(%d+)$')
    if a then
      info.ahead, info.behind = tonumber(line:match('%+(%d+)')) or 0, tonumber(line:match('%-(%d+)')) or 0
    end

    local xy = line:match('^[12]%s+(..)%s')
    if xy then
      local x, y = xy:sub(1, 1), xy:sub(2, 2)
      if x ~= '.' then
        info.staged = info.staged + 1
      end
      if y ~= '.' then
        info.unstaged = info.unstaged + 1
      end
    elseif line:match('^%?%s') then
      info.untracked = info.untracked + 1
    end
  end

  if head and head ~= '' then
    if head == '(detached)' then
      if oid and oid ~= '' and oid ~= '(initial)' then
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
  local dir = buf_dir(bufnr)
  if not dir then
    return set_git(bufnr, { branch = '' })
  end

  local function on_status(code, stdout)
    if code ~= 0 then
      return set_git(bufnr, { branch = '' })
    end
    local info = parse_git_status(stdout)
    if not info.branch or info.branch == '' then
      return set_git(bufnr, { branch = '' })
    end
    set_git(bufnr, info)
  end

  if vim.system then
    vim.system({ 'git', 'status', '--porcelain=2', '-b' }, { cwd = dir, text = true }, function(obj)
      on_status(obj.code, obj.stdout)
    end)
  else
    local out = vim.fn.system({ 'git', '-C', dir, 'status', '--porcelain=2', '-b' })
    on_status(vim.v.shell_error, out)
  end
end

function M.git_component()
  local info = vim.b.status_git
  if info == nil then
    M.update_git_branch(0)
    return ''
  end

  local branch = info.branch or ''
  if branch == '' then
    return ''
  end

  local parts = { string.format(' %s', branch) }

  if (info.ahead or 0) > 0 then
    parts[#parts + 1] = string.format('↑%d', info.ahead)
  end
  if (info.behind or 0) > 0 then
    parts[#parts + 1] = string.format('↓%d', info.behind)
  end
  if (info.staged or 0) > 0 then
    parts[#parts + 1] = string.format('+%d', info.staged)
  end
  if (info.unstaged or 0) > 0 then
    parts[#parts + 1] = string.format('~%d', info.unstaged)
  end
  if (info.untracked or 0) > 0 then
    parts[#parts + 1] = string.format('?%d', info.untracked)
  end

  return table.concat(parts, ' ')
end

function M.file_component()
  local name = vim.fn.expand('%:~:.')
  if name == '' then
    return '[No Name]'
  end

  local max = math.floor((vim.o.columns or 120) * 0.45)
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
