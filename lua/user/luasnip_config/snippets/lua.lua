local ls = require("luasnip")
local s = ls.s
local t = ls.t
local c = ls.c
local i = ls.i

local f = ls.f
local d = ls.d
local sn = ls.sn
local isn = ls.indent_snippet_node

local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local ai = require("luasnip.nodes.absolute_indexer")

local newsnip = s("newsnip", fmt([[
    local {} = s("{}", fmt([[
      {}
    ]] .. "]]" .. [[,
      {{
        {}
      }})),]],
  {
    i(1, "var"),
    i(2, "snip name"),
    i(3, "snip body"),
    i(4, "nodes")
  }))
local ternary = s("?:", fmt([[
    ({}) and {} or {}
  ]],
  {
    i(1, "condition"),
    i(2, "then"),
    i(3, "else")
  }))
local fun = s("fun", fmt([[
    {}{} =  function({})
      {}
    end
  ]],
  {
    c(1, { t("local "), t("") }),
    i(2, "name"),
    i(3, "args"),
    i(4, "body"),
  }))

return {
  newsnip,
  ternary,
  fun,
}
