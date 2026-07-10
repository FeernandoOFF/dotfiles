return {
  {
    "AlexandrosAlexiou/kotlin.nvim",
    ft = "kotlin",
    dependencies = {
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "stevearc/oil.nvim",
      "folke/trouble.nvim",
    },
    opts = {
      root_markers = {
        "settings.gradle",
        "settings.gradle.kts",
        "build.gradle",
        "build.gradle.kts",
        "pom.xml",
        "mvnw",
        "gradlew",
        ".git",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers.kotlin_lsp = { enabled = false }
      opts.servers.kotlin_language_server = { enabled = false }
      vim.list_extend(opts.servers["*"].keys, {
        {
          "gd",
          function()
            require("telescope.builtin").lsp_definitions({ reuse_win = true })
          end,
          desc = "Go to definition",
          has = "definition",
        },
        {
          "gu",
          function()
            require("telescope.builtin").lsp_references()
          end,
          desc = "Go to usages",
          has = "references",
        },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "kotlin-lsp" } },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kotlin" } },
  },
}
