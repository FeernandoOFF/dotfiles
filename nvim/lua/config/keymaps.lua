local Util = require("lazyvim.util")

local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end

-- Save file with space w
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
-- Pane management

vim.keymap.set("n", "<C-w>", "<cmd>vsplit<cr>", { desc = "Split window right" })

vim.keymap.set("n", "<leader>2", lazyterm, { desc = "Terminal (root dir)" })

vim.keymap.set("n", "<leader>p", function(command, opts)
  LazyVim.pick.open(command, vim.deepcopy(opts))
end, {
  desc = "Command palette",
})

vim.keymap.set("n", "<leader>P", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })
-- MOVEMENT  & Navigation

-- Centering on movement
-- vim.keymap.set("n", "J", "mzJ`z")
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")
-- vim.keymap.set("n", "N", "Nzzzv")
-- vim.keymap.set("n", "n", "nzzzv")

-- Code Actions
-- vim.keymap.set("n", "gi", "<Cmd>Telescope lsp_references<CR>", { desc = "Go to usage" })
-- vim.keymap.set("n", "cd", "<Cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })

-- Move selected block on visual mode
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })

-- Indent with Tab and de-indent with Shift+Tab in visual mode
vim.keymap.set("v", "<Tab>", ">gv", { desc = "Indent selected text" })
vim.keymap.set("v", "<S-Tab>", "<gv", { desc = "De-indent selected text" })

-- Paste & Delete?
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

-- Tmux workspaces
-- local workspace = require("workspace")
-- vim.keymap.set("n", "<C-f>", workspace.tmux_sessions)

-- Jump lists
vim.keymap.set("n", "gd", function()
  require("telescope.builtin").lsp_definitions({ reuse_win = true })
end, { desc = "Go to definition" })
vim.keymap.set("n", "gu", function()
  require("telescope.builtin").lsp_references()
end, { desc = "Go to usages" })
vim.keymap.set("n", "gb", "<C-o>", { desc = "Jump to previous location in jumplist" })
vim.keymap.set("n", "gf", "<C-i>", { desc = "Jump to next location in jumplist" })

-- Set jumplist when moveing more than 3 lines
vim.keymap.set(
  "n",
  "j",
  [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'j' : 'gj']],
  { noremap = true, expr = true }
)
vim.keymap.set(
  "n",
  "k",
  [[v:count ? (v:count >= 3 ? "m'" . v:count : '') . 'k' : 'gk']],
  { noremap = true, expr = true }
)

-- INTELLIJ Mappings

-- vim.keymap.set("n", "<M-p>", "<leader>ff", { desc = "File picker" })
-- vim.keymap.set("n", "<M-P>", "<cmd>vsplit<cr>", { desc = "Split window right" })

vim.keymap.set("n", "<M-p>", function()
  LazyVim.pick.open(command, vim.deepcopy(opts))
end, { noremap = true, silent = true, desc = "Search Files" })

vim.keymap.set("n", "<M-P>", function()
  Snacks.picker.keymaps()
end, { noremap = true, silent = true, desc = "Search commands" })

vim.keymap.set("n", "<M-e>", function()
  Snacks.explorer()
end, { noremap = true, silent = true, desc = "Open Explorer" })

vim.keymap.set("n", "<M-E>", function()
  Snacks.explorer({ cwd = LazyVim.root() })
end, { noremap = true, silent = true, desc = "Open Explorer (Relative)" })

vim.keymap.set("n", "<M-F>", function()
  Snacks.picker.grep_buffers()
end, { noremap = true, silent = true, desc = "Find everywhere" })

vim.keymap.set("n", "<M-g>", function()
  Snacks.lazygit({ cwd = LazyVim.root.git() })
end, { noremap = true, silent = true, desc = "Open Git" })

vim.keymap.set("n", "<M-t>", function()
  Util.terminal(nil, { cwd = Util.root() })
end, { noremap = true, silent = true, desc = "Open Terminal" })
