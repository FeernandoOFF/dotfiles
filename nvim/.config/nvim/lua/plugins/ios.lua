return {
  -- iOS Support
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "folke/snacks.nvim", -- to show previews
    },
    ft = { "swift", "objc" },
    cmd = {
      "XcodebuildSetup",
      "XcodebuildPicker",
      "XcodebuildBuild",
      "XcodebuildBuildRun",
      "XcodebuildRun",
      "XcodebuildCancel",
      "XcodebuildTest",
      "XcodebuildSelectScheme",
      "XcodebuildSelectDevice",
      "XcodebuildSelectTestPlan",
      "XcodebuildToggleLogs",
      "XcodebuildProjectManager",
      "XcodebuildPreviewGenerateAndShow",
      "XcodebuildPreviewShow",
      "XcodebuildPreviewHide",
      "XcodebuildPreviewToggle",
    },
    keys = {
      { "<leader>xm", "<cmd>XcodebuildPicker<cr>", desc = "Xcode menu (all actions)" },
      { "<leader>xt", "<cmd>XcodebuildSelectScheme<cr>", desc = "Xcode select scheme" },
      { "<leader>xo", "<cmd>XcodebuildSelectDevice<cr>", desc = "Xcode select device" },
      { "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Xcode code actions" },
      { "<leader>xb", "<cmd>XcodebuildBuildRun<cr>", desc = "Xcode build & run" },
      { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Xcode logs" },
      { "<leader>xp", "<cmd>XcodebuildPreviewGenerateAndShow<cr>", desc = "Xcode preview (generate & show)" },
      { "<leader>xP", "<cmd>XcodebuildPreviewToggle<cr>", desc = "Xcode preview toggle" },
    },
    config = function()
      require("xcodebuild").setup({})
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = { dynamicRegistration = true },
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "swift" } },
  },
}
