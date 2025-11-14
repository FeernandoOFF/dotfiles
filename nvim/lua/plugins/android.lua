return {
  -- Android Support
  {
    "ariedov/android-nvim",
    config = function()
      -- OPTIONAL: specify android sdk directory
      require("android-nvim").setup()
      vim.g.android_sdk = "~/Library/Android/sdk"
    end,
  },
}
