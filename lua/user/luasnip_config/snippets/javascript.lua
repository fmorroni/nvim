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
  return sn(nil, c(1, {
    sn(nil, { t("{ "), i(1), t(" }") }),
    i(nil, default),
  }))
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

local tryCatch = s("try", fmt([[
    try {{
      {}
    }} catch({}) {{
      {}
    }}
  ]],
  {
    i(1),
    i(2, 'err'),
    i(3),
  }))

local forStatement = s("for", fmt([[
    for ({}) {{
      {}
    }}
  ]],
  {
    c(1, {
      sn(nil, {
        i(1), -- Needed to be able to switch to the other sn().
        t("const "),
        c(2, {
          sn(nil, { i(1, "ele"), t(" of "), i(2, "iterable") }),
          sn(nil, { i(1, "key"), t(" in "), i(2, "obj") }),
        }),
      }),
      sn(nil, fmt("let {} = 0; {} < {}.length; ++{}", { i(1, "i"), rep(1), i(2, "array"), rep(1) })),
    }),
    i(2),
  }))

local ternary = s("?:", fmt([[
    ({}) ? {} : {};
  ]],
  {
    i(1, "condition"),
    i(2, "then"),
    i(3, "else")
  }))

return {
  import,
  ifStatement,
  tryCatch,
  forStatement,
  ternary,
}
