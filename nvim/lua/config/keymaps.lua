local default_opts = { silent = true, nowait = true }

local map = function(mode, lhs, rhs, opts)
  opts = opts or {}
  setmetatable(opts, { __index = default_opts })
  vim.keymap.set(mode, lhs, rhs, opts)
end

-- GENERAL
map("n", "<esc>", "<cmd>noh<cr>", { desc = "Clear highlights" })
map("n", "<c-a>", "gg<s-v>G", { desc = "Select all" })
map("n", "r", "<c-r>", { desc = "Redo" })
map("n", "<c-_>", "gcc", { remap = true, desc = "Toggle comment" })
map("i", "<c-_>", "<esc>gcca", { remap = true, desc = "Toggle comment" })
map("v", "<c-_>", "gb", { remap = true, desc = "Toggle selection" })

-- NORMALIZE
map("n", "<c-u>", "<c-u>zz", { desc = "Center jump up" })
map("n", "<c-d>", "<c-d>zz", { desc = "Center jump down" })
map("n", "N", "Nzzzv", { desc = "Center search jump up" })
map("n", "n", "nzzzv", { desc = "Center search jump down" })

-- WINDOW MANAGEMENT
map("n", "<c-h>", "<c-w>h", { desc = "Window left" })
map("n", "<c-j>", "<c-w>j", { desc = "Window down" })
map("n", "<c-k>", "<c-w>k", { desc = "Window up" })
map("n", "<c-l>", "<c-w>l", { desc = "Window right" })
map("n", "<c-left>", "<cmd>vertical resize +2<cr>", { desc = "Increase width" })
map("n", "<c-right>", "<cmd>vertical resize -2<cr>", { desc = "Decrease width" })
map("n", "zx", "<cmd>split<return><c-w>w", { desc = "Split horizontally" })
map("n", "zc", "<cmd>vsplit<return><c-w>w", { desc = "Split vertically" })

-- BUFFER MANAGEMENT
map("n", "<s-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<s-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map({ "n", "i" }, "<c-s>", function()
  vim.cmd.write()
end, { desc = "Save buffer (no format)" })
map("n", "<c-w>", "<cmd>lua require('mini.bufremove').delete(0)<cr>", { desc = "Delete buffer" })
map("n", "<s-w>", "<cmd>lua require('mini.bufremove').delete(0)<cr>", { desc = "Delete buffer" })
map("n", "<c-q>", "<cmd>qa!<cr>", { desc = "Quit nvim" })
map("n", "<a-q>", "<cmd>q!<cr>", { desc = "Quit buffer" })

-- MOVEMENT
-- insert-mode cursor movement
map("i", "<a-k>", "<up>", { desc = "Move up" })
map("i", "<a-j>", "<down>", { desc = "Move down" })
-- word movement
map({ "n", "v" }, "<a-h>", "b", { desc = "Beginning of word" })
map({ "n", "v" }, "<a-l>", "e", { desc = "End of word" })
-- line movement
map("i", "<c-b>", "<esc><s-i>", { desc = "Beginning of line" })
map("i", "<c-e>", "<end>", { desc = "End of line" })
map({ "n", "i" }, "<a-;>", "<esc><s-a>;", { desc = "End of line -> ';'" })
map({ "n", "i" }, "<a-,>", "<esc><s-a>,", { desc = "End of line -> ','" })
map("i", "<a-[>", "<esc><s-a> {}<left>", { desc = "End of line -> '{'" })
map("n", "<a-u>", "gg0i<cr><esc>k", { desc = "New line at beginning of file" })
map("i", "<a-u>", "<esc>gg0i<cr><esc>ki", { desc = "New line at beginning of file" })
map("i", "<c-o>", "<esc>o", { desc = "New line below" })

-- TEXT MANIPULATION
-- words
map("i", "<a-l>", "<del>", { desc = "Delete previous char" })
map("i", "<a-h>", "<bs>", { desc = "Delete next char" })
map("i", "<c-h>", "<c-w>", { desc = "Delete previous word" })
map("i", "<c-l>", "<esc>ldwi", { desc = "Delete next word" })
-- lines
map("n", "<a-j>", ":m .+1<cr>", { desc = "Move line down" })
map("n", "<a-k>", ":m .-2<cr>", { desc = "Move line up" })
map("v", "<a-j>", ":m '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "<a-k>", ":m '<-2<cr>gv=gv", { desc = "Move selection up" })
-- duplication
map("n", "<s-j>", "mayyp`aj", { desc = "Duplicate line" })
map("v", "<s-j>", "y'>p", { desc = "Duplicate selection" })

-- LSP
map("n", "<a-r>", "<cmd>LspRestart<cr>", { desc = "Restart LSP" })
map("n", "<s-d>", "<cmd>Lspsaga hover_doc<cr>", { desc = "Hover doc" })
map("n", "<s-f>", "<cmd>Lspsaga finder<cr>", { desc = "Finder" })
map("n", "<s-r>", "<cmd>Lspsaga rename<cr>", { desc = "Rename" })
map("n", "<s-t>", "<cmd>Lspsaga peek_type_definition<cr>", { desc = "Peek type definition" })
map("n", "<s-o>", "<cmd>Lspsaga outline<cr>", { desc = "Outline" })
map("n", "<s-p>", "<cmd>Lspsaga peek_definition<cr>", { desc = "Peek definition" })
map("n", "<a-[>", "<cmd>Lspsaga diagnostic_jump_prev<cr>", { remap = true, desc = "Jump to previous diagnostic" })
map("n", "<a-]>", "<cmd>Lspsaga diagnostic_jump_next<cr>", { remap = true, desc = "Jump to next diagnostic" })
map("n", "<c-i>", "<cmd>TroubleToggle<cr>", { desc = "Toggle global diagnostics" })
