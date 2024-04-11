return {
  {
    "stevearc/conform.nvim",
    opts = function()
      local opts = {
        ---@type table<string, conform.FormatterUnit[]>
        formatters_by_ft = {
          lua = { "stylua" },
          fish = { "fish_indent" },
          sh = { "shfmt" },
          javascript = { { "biome", "prettierd", "prettier" } },
          typescript = { { "biome", "prettierd", "prettier" } },
        },
        ---@type table<string, conform.FormatterConfigOverride|fun(bufnr: integer): nil|conform.FormatterConfigOverride>
        formatters = {
          injected = { options = { ignore_errors = true } },
        },
      }
      return opts
    end,
  },
}
