-- local make = R("tj.snips").make

local snip_status_ok, luasnip = pcall(require, "luasnip")
if snip_status_ok then
  vim.notify("Everything A-Okay at luasnips", vim.log.levels.INFO)
else
  vim.notify("luasnips: something went terribly wrong", vim.log.levels.ERROR)
  return
end
local types = require "luasnip.util.types"

luasnip.config.set_config {
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection.
  history = true,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = false,

  -- Deletion is buggy without this.
  region_check_events = "InsertEnter",
  delete_check_events = "TextChanged,InsertLeave",

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "NonTest" } },
      },
    },
  },
}

local keymap = vim.keymap.set

-- <c-k> is my expansion key.
-- This will expand the current item or jump to the next item within the snippet.
-- keymap({ "i", "s" }, "<c-k>", function()
--   if luasnip.expand_or_jumpable() then
--     luasnip.expand_or_jump()
--   end
-- end, { silent = true })

-- <c-j> is my jump backwards key.
-- This always moves to the previous item within the snippet.
keymap({ "i", "s" }, "<c-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

-- <c-l> is selecting within a list of options.
-- This is useful for choice nodes (introduced in the forthcoming episode 2).
keymap("i", "<c-l>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(1)
  end
end)
keymap("i", "<c-h>", function()
  if luasnip.choice_active() then
    luasnip.change_choice(-1)
  end
end)

-- No idea what this is for and it throws an error if the are no choice nodes available.
-- keymap("i", "<c-u>", require "luasnip.extras.select_choice")

-- shorcut to source my luasnips file again, which will reload my snippets
-- keymap("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/user/luasnip.lua<CR>")

-- Run after modifying already sourced snippets. Resource luasnip.lua after cleanup.
keymap("n", "<leader><leader>s", function()
  luasnip.cleanup()
  vim.cmd("source ~/.config/nvim/lua/user/luasnip.lua")
  vim.notify("Luasnips was reasourced.")
end)

---- create snippet ----
-- s(context, nodes, condition, ...)
local snippet = luasnip.snippet

-- TODO: Write about this.
--  Useful for dynamic nodes and choice nodes
local sn = luasnip.snippet_node
local isn = luasnip.indent_snippet_node

-- This is the simplest node.
--  Creates a new text node. Places cursor after node by default.
--  t { "this will be inserted" }
--
--  Multiple lines are by passing a table of strings.
--  t { "line 1", "line 2" }
local t = luasnip.text_node

-- Insert Node
--  Creates a location for the cursor to jump to.
--      Possible options to jump to are 1 - N
--      If you use 0, that's the final place to jump to.
--
--  To create placeholder text, pass it as the second argument
--      i(2, "this is placeholder text")
local i = luasnip.insert_node

-- Function Node
--  Takes a function that returns text
local f = luasnip.function_node

-- This a choice snippet. You can move through with <c-l> (in my config)
--   c(1, { t {"hello"}, t {"world"}, }),
--
-- The first argument is the jump position
-- The second argument is a table of possible nodes.
--  Note, one thing that's nice is you don't have to include
--  the jump position for nodes that normally require one (can be nil)
local c = luasnip.choice_node

local d = luasnip.dynamic_node

-- TODO: Document what I've learned about lambda
local l = require("luasnip.extras").lambda

-- This is a format node.
-- It takes a format string and a list of nodes.
-- fmt(<fmt-string>, {..., nodes})
-- Works similar to f strings in python.
local fmt = require("luasnip.extras.fmt").fmt

-- Repeats a node.
-- rep(<position of node to repeat>)
local rep = require("luasnip.extras").rep

local events = require "luasnip.util.events"

luasnip.add_snippets("lua", {
  snippet("newsnip", fmt([[
    snippet("{}", fmt([[
      {}
    ]] .. "]]" .. [[,
      {{
        {}
      }})),]], {
    i(1, "snip name"),
    i(2, "snip body"),
    i(3, "nodes")
  })),
  snippet("?:", fmt([[
    ({}) and {} or {};
  ]],
    {
      i(1, "condition"),
      i(2, "then"),
      i(3, "else")
    })),
  snippet("fun", fmt([[
    {}{} =  function({})
      {}
    end
  ]],
    {
      c(1, { t("local "), t("") }),
      i(2, "name"),
      i(3, "args"),
      i(4, "body"),
    })),
})


luasnip.add_snippets("c", {
  snippet("?:", fmt([[
    ({}) ? {} : {};
  ]],
    {
      i(1, "condition"),
      i(2, "then"),
      i(3, "else")
    })),
  snippet({ trig = "matrix" }, fmt([[
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
        local index = 1
        for row = 1, rows, 1 do
          table.insert(mat, t("{"))
          for col = 1, cols, 1 do
            if placeholder == "1" then
              table.insert(mat, i(index, placeholder))
            else
              table.insert(mat, sn(index, { t("'"), i(1, placeholder), t("'") }))
              -- table.insert(mat, i(index, placeholder))
              -- table.insert(mat, t("'"))
            end
            if col < cols then table.insert(mat, t(", ")) end
            index = index + 1
          end
          if row < rows then
            table.insert(mat, t({ "},", "" }))
          else
            table.insert(mat, t({ "}" }))
          end
        end
        P(mat)
        return isn(1, mat, "  $PARENT_INDENT")
      end, { 1, 3, 4 }),
    })),
})