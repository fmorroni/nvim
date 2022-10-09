local snip_status_ok, luasnip = pcall(require, "luasnip")
if snip_status_ok then
  -- vim.notify("Everything A-Okay at luasnips", vim.log.levels.INFO)
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

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "NonTest" } },
      },
    },
  },
}

local keymap = vim.keymap.set

keymap({ "i", "s" }, "<c-j>", function()
  if luasnip.jumpable(-1) then
    luasnip.jump(-1)
  end
end, { silent = true })

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

keymap("n", "<leader><leader>s", function()
  luasnip.cleanup()
  vim.cmd("source ~/.config/nvim/lua/user/luasnip_config/init.lua")
  vim.notify("Luasnips was reasourced.")
end)

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/lua/user/luasnip_config/snippets"})
