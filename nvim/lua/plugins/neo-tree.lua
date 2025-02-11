local Util = require("lazyvim.util")

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            source = "filesystem",
            position = "right",
          })
        end,
        desc = "Neotree reveal current fle",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({
            toggle = true,
            source = LazyVim.root(),
            position = "right",
          })
        end,
        desc = "Neotree reveal current fle",
      },
    },
    opts = {},
  },
}
