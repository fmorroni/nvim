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
    ]]
.. "  ]]" .. [[,
      {{
        {}
      }}))]],
  {
    i(1, "var"),
    c(2, { rep(1), i(1) }),
    i(3, "snip body"),
    d(4, function(args)
      local snipBodyArgs = table.concat(args[1])
      local nodes = {}
      local keys = {}
      local snipBodyArgCount = 0
      for match in snipBodyArgs:gmatch("{([^{}]*)}") do
        snipBodyArgCount = snipBodyArgCount + 1
        table.insert(keys, match)
      end
      for j, key in ipairs(keys) do
        local node = {}
        if key ~= "" then
          table.insert(node, t(key .. " = "))
        end
        table.insert(node, i(1, "node_" .. j))
        if j < snipBodyArgCount then
          table.insert(node, t({",", ""}))
        else
          table.insert(node, t(","))
        end
        table.insert(nodes, isn(j, node, "    $PARENT_INDENT"))
      end

      return sn(1, nodes)
    end, 3),
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
