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

return {
  {
    "yousefakbar/notmuch.nvim",
    opts = {
      maildir_sync_cmd = "mbsync -c $HOME/.config/isync/mbsyncrc -a -q && notmuch new 2>/dev/null",
      sync = { sync_mode = "buffer" },
    },
    config = function(_, opts) require("notmuch").setup(opts) end,
  },
  {
    "miksa234/notmuch-sidebar.nvim",
    dependencies = { "yousefakbar/notmuch.nvim" },
    event = "VeryLazy",
    opts = { accounts = accounts },
    config = function(_, opts) require("notmuch-sidebar").setup(opts) end,
    keys = {
      { "<leader>m1", function() require("notmuch-sidebar").open_account(1) end, desc = "Inbox: milutin@popovic" },
      { "<leader>m2", function() require("notmuch-sidebar").open_account(2) end, desc = "Inbox: mika@popovic" },
      { "<leader>m3", function() require("notmuch-sidebar").open_account(3) end, desc = "Inbox: milutin@oari" },
      { "<leader>m4", function() require("notmuch-sidebar").open_account(4) end, desc = "Inbox: milutin@ponnect" },
      { "<leader>m5", function() require("notmuch-sidebar").open_account(5) end, desc = "Inbox: info@ponnect" },
      { "<leader>m6", function() require("notmuch-sidebar").open_account(6) end, desc = "Inbox: hello@oari" },
      { "<leader>m7", function() require("notmuch-sidebar").open_account(7) end, desc = "Inbox: univie" },
      { "<leader>mc", "<cmd>ComposeMail<CR>", desc = "Mail: compose" },
      { "<leader>md", "<cmd>NotmuchDrafts<CR>", desc = "Mail: drafts" },
    },
  },
}
