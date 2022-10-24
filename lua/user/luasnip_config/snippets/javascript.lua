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

local function defExport(args)
  local default = string.match(args[1][1], "(%a*).?%a*$")
  return sn(nil, c(1, { sn(nil, { t("{ "), i(1), t(" }") }), i(nil, default)}))
end

local import = s("import", fmt([[
    import {} from '{}'
  ]],
  {
    d(2, defExport, 1),
    i(1, "path"),
  }))

local ifStatement = s("if", fmt([[
    if ({}) {{
      {}
    }}
  ]],
  {
    i(1, "condition"),
    i(2),
  }))

return {
  import,
  ifStatement,
}
