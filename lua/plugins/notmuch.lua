vim.pack.add({
  "https://github.com/yousefakbar/notmuch.nvim.git",
  "https://github.com/miksa234/notmuch-sidebar.nvim.git",
})

local accounts = {
  { name = "📥 milutin@popovic", root = "1-milutin@popovic.xyz" },
  { name = "📥 mika@popovic", root = "2-mika@popovic.xyz" },
  { name = "📥 milutin@oari", root = "3-milutin@oari.io", archive = false, junk = { "Spam" } },
  { name = "📥 milutin@ponnect", root = "4-milutin@ponnect.rs" },
  { name = "📥 info@ponnect", root = "5-info@ponnect.rs" },
  {
    name = "📥 hello@oari",
    root = "6-hello@oari.io",
    sent = { "Sent", "Sent Messages" },
    trash = { "Trash", "Deleted Messages" },
    junk = { "Spam" },
  },
  { name = "📥 univie", root = "7-a11807930@unet.univie.ac.at" },
}

require("notmuch").setup({
  maildir_sync_cmd = "mbsync -c $HOME/.config/isync/mbsyncrc -a -q && notmuch new 2>/dev/null",
  sync = { sync_mode = "buffer" },
})
require("notmuch-sidebar").setup({ accounts = accounts })

vim.keymap.set("n", "<leader>m1", function()
  require("notmuch-sidebar").open_account(1)
end, { desc = "Inbox: milutin@popovic" })
vim.keymap.set("n", "<leader>m2", function()
  require("notmuch-sidebar").open_account(2)
end, { desc = "Inbox: mika@popovic" })
vim.keymap.set("n", "<leader>m3", function()
  require("notmuch-sidebar").open_account(3)
end, { desc = "Inbox: milutin@oari" })
vim.keymap.set("n", "<leader>m4", function()
  require("notmuch-sidebar").open_account(4)
end, { desc = "Inbox: milutin@ponnect" })
vim.keymap.set("n", "<leader>m5", function()
  require("notmuch-sidebar").open_account(5)
end, { desc = "Inbox: info@ponnect" })
vim.keymap.set("n", "<leader>m6", function()
  require("notmuch-sidebar").open_account(6)
end, { desc = "Inbox: hello@oari" })
vim.keymap.set("n", "<leader>m7", function()
  require("notmuch-sidebar").open_account(7)
end, { desc = "Inbox: univie" })
vim.keymap.set("n", "<leader>mc", "<cmd>ComposeMail<CR>", { desc = "Mail: compose" })
vim.keymap.set("n", "<leader>md", "<cmd>NotmuchDrafts<CR>", { desc = "Mail: drafts" })
