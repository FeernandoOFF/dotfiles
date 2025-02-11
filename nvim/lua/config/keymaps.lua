local Util = require("lazyvim.util")

local lazyterm = function()
  Util.terminal(nil, { cwd = Util.root() })
end

vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>2", lazyterm, { desc = "Terminal (root dir)" })

vim.keymap.set("n", "<leader>p", function(command, opts)
  LazyVim.pick.open(command, vim.deepcopy(opts))
end, {
  desc = "Command palette",
})

vim.keymap.set("n", "<leader>P", function()
  Snacks.picker.keymaps()
end, { desc = "Keymaps" })

-- LSP actions
-- vim.keymap.set("n", "gi", "<Cmd>Telescope lsp_references<CR>", { desc = "Go to usage" })
-- vim.keymap.set("n", "cd", "<Cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename" })

-- Centering on movement
vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("n", "n", "nzzzv")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
-- vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("v", "<C-k>", ":m '<-2<CR>gv=gv", { silent = true })
vim.keymap.set("v", "<C-j>", ":m '>+1<CR>gv=gv", { silent = true })

-- Tmux workspaces
-- local workspace = require("workspace")
-- vim.keymap.set("n", "<C-f>", workspace.tmux_sessions)

-- Jump lists

vim.keymap.set("n", "gb", "<C-o>", { desc = "Jump to previous location in jumplist" })

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
