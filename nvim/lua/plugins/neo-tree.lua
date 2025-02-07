local Util = require("lazyvim.util")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      { "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Neotree reveal current fle" },
    },
    opts = {
      event_handlers = {

        {
          event = "file_opened",
          handler = function(file_path)
            require("neo-tree.command").execute({ action = "close" })
          end,
        },
      },
    },
    config = function()
      require("neo-tree").setup({
        filesystem = {
          group_empty_dirs = true,
        },
        buffers = {
          group_empty_dirs = true,
        },
      })

      vim.g.nvim_tree_group_empty = 1

      require("neo-tree.command").execute({ action = "close" })
    end,
  },
}
