-- Shorten function name
local keymap = vim.keymap.set
local unmap = vim.keymap.del
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

keymap("n", "<c-p>", "<c-i>", opts)
keymap("n", "<tab>", ">>", opts)
keymap("n", "<s-tab>", "<<", opts)
keymap("v", "<tab>", ">gv", opts)
keymap("v", "<s-tab>", "<gv", opts)
keymap("n", "<leader>o", "o<ESC>", opts)
keymap("n", "<leader>O", "O<ESC>", opts)
keymap({"n", "i"}, ",;", "<ESC>A;<ESC>", opts)
keymap("i", ",z", "<", opts)
keymap("i", ",Z", ">", opts)
keymap("i", ",,", "<ESC>", opts)
keymap("n", "<leader><leader>x", "<CMD>write<CR><CMD>source %<CR>", opts) -- Resource current file.

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)
keymap("s", "p", "p", opts) -- Lets p get inserted as p in select-mode instead of acting as paste.

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts) -- Find Files
keymap("n", "<leader>ftr", ":Telescope live_grep<CR>", opts) -- Find Text Regex
keymap("n", "<leader>ftf", ":Telescope grep_string search=<CR>", opts) -- Find Text Fuzzy
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts) -- Find Projects
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts) -- Find Buffer
keymap("n", "<leader>th", ":Telescope help_tags<CR>", opts) -- Open help search

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)
keymap("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", opts)
