local keymap = vim.keymap
local lvimKeys = lvim.keys

lvimKeys.normal_mode["<C-s>"] = ":w<cr>"


-- Key Bindings
--
lvimKeys.normal_mode["s"] = false
lvimKeys.normal_mode["}"] = false

-- Escape
keymap.set("i", "jk", "<ESC>", { silent = true })

keymap.set("n", "x", '"_x')

-- Cycle trough Buffers
lvimKeys.normal_mode["<S-h>"] = "<cmd>BufferLineCyclePrev<cr>"
lvimKeys.normal_mode["<S-l>"] = "<cmd>BufferLineCycleNext<cr>"


-- Split panels

lvimKeys.normal_mode["<leader>sv"] = "<C-w>v"
lvimKeys.normal_mode["<leader>sh"] = "<C-w>s"
lvimKeys.normal_mode["<leader>se"] = "<C-w>="
lvimKeys.normal_mode["<leader>sx"] = ":lose<CR>"
