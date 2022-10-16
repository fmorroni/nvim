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

local ternary = s("?:", fmt([[
    ({}) ? {} : {};
  ]],
  {
    i(1, "condition"),
    i(2, "then"),
    i(3, "else")
  }))

local include = s("inc", fmt([[
    #include {}
  ]],
  {
    c(1, {
      sn(nil, { t("<"), i(1), t(">") }),
      sn(nil, { t("\""), i(1), t("\"") }),
    })
  }))

local matrix = s({ trig = "matrix" }, fmt([[
    {} {}[{}][{}] = {{
      {}
    }};
  ]],
  {
    c(1, { t("int"), t("char") }),
    i(2, "varName"),
    i(3, "1"),
    i(4, "1"),
    d(5, function(args)
      local rows = tonumber(args[2][1])
      local cols = tonumber(args[3][1])
      local placeholder = (args[1][1] == "int") and "1" or "A";
      local mat = {}
      for row = 1, rows, 1 do
        local index = 1
        local rowNode = {}
        table.insert(rowNode, t("{"))
        for col = 1, cols, 1 do
          local eleNode
          if placeholder == "1" then
            eleNode = i(index, placeholder)
          else
            eleNode = sn(index, { t("'"), i(1, placeholder), t("'") })
          end
          table.insert(rowNode, eleNode)
          if col < cols then table.insert(rowNode, t(", ")) end
          index = index + 1
        end
        if row < rows then
          table.insert(rowNode, t({ "},", "" }))
        else
          table.insert(rowNode, t({ "}" }))
        end
        table.insert(mat, sn(row, rowNode))
      end
      return isn(1, mat, "  $PARENT_INDENT")
    end, { 1, 3, 4 }),
  }))

local printf = s("pf", fmt([[
    printf("{string}{newlineChoice}"{arguments});
  ]],
  {
    string = i(1),
    newlineChoice = c(2, { t("\\n"), t("") }),
    arguments = d(3, function(args)
      local nodes = {}
      local string = table.concat(args[1]):gsub("%%%%", "")
      local argCount = 0
      local keys = {}
      for match in string:gmatch("%%[^%% ]-([a-zA-Z][a-zA-Z]?)") do
        argCount = argCount + 1
        table.insert(keys, match)
      end
      if argCount > 0 then
        table.insert(nodes, t(", "))
      end
      for j, key in ipairs(keys) do
        table.insert(nodes, i(j, key))
        if j < argCount then
          table.insert(nodes, t(", "))
        end
      end
      return sn(1, nodes)
    end, 1),
  }))

local functionSnip = s("fun", fmt([[
    {type} {functionName}({args}) {{
      {body}{}
    }}
  ]],
  {
    type = i(1, "type"),
    functionName = i(2, "name"),
    args = i(3, "args..."),
    body = i(4),
    d(5, function(args)
      local node
      if args[1][1] ~= "void" then
        node = sn(nil, { t({ "", "", "  return " }), i(1, args[1][1]), t(";") })
      else
        node = sn(nil, t(""))
      end
      return node
    end, 1),
  }))

return {
  ternary,
  include,
  matrix,
  printf,
  functionSnip,
}
