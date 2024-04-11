return {
  {
    "mfussenegger/nvim-lint",
    event = "VeryLazy",
    config = function()
      require("lint").linters_by_ft = {
        javascript = { "biomejs", "eslint_d", "eslint" },
        typescript = { "biomejs", "eslint_d", "eslint" },
        kotlin = { "ktlint" },
      }
    end,
  },
}
