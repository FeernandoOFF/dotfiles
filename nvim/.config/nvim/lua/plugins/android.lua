return {
  -- Android Support
  {
    "iamironz/android-nvim-plugin",
    cmd = {
      "AndroidMenu",
      "AndroidTargets",
      "AndroidTools",
      "AndroidActions",
      "AndroidBuild",
      "AndroidBuildPrompt",
      "AndroidBuildAssemble",
      "AndroidRun",
      "AndroidRunStop",
      "AndroidLogcat",
      "AndroidGradleTasks",
    },
    keys = {
      { "<leader>am", "<cmd>AndroidMenu<cr>", desc = "Android menu" },
      { "<leader>at", "<cmd>AndroidTargets<cr>", desc = "Android build variants" },
      { "<leader>ao", "<cmd>AndroidTools<cr>", desc = "Android devices & ADB" },
      { "<leader>aa", "<cmd>AndroidActions<cr>", desc = "Android actions" },
      { "<leader>ab", "<cmd>AndroidBuild<cr>", desc = "Android build & deploy" },
      { "<leader>al", "<cmd>AndroidLogcat<cr>", desc = "Android logcat" },
    },
    config = function()
      require("android").setup({
        sdk = {
          root = vim.fn.expand("~/Library/Android/sdk"),
        },
        keymaps = {
          enabled = false,
        },
      })
    end,
  },
}
