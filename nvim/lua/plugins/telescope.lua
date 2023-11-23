return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>p", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>F", "<cmd>Telescope live_grep<cr>", desc = "Find Words in Project" },
    { "<leader>P", "<cmd>Telescope keymaps<cr>", desc = "Find keybindings or Actions" },
  },
}
