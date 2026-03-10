return {
  {
    "swaits/zellij-nav.nvim",
    lazy = false,
    cmd = {
      "ZellijNavigateLeft",
      "ZellijNavigateDown",
      "ZellijNavigateUp",
      "ZellijNavigateRight",
      "ZellijNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>ZellijNavigateLeft<cr>", desc = "Move focus left" },
      { "<c-j>", "<cmd>ZellijNavigateDown<cr>", desc = "Move focus down" },
      { "<c-k>", "<cmd>ZellijNavigateUp<cr>", desc = "Move focus up" },
      { "<c-l>", "<cmd>ZellijNavigateRight<cr>", desc = "Move focus right" },
      { "<c-\\>", "<cmd>ZellijNavigatePrevious<cr>", desc = "Move focus previous" },
    },
    init = function()
      if not (vim.env.ZELLIJ and vim.fn.executable("zellij") == 1) then
        return
      end

      local function switch_mode(mode)
        vim.fn.jobstart({ "zellij", "action", "switch-mode", mode }, { detach = true })
      end

      local mode_group = vim.api.nvim_create_augroup("zellij_nvim_mode", { clear = true })

      vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, {
        group = mode_group,
        callback = function()
          switch_mode("locked")
        end,
      })

      vim.api.nvim_create_autocmd("VimLeavePre", {
        group = mode_group,
        callback = function()
          switch_mode("normal")
        end,
      })

      if vim.v.vim_did_enter == 1 then
        switch_mode("locked")
      end
    end,
    config = function()
      require("zellij-nav").setup()
    end,
  },
}
