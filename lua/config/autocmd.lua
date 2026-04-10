local autocmd = vim.api.nvim_create_autocmd

-- Delete trailing whitespace
autocmd({'BufWritePre'}, {
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

autocmd({'BufEnter'}, {
  pattern = 'justfile',
  command = "set filetype=make";
})

autocmd({'BufWritePost'}, {
  pattern = vim.fn.expand('~') .. '/.config/X/Xresources',
  command = '!xrdb %',
})

autocmd({'BufWritePost'}, {
  pattern = vim.fn.expand('~') .. '/.config/X/Xresources.mon',
  command = '!xrdb %',
})
