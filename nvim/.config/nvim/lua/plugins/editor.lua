return {
  -- Syntax highlighting
  -- If you'd rather extend the default config, use the code below instead:
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    opts = function(_, opts)
      -- add tsx and treesitter
      vim.list_extend(opts.ensure_installed, {
        "tsx",
        "typescript",
        "svelte",
        "bash",
        "html",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "query",
        "regex",
        "tsx",
        "vim",
        "yaml",
        "python",
        "javascript",
        "typescript",
        "svelte",
        "go",
      })
    end,
  },

  -- LSPs
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",

        "stylua",
        "shellcheck",

        "svelte-language-server",
        "biome",
      },
    },
  },

  -- change lsptrouble config
  { "folke/trouble.nvim" },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
      -- stylua: ignore
      {
        "<leader>fr",
        function() require("telescope.builtin").oldfiles() end,
        desc = "Recent Files (Telescope)",
      },
      -- stylua: ignore
      {
        "<leader>sF",
        function()
          require("telescope.builtin").live_grep({
            cwd = vim.fn.expand("%:p:h"),
            prompt_title = "Grep in " .. vim.fn.fnamemodify(vim.fn.expand("%:p:h"), ":~:."),
          })
        end,
        desc = "Grep in current file's folder",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
    },
  },

  -- add jsonls and schemastore packages, and setup treesitter for json, json5 and jsonc
  { import = "lazyvim.plugins.extras.lang.json" },
}
