return {
  -- iOS Support
  {
    "wojciech-kulik/xcodebuild.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
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
    },
    keys = {
      { "<leader>xm", "<cmd>XcodebuildPicker<cr>", desc = "Xcode menu (all actions)" },
      { "<leader>xt", "<cmd>XcodebuildSelectScheme<cr>", desc = "Xcode select scheme" },
      { "<leader>xo", "<cmd>XcodebuildSelectDevice<cr>", desc = "Xcode select device" },
      { "<leader>xa", "<cmd>XcodebuildCodeActions<cr>", desc = "Xcode code actions" },
      { "<leader>xb", "<cmd>XcodebuildBuildRun<cr>", desc = "Xcode build & run" },
      { "<leader>xl", "<cmd>XcodebuildToggleLogs<cr>", desc = "Xcode logs" },
    },
    config = function()
      require("xcodebuild").setup({})
    end,
  },
}
