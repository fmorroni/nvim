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

local image = s("img", fmt([[
    ![{altText}]({path})
  ]],
  {
    altText = i(1, 'alternative text'),
    path = i(2, 'image path'),
  }))

local imageFromClipboard = s("pimg", fmt([[
    ![{altText}]({path})
  ]],
  {
    altText = i(1, 'alternative text'),
    path = f(function(args)
      local dirName = 'images'
      vim.cmd("[ ! -d " .. dirName .. " ] && mkdir " .. dirName)
      local clipboardDir = '/home/franco/.cache/xfce4/clipman/'
      vim.cmd("!cp " .. clipboardDir .. "(ls -At | awk '/image/' | head -1) " .. dirName .. "/" .. args[1][1])
      return dirName .. "/" .. args[1][1]
    end, {1}),
  }))

return {
  image,
  imageFromClipboard,
}
