local ls = require("luasnip")

local s = ls.snippet

local date = function() return {os.date('%Y-%m-%d')} end
local func = ls.function_node

ls.add_snippets(nil, {
  all = {
    s({
      trig = "date",
      namr = "Date",
      dscr = "Date in the form of YYYY-MM-DD",
    }, {
      func(date, {}),
    }),
  },
})
