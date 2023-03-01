local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
  defaults = {

    prompt_prefix = " ",
    selection_caret = " ",
    path_display = { "smart" },
    file_ignore_patterns = { ".git/", "node_modules" },
    wrap_results = true,

    mappings = {
      i = {
        ["<C-n>"] = actions.cycle_history_next,
        ["<C-p>"] = actions.cycle_history_prev,

        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,

        ["<C-c>"] = actions.close,

        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,

        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,

        ["<C-y>"] = actions.results_scrolling_up,
        ["<C-e>"] = actions.results_scrolling_down,
      },
    },
  },

  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case", -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    },
  }
}

telescope.load_extension("fzf")

-- Keymaps
local keymap = vim.keymap.set
local builtin = require('telescope.builtin')

local include_hidden = function(fn)
  return function() fn({ hidden = true }) end
end
local include_ignored = function(fn)
  return function() fn({ no_ignore = true }) end
end
local include_hidden_ignored = function(fn)
  return function() fn({ hidden = true, no_ignore = true }) end
end
-- Find file
keymap("n", "<leader>fff", builtin.find_files)
keymap("n", "<leader>ffh", include_hidden(builtin.find_files))
keymap("n", "<leader>ffi", include_ignored(builtin.find_files))
keymap("n", "<leader>ffa", include_hidden_ignored(builtin.find_files))

local include_hidden = function(fn)
  return function()
    fn({ additional_args = function() return '--hidden' end })
  end
end
local include_ignored = function(fn)
  return function()
    fn({ additional_args = function() return '--no-ignore' end })
  end
end
local include_hidden_ignored = function(fn)
  return function()
    fn({ additional_args = function() return { '--hidden', '--no-ignore' } end })
  end
end
-- Find text by regex
keymap("n", "<leader>fgg", builtin.live_grep)
keymap("n", "<leader>fgh", include_hidden(builtin.live_grep))
keymap("n", "<leader>fgi", include_ignored(builtin.live_grep))
keymap("n", "<leader>fga", include_hidden_ignored(builtin.live_grep))

keymap("n", "<leader>ftf", ":Telescope grep_string search=<CR>") -- Find text by fuzzy search
keymap("n", "<leader>fp", ":Telescope projects<CR>") -- Find Projects
keymap("n", "<leader>fb", ":Telescope buffers<CR>") -- Find Buffer
keymap("n", "<leader>th", ":Telescope help_tags<CR>") -- Open help search
keymap("n", "gr", ":Telescope lsp_references<CR>")
