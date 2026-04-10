local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

ls.add_snippets("rust", {
  s(
    "match",
    fmt([[
    match {} {{
        {} => {{
           {}
        }}
        {} => {{
            {}
        }}
    }};]], { i(1), i(2), i(3), i(4), i(5) }
  )),
})
